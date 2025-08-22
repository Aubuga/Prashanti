import '../models/producto.dart';
// uses the procut and gets the total of the sum of the products
class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({required this.producto, required this.cantidad});

  double get subtotal => producto.precio * cantidad;
}
