import 'package:flutter/material.dart';
import 'package:football_shop/widget/left_drawer.dart';
import 'package:football_shop/models/product.dart';

// Tutorial variant adapted to Football Shop: name, price, description (+ category, thumbnail, featured)
class AddProductFormPage extends StatefulWidget {
  const AddProductFormPage({super.key});

  @override
  State<AddProductFormPage> createState() => _AddProductFormPageState();
}

class _AddProductFormPageState extends State<AddProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _descC = TextEditingController();
  final TextEditingController _thumbC = TextEditingController();

  String _category = 'kit';
  bool _isFeatured = false;

  final List<String> _categories = [
    'kit',
    'boots',
    'ball',
    'accessory',
    'poster',
    'other',
  ];

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    _descC.dispose();
    _thumbC.dispose();
    super.dispose();
  }

  bool _validUrlOrEmpty(String v) {
    if (v.trim().isEmpty) return true; // optional field
    final uri = Uri.tryParse(v.trim());
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title styling similar to the tutorial
        title: const Center(child: Text('Add Product Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // Add the drawer here (tutorial requirement)
      drawer: const LeftDrawer(),
      body: Form(
        // Handle form state/validation (tutorial requirement)
        key: _formKey,
        child: SingleChildScrollView(
          // Ensure scrollable (tutorial requirement)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameC,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (String? value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return "Name cannot be empty!";
                    if (v.length < 3) return "Name must be at least 3 characters.";
                    if (v.length > 80) return "Name max length is 80.";
                    return null;
                  },
                ),
              ),

              // === Price ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _priceC,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Price (e.g., 350000)",
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (String? value) {
                    final raw = (value ?? '').trim();
                    if (raw.isEmpty) return "Price cannot be empty!";
                    final n = num.tryParse(raw);
                    if (n == null) return "Price must be a valid number.";
                    if (n < 0) return "Price cannot be negative.";
                    if (n > 100000000) return "Price too large.";
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descC,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Product Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (String? value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return "Description cannot be empty!";
                    if (v.length < 10) {
                      return "Description must be at least 10 characters.";
                    }
                    if (v.length > 500) return "Description max length is 500.";
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category,
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat[0].toUpperCase() + cat.substring(1)),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue ?? 'kit';
                    });
                  },
                ),
              ),

              // === Thumbnail URL (optional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _thumbC,
                  decoration: InputDecoration(
                    hintText: "Thumbnail URL (optional)",
                    labelText: "Thumbnail URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (String? value) {
                    final v = value?.trim() ?? '';
                    if (!_validUrlOrEmpty(v)) {
                      return "Enter a valid URL or leave empty.";
                    }
                    if (v.length > 200) return "URL max length is 200.";
                    return null;
                  },
                ),
              ),

              // === Featured switch ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SwitchListTile(
                  title: const Text("Mark as Featured Product"),
                  value: _isFeatured,
                  onChanged: (bool value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                ),
              ),

              // === Save Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      // Build product instance from form values
                      final name = _nameC.text.trim();
                      final priceRaw = _priceC.text.trim();
                      final description = _descC.text.trim();
                      final thumbnail = _thumbC.text.trim();
                      final priceNum = num.tryParse(priceRaw) ?? 0;

                      final created = Product(
                        name: name,
                        price: priceNum,
                        description: description,
                        category: _category,
                        thumbnail: thumbnail,
                        isFeatured: _isFeatured,
                      );

                      // Ask for confirmation, then return the created product to caller
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Product saved successfully!'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (thumbnail.isNotEmpty && _validUrlOrEmpty(thumbnail))
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: SizedBox(
                                        height: 150,
                                        width: double.infinity,
                                        child: Image.network(
                                          thumbnail,
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.broken_image)),
                                        ),
                                      ),
                                    ),
                                  Text('Name: $name'),
                                  Text('Price: ${created.price}'),
                                  const SizedBox(height: 8),
                                  Text('Description:'),
                                  Text(description),
                                  const SizedBox(height: 8),
                                  Text('Category: ${created.category}'),
                                  Text('Thumbnail: ${thumbnail.isEmpty ? "(none)" : thumbnail}'),
                                  Text('Featured: ${created.isFeatured ? "Yes" : "No"}'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        // Pop the form page and return the created product
                        Navigator.of(context).pop(created);
                        // no need to reset here since we're leaving the page; caller can handle state
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
