import 'package:diploy_assignment/providers/product_provider.dart';
import 'package:diploy_assignment/screens/cart_page.dart';
import 'package:diploy_assignment/screens/detailed_projects_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    _isLoading = true;
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.getAllProducts();
    _isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100.withOpacity(0.6),
        title: const Text('Product List'),
        actions: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartPage()));
                },
                child: const Icon(
                  Icons.trolley,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
              Container(
                height: 14,
                width: 14,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    productProvider.cartItems.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.teal),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Search',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchController.text.isEmpty
                        ? productProvider.products.length
                        : productProvider
                            .searchProducts(_searchController.text)
                            .length,
                    itemBuilder: (ctx, index) {
                      final prod = _searchController.text.isEmpty
                          ? productProvider.products[index]
                          : productProvider
                              .searchProducts(_searchController.text)[index];
                      bool isInCart = !productProvider.cartItems.where((item) {
                        if (item.id == prod.id) return true;
                        return false;
                      }).isNotEmpty;

                      return ListTile(
                        trailing: InkWell(
                          onTap: () {
                            productProvider.addToCart(prod);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.trolley,
                            color: isInCart ? Colors.grey : Colors.teal,
                          ),
                        ),
                        leading: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailedProductPage(
                                        id: productProvider
                                            .products[index].id)));
                          },
                          child: Container(
                            height: 100,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: Image.network(
                                            _searchController.text.isEmpty
                                                ? productProvider
                                                    .products[index].image
                                                : productProvider
                                                    .searchProducts(
                                                        _searchController
                                                            .text)[index]
                                                    .image)
                                        .image)),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        title: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailedProductPage(
                                        id: productProvider
                                            .products[index].id)));
                          },
                          child: Text(
                            _searchController.text.isEmpty
                                ? productProvider.products[index].title
                                : productProvider
                                    .searchProducts(
                                        _searchController.text)[index]
                                    .title,
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        subtitle: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailedProductPage(
                                        id: productProvider
                                            .products[index].id)));
                          },
                          child: Text(
                            _searchController.text.isEmpty
                                ? productProvider.products[index].description
                                : productProvider
                                    .searchProducts(
                                        _searchController.text)[index]
                                    .description,
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
