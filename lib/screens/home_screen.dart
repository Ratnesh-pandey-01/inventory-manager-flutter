import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:inventry_manager_app/screens/add_item_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventry Manager")),
      body:
          //Center(child: Text("No Items Yet", style: TextStyle(fontSize: 18))),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("items").snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var data = snapshots.data!.docs;
              if (data.isEmpty) {
                return Center(child: Text("No Items"));
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var item = data[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(
                      "Qty: ${item['quantity']}  Price: ${item['price']}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddItemScreen(
                                  docId: item.id,
                                  itemData: item.data(),
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("items")
                                .doc(item.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Item Deleted")),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
         

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
