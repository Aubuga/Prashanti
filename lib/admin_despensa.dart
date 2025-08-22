import 'package:flutter/material.dart';
import '../models/producto.dart'; // import product model
import '../services/producto_service.dart'; // import the service for implementation in _saveProductos
import '../services/producto_remote_service.dart';
class AdminDespensaPage extends StatefulWidget {
  const AdminDespensaPage({super.key});

  @override
  State<AdminDespensaPage> createState() => _AdminDespensaPageState();

}
// Product form as a bottom sheet
Future<void> showProductoForm({
  required BuildContext context,
  required Producto producto,
  required void Function(Producto updatedProducto) onSave,
}) async {
  final nombreController = TextEditingController(text: producto.nombre);
  final descripcionController = TextEditingController(text: producto.descripcion);
  final precioController = TextEditingController(text: producto.precio.toString());
  final stockController = TextEditingController(text: producto.stock.toString());
  final imageUrlController = TextEditingController(text: producto.imageUrl);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'URL de imagen'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final updated = Producto(
                      nombre: nombreController.text.trim(),
                      descripcion: descripcionController.text.trim(),
                      precio: double.tryParse(precioController.text.trim()) ?? 0.0,
                      stock: int.tryParse(stockController.text.trim()) ?? 0,
                      imageUrl: imageUrlController.text.trim(),
                    );
                    onSave(updated);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
} //END OF PRODUCT FORM

class _AdminDespensaPageState extends State<AdminDespensaPage> {
  // Temporary in-memory list of products
  List<Producto> productos = [
    Producto(
      nombre: 'Yerba Mate',
      descripcion: 'Yerba orgánica 500g',
      precio: 2500.0,
      stock: 12,
      imageUrl: 'https://via.placeholder.com/80',
    ),
    Producto(
      nombre: 'Harina Integral',
      descripcion: 'Harina de trigo 1kg',
      precio: 1500.0,
      stock: 8,
      imageUrl: 'https://via.placeholder.com/80',
    ),
  ];

 final _remote = ProductoRemoteService();

@override
void initState() {
  super.initState();
  _load();
}

Future<void> _load() async {
  try {
    final fetched = await _remote.fetchProductos();
    setState(() {
      productos = fetched; // replace the initial hardcoded list
    });
  } catch (e) {
    // optionally show a SnackBar
  }
} 

void _addProducto() { //ADD PRODUCTO WITH THE FORM NOW
  final nuevo = Producto(
    nombre: '',
    descripcion: '',
    precio: 0.0,
    stock: 0,
    imageUrl: '',
  );
  showProductoForm(
    context: context,
    producto: nuevo,
    onSave: (nuevoProducto) {
      setState(() {
        productos.add(nuevoProducto);
      });
    },
  );
}


  void _editProducto(int index) {  //OPEN EDIT FORM 
  final productoActual = productos[index];
  showProductoForm(
    context: context,
    producto: productoActual,
    onSave: (updatedProducto) {
      setState(() {
        productos[index] = updatedProducto;
      });
    },
  );
}

Future<void> _saveProductos() async {
  try {
    final data = productos.map((p) => p.toMap()).toList();
    await _remote.saveProductos(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Productos guardados en Supabase')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error guardando productos: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despensa - Prashanti Coliving (Admin)'),
        centerTitle: true,
      actions: [
  IconButton(
    icon: const Icon(Icons.refresh),
    tooltip: 'Refrescar',
    onPressed: _load,
  ),
  IconButton(
    icon: const Icon(Icons.save),
    tooltip: 'Guardar productos',
    onPressed: _saveProductos, // still local/snackbar
  ),
],

      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                producto.imageUrl,
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
              title: Text(producto.nombre),
              subtitle: Text('${producto.descripcion}\nStock: ${producto.stock} - \$${producto.precio.toStringAsFixed(2)}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editProducto(index), // to be implemented
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(  //BUTTON FOR ADDING A NEW ITEM
        onPressed: _addProducto,
        tooltip: 'Agregar producto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
