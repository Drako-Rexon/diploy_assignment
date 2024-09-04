import 'package:diploy_assignment/providers/product_provider.dart';
import 'package:diploy_assignment/screens/detailed_projects_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productProvider.cartItems.length,
                    itemBuilder: (ctx, index) {
                      final prod = productProvider.products[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailedProductPage(
                                      id: productProvider.products[index].id)));
                        },
                        child: ListTile(
                          trailing: InkWell(
                            onTap: () {
                              productProvider.removeFromCart(prod);
                              setState(() {});
                            },
                            child: const Icon(Icons.delete),
                          ),
                          leading: Container(
                            height: 100,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: Image.network(productProvider
                                            .products[index].image)
                                        .image)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          title: Text(
                            productProvider.products[index].title,
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            productProvider.products[index].description,
                            maxLines: 2,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
