import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
 
class Home extends StatelessWidget {
  const Home({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              onPressed: () => AuthService().signOut(),
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: StreamBuilder<List<Item>>(
          stream: FirestoreService().getItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  leading: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddItemScreen(),
                        ),
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => FirestoreService().deleteItem(item.id),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddItemScreen(item: item),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddItemScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
 
class AddItemScreen extends StatefulWidget {
  final Item? item;
  const AddItemScreen({super.key, this.item});
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}
 
class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  late String _id;
  bool _isEditing = false;
 
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _isEditing = true;
      _name = widget.item!.name;
      _quantity = widget.item!.quantity;
      _id = widget.item!.id;
    } else {
      _name = '';
      _quantity = 0;
      _id = '';
    }
  }
 
  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
 
      final item = Item(
        id: _id,
        name: _name,
        quantity: _quantity,
      );
 
      if (_isEditing) {
        await FirestoreService().updateItem(item);
      } else {
        await FirestoreService().addItem(item);
      }
 
      Navigator.of(context).pop();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Item' : 'Agregar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Item'),
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                initialValue: _quantity.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantity = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(_isEditing ? 'Actualizar Item' : 'Agregar Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}