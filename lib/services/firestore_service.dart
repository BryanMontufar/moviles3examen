mport 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String name;
  int quantity;

  Item({required this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  static Item fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}

class FirestoreService {
  Stream<List<Item>> getItems() {
    return FirebaseFirestore.instance.collection('items').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Item.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addItem(Item item) async {
    await FirebaseFirestore.instance.collection('items').add(item.toMap());
  }

  Future<void> updateItem(Item item) async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();
  }
}