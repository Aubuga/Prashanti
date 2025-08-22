import 'package:flutter/foundation.dart';
import 'package:prashanti_coliving/models/producto.dart';
import 'package:prashanti_coliving/models/cart_item.dart';
class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get totalUnits =>
      _items.values.fold(0, (acc, it) => acc + it.cantidad);

  double get totalPrice =>
      _items.values.fold(0.0, (acc, it) => acc + it.subtotal);

  // key is product id if present, else a fallback you pass in
  void add(Producto p, int qty, {String? fallbackKey}) {
    if (qty <= 0) return;
    final key = p.id ?? fallbackKey ?? p.nombre;

    final existing = _items[key];
    if (existing != null) {
      // clamp to available stock
      existing.cantidad = (existing.cantidad + qty).clamp(0, p.stock);
      if (existing.cantidad == 0) _items.remove(key);
    } else {
      final qtyClamped = qty.clamp(0, p.stock);
      if (qtyClamped > 0) {
        _items[key] = CartItem(producto: p, cantidad: qtyClamped);
      }
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

