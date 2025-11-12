import 'package:flutter/material.dart';
// ADDED: import your Add Product form page (adjust the path if you placed it elsewhere)
import 'add_product_form.dart';
import 'package:football_shop/models/product.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String name = "Khayru Rafa Kartajaya";
  final String npm = "2406365263";
  final String Studentclass = "KKI";

  final List<ItemHomepage> items = [
    ItemHomepage("All Products", Icons.shopping_bag, Colors.blue),
    ItemHomepage("My Products", Icons.inventory, Colors.green),
    ItemHomepage("Create Product", Icons.add, Colors.red),
  ];

  final List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar halaman dengan AppBar dan body.
    return Scaffold(
      // AppBar adalah bagian atas halaman yang menampilkan judul.
      appBar: AppBar(
        // Judul aplikasi "Football News" dengan teks putih dan tebal.
        title: const Text(
          'Football News',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      // ADDED: Drawer untuk navigasi Home & Add Product (mengikuti tutorial)
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  Text(
                    'Football News',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "All the latest football updates here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              // Redirect to MyHomePage menggunakan pushReplacement (sesuai tutorial)
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add),
              title: const Text('Add Product'),
              // Redirect ke halaman form Add Product
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductFormPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Body halaman dengan padding di sekelilingnya.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Kolom untuk menampilkan kartu data diri dan grid tombol fitur.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu informasi pengguna
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: $name", style: const TextStyle(fontSize: 16)),
                    Text("NPM: $npm", style: const TextStyle(fontSize: 16)),
                    Text("Class: $Studentclass", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Grid tombol fitur (All Products, My Products, Create Product)
            Expanded(
              child: Column(
                children: [
                  // actions grid
                  SizedBox(
                    height: 240,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: items
                          .map((item) => ItemCard(
                                item: item,
                                onTap: () async {
                                  // handle create product action
                                  if (item.name == "Create Product") {
                                    final result = await Navigator.push<Product?>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddProductFormPage(),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _products.add(result);
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(SnackBar(content: Text("You pressed the ${item.name} button!")));
                                  }
                                },
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // products grid
                  if (_products.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, idx) {
                          final p = _products[idx];
                          return Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (p.thumbnail.isNotEmpty)
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Image.network(
                                        p.thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, st) => const Center(child: Icon(Icons.broken_image)),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('Price: ${p.price}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, this.onTap});

  final ItemHomepage item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 40),
              const SizedBox(height: 12),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
