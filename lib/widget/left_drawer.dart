import 'package:flutter/material.dart';
import 'package:football_shop/screens/menu.dart';
import 'package:football_shop/screens/add_product_form.dart';
import 'package:football_shop/screens/product_list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          _DrawerHeader(),
          _DrawerHomeTile(),
          _DrawerAddProductTile(),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      child: Column(
        children: [
          Text(
            'Football Shop',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Text(
            'Buy and list football merch with ease.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHomeTile extends StatelessWidget {
  const _DrawerHomeTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.home_outlined),
      title: const Text('Home'),
      // Redirect to MyHomePage with pushReplacement (per tutorial)
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
    );
  }
}

class _DrawerAddProductTile extends StatelessWidget {
  const _DrawerAddProductTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.post_add),
      title: const Text('Add Product'),
      // Redirect to AddProductFormPage with pushReplacement (per tutorial)
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductFormPage(),
          ),
        );
      },
    );
  }
}
