import 'dart:convert';
import 'dart:developer';

import 'package:diploy_assignment/models/product_mode.dart';
import 'package:diploy_assignment/providers/http_provider.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [];
  final List<ProductModel> _cartItems = [];

  //* getters
  List<ProductModel> get products => _products;
  List<ProductModel> get cartItems => _cartItems;

  Future<void> getAllProducts() async {
    try {
      final response = await request('get', '/products');
      if (response.statusCode == 200) {
        final products = jsonDecode(response.body);
        _products.clear();
        products.forEach((product) {
          _products.add(ProductModel.fromJson(product));
        });
        notifyListeners();
      }
    } catch (err) {
      log(err.toString());
    } finally {}
  }

  Future<ProductModel?> getProduct(int id) async {
    try {
      final response = await request('get', '/products/$id');
      if (response.statusCode == 200) {
        notifyListeners();
        return ProductModel.fromJson(jsonDecode(response.body));
      }
    } catch (err) {
      log(err.toString());
    } finally {}
    return null;
  }

  List<ProductModel> searchProducts(String query) {
    final results = _products.where((product) {
      final nameLower = product.title.toLowerCase();
      final descriptionLower = product.description.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          descriptionLower.contains(searchLower);
    }).toList();
    return results;
  }

  void addToCart(ProductModel product) {
    try {
      _cartItems.add(product);
      notifyListeners();
    } catch (err) {
      log(err.toString());
    }
  }

  void removeFromCart(ProductModel product) {
    try {
      _cartItems.remove(product);
      notifyListeners();
    } catch (err) {
      log(err.toString());
    }
  }
}
