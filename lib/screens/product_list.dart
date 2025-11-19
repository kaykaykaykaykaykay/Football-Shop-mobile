import 'package:flutter/material.dart';
import 'package:football_shop/models/product.dart';
import 'package:football_shop/widget/left_drawer.dart';
import 'package:football_shop/screens/product_details.dart';
import 'package:football_shop/widget/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Currently we don't fetch remote products; return an empty list.
  // If you want to fetch from a backend, implement the network call here.
  Future<List<Product>> fetchProducts() async {
    return <Product>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? <Product>[];
          if (data.isEmpty) {
            return const Center(
              child: Text(
                'There are no products yet.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => ProductCard(
              product: data[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: data[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}