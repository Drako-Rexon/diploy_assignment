import 'package:diploy_assignment/models/product_mode.dart';
import 'package:diploy_assignment/providers/product_provider.dart';
import 'package:diploy_assignment/utils/asset_name.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DetailedProductPage extends StatefulWidget {
  const DetailedProductPage({
    super.key,
    required this.id,
  });
  final int id;

  @override
  State<DetailedProductPage> createState() => _DetailedProductPageState();
}

class _DetailedProductPageState extends State<DetailedProductPage> {
  bool _isLoading = false;
  ProductModel? product;

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  Future<void> getProduct() async {
    _isLoading = true;
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final response = await productProvider.getProduct(widget.id);
    setState(() {
      product = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
              ? Lottie.asset(AnimationAddress.notFound)
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      children: [
                        Image.network(
                          product!.image,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: Lottie.asset(AnimationAddress.notFound),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product!.title.toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product!.description.toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Wrap(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                  ),
                                  child: Text(
                                    product!.category,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                  ),
                                  child: Text(
                                    '₹ ${product!.price}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                  ),
                                  child: Text(
                                    '⭐ ${product!.rating.rate}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
    );
  }
}
