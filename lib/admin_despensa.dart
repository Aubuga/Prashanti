import 'package:flutter/material.dart';
import '../models/producto.dart'; // import product model
import '../services/dolar_service.dart';
 // import the service for implementation in _saveProductos
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
                decoration: const InputDecoration(labelText: 'Precio en USD'),
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
                      id: producto.id, //to fix the issue with the duplicate id
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
    

  ];

 final _remote = ProductoRemoteService();

@override
void initState() {
  super.initState();
  _load();
}
Future<void> _deleteProducto(int index) async {
  final producto = productos[index];

  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Eliminar producto'),
      content: Text('¿Seguro que deseas eliminar "${producto.nombre}"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
      ],
    ),
  );

  if (confirm != true) return;

  // Optimistic UI: quitar de la lista primero
  final removed = productos.removeAt(index);
  setState(() {});

  // Si el producto tiene id, intentamos borrar en Supabase
  if (producto.id != null && producto.id!.isNotEmpty) {
    try {
      await _remote.deleteProducto(producto.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eliminado: ${producto.nombre}')),
      );
    } catch (e) {
      // Revertir en caso de error
      productos.insert(index, removed);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  } else {
    // Items locales (aún no guardados) solo se quitan de la lista
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Eliminado localmente: ${producto.nombre}')),
    );
  }
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
      id: null,
    nombre: '',
    descripcion: '',
    precio: 0.0,
    stock: 1,
    imageUrl: 'buscar en google y poner la url',
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
    final saved = await _remote.saveProductos(productos);
    setState(() {
      productos = saved; // refresh local list with generated IDs
    });

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
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          'Dólar: ${Dolar.dolarHoy}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
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
)
,
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
              subtitle: Text( '${producto.descripcion}\nStock: ${producto.stock} - ${Dolar.precioFinal(producto.precio)}',),
              isThreeLine: true,
              trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Editar',
      onPressed: () => _editProducto(index),
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Eliminar',
      color: Colors.red,
      onPressed: () => _deleteProducto(index),
    ),
  ],
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
