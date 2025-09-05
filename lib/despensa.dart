import 'package:flutter/material.dart';
//import '../services/producto_service.dart';
import '../models/producto.dart';
import 'package:prashanti_coliving/services/producto_remote_service.dart';
import '../services/cart_service.dart';

class DespensaPage extends StatelessWidget {
  const DespensaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
  onPopInvokedWithResult: (didPop, result) {
    if (didPop) { // permite salir
 
   CartService().clearCart(confirmPurchase: false); // sin tocar stock
     }},
  child:Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        leading: BackButton(), // back button
        title: const Text('Despensa - Prashanti Coliving'),
        centerTitle: true,
        actions: [
  Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Tooltip(
      message: 'Carrito',
      waitDuration: const Duration(seconds: 1),
      child: InkWell(
      onTap: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const CartSummarySheet(),
  );
},

        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 28),
            // badge
            Positioned(
              right: 0,
              top: 8,
              child: AnimatedBuilder(
                animation: CartService(), // listens to changes
                builder: (_, __) {
                  final count = CartService().totalUnits;
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  ),
],

      ),
      body: const DespensaBody(),
  ),
    );
  }
}

  @override


class DespensaBody extends StatefulWidget {
  const DespensaBody({super.key});


  @override
  State<DespensaBody> createState() => _DespensaBodyState();
}

class _DespensaBodyState extends State<DespensaBody> {
  final _remote = ProductoRemoteService();
void _onCartChanged() {
  // Refiltra con el stock actualizado (productos con stock > 0)
  final raw = _searchCtrl.text.trim().toLowerCase();
  final words = raw.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  setState(() {
    final base = productos.where((p) => p.stock > 0).toList();
    if (raw.isEmpty) {
      productosFiltrados = base;
    } else {
      productosFiltrados = base.where((p) {
        final haystack = '${p.nombre} ${p.descripcion}'.toLowerCase();
        return words.every((w) => haystack.contains(w));
      }).toList();
    }
  });
}

  // data
  List<Producto> productos = [];
  List<Producto> productosFiltrados = [];

  // ui state
  final TextEditingController _searchCtrl = TextEditingController();
  String? error;
  bool isLoading = true;

  // quantities: key -> selected qty
  final Map<String, int> _qty = {};

  @override
  void initState() {
  super.initState();
  _searchCtrl.addListener(() => setState(() {}));
  CartService().addListener(_onCartChanged); // <— escucha cambios del carrito
  _load();
  }
@override
void dispose() {
  CartService().removeListener(_onCartChanged); // <— limpiar
  _searchCtrl.dispose();
  super.dispose();
}


  Future<void> _load() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetched = await _remote.fetchProductos();
setState(() {
  // solo los que tengan stock disponible
  productos = fetched.where((p) => p.stock > 0).toList();
  productosFiltrados = List.from(productos);
  isLoading = false;
});

    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  // ---- SEARCH ----
  void _applySearch() {
    final raw = _searchCtrl.text.trim().toLowerCase();
    if (raw.isEmpty) {
      setState(() => productosFiltrados = List.from(productos));
      return;
    }
    final words = raw.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    setState(() {
      productosFiltrados = productos.where((p) {
        final haystack =
            '${p.nombre} ${p.descripcion}'.toLowerCase();
        // match if EVERY word appears somewhere
        return words.every((w) => haystack.contains(w));
      }).toList();
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {
      productosFiltrados = List.from(productos);
    });
  }

  // ---- QUANTITIES ----
  String _keyFor(Producto p, int index) => p.id ?? 'idx_$index:${p.nombre}';

  int _qtyOf(String key) => _qty[key] ?? 0;

  void _setQty(String key, int value, int stock) {
    final clamped = value.clamp(0, stock);
    setState(() => _qty[key] = clamped);
  }

  void _inc(String key, int stock) => _setQty(key, _qtyOf(key) + 1, stock);
  void _dec(String key, int stock) => _setQty(key, _qtyOf(key) - 1, stock);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error cargando productos:\n$error'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _load,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // --- filter/search row ---
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Tooltip(
                message: 'Filtrar',
                waitDuration: const Duration(seconds: 1),
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // future: open a filter dialog
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onSubmitted: (_) => _applySearch(), // Enter submits too
                  decoration: InputDecoration(
                    hintText: 'Buscar producto...',
                    prefixIcon: const Icon(Icons.search), // visual only
                    // the clickable search + clear live in suffixIcon
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Buscar',
                          icon: const Icon(Icons.search),
                          onPressed: _applySearch,
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          IconButton(
                            tooltip: 'Limpiar',
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- list with pull-to-refresh ---
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView.builder(
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                final p = productosFiltrados[index];
                final key = _keyFor(p, index);
                final count = _qtyOf(key);
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // LEFT: image + name
                        SizedBox(
                          width: 130, // tweak for your design
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.imageUrl,
                                  width: 110,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported, size: 48),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.nombre,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // MIDDLE: description
                        Expanded(
                          child: Text(
                            p.descripcion,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(height: 1.3),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // RIGHT: price, stock, qty controls
SizedBox(
  width: 180, // puedes ajustar
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        '\$${p.precio.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 6),
      Text('Stock: ${p.stock}'),
      const SizedBox(height: 10),

      // fila de botones +/-
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            tooltip: 'Menos',
            onPressed: count > 0 ? () => _dec(key, p.stock) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Container(
            width: 42,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            tooltip: 'Más',
            onPressed: count < p.stock ? () => _inc(key, p.stock) : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),

      const SizedBox(height: 8),

      // botón Agregar al carrito
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Agregar'),
          onPressed: count > 0
              ? () {
                  CartService().add(p, count, fallbackKey: key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Agregado: ${p.nombre} x$count')),
                  );
                  _setQty(key, 0, p.stock); // reset local counter
                }
              : null,
        ),
      ),
    ],
  ),
),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}


class CartSummarySheet extends StatelessWidget {
  const CartSummarySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService();

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final items = cart.items.values.toList();

        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.remove_shopping_cart, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('Tu carrito está vacío'),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Carrito',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // listado de items
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return ListTile(
                      leading: Image.network(
                        item.producto.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      title: Text(item.producto.nombre),
                      subtitle: Text(
                          'x${item.cantidad}  •  \$${item.producto.precio.toStringAsFixed(2)} c/u'),
                      trailing: Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),

              const Divider(),

              // total and ---ALIAS---
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Confirmar compra
// inside CartSummarySheet -> actions Row, replace the Confirm button block with this:
ElevatedButton.icon(
  icon: const Icon(Icons.check_circle),
  label: const Text('Confirmar compra'),
  onPressed: () async {
    final cart = CartService();
    final total = cart.totalPrice;

    // Ask user for final confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar compra'),
        content: Text('Enviar \$${total.toStringAsFixed(2)} a alias: prashanti.coliving'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('OK')),
        ],
      ),
    );

    if (confirm != true) return;

    // show a progress indicator while we update DB
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Prepare updates: id -> total quantity to decrement
      final items = cart.items.values.toList();
      final Map<String, int> updates = {};
      final List<String> missingIds = [];

      for (final it in items) {
        final id = it.producto.id;
        if (id != null && id.isNotEmpty) {
          updates[id] = (updates[id] ?? 0) + it.cantidad;
        } else {
          // product not persisted in DB, note it
          missingIds.add(it.producto.nombre);
        }
      }

      // Perform DB updates only for products that have an id
      if (updates.isNotEmpty) {
        await ProductoRemoteService().decrementStocks(updates);
      }

      // Update local product objects' stock and clear cart
      // (clearCart(confirmPurchase: true) will call _updateStock() which reduces local producto.stock)
      cart.clearCart(confirmPurchase: true);

      // close the progress dialog
      Navigator.of(context).pop();

      // close the cart bottom sheet
      Navigator.of(context).pop();

      // notify user
      final msg = missingIds.isEmpty
          ? 'Compra confirmada: Enviar \$${total.toStringAsFixed(2)} a alias: prashanti.coliving'
          : 'Compra confirmada. Nota: algunos productos (${missingIds.join(", ")}) no estaban guardados en la base y no se actualizaron en DB. Enviar \$${total.toStringAsFixed(2)} a alias: prashanti.coliving';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      // close the progress dialog
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al confirmar compra: $e')));
    }
  },
),


    // Vaciar carrito (sin afectar stock)
    TextButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text('Vaciar carrito'),
      onPressed: () {
        cart.clearCart(confirmPurchase: false);
        Navigator.pop(context);
      },
    ),
  ],
),


              const SizedBox(height: 12),

              // acciones
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Confirmar compra button
    ElevatedButton.icon(
      icon: const Icon(Icons.check_circle),
      label: const Text('Confirmar compra'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Compra confirmada'),
              content: Text(
                'Enviar \$${cart.totalPrice.toStringAsFixed(2)} a alias: prashanti.coliving',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // close dialog
                    Navigator.of(context).pop(); // close cart sheet
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ),

    // Vaciar carrito button (keep as is)
    TextButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text('Vaciar carrito'),
      onPressed: () {
        cart.clear();
        Navigator.pop(context);
      },
    ),
  ],
)

            ],
          ),
        );
      },
    );
  }
}
