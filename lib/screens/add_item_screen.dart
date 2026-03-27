import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? itemData;

  AddItemScreen({super.key, this.docId, this.itemData});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.itemData != null) {
      nameController.text = widget.itemData!['name'];
      qtyController.text = widget.itemData!['quantity'].toString();
      priceController.text = widget.itemData!['price'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Item name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: qtyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  labelText: "Quantity",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter quantity";
                  }
                  if (int.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Price";
                  }
                  if (int.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.docId == null) {
                        addItem();
                      } else {
                        updateItem();
                      }
                    }
                  },
                  child: Text(
                    widget.docId == null ? "Add Item" : "Update Item",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addItem() async {
    await FirebaseFirestore.instance.collection("items").add({
      "name": nameController.text.trim(),
      "quantity": int.parse(qtyController.text.trim()),
      "price": int.parse(priceController.text.trim()),
      "created": DateTime.now(),
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Item Added")));

    Navigator.pop(context);
  }

  updateItem() async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(widget.docId)
        .update({
          "name": nameController.text.trim(),
          "quantity": int.parse(qtyController.text.trim()),
          "price": int.parse(priceController.text.trim()),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Item Updated")));

    Navigator.pop(context);
  }

}
