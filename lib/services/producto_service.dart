// lib/services/producto_service.dart

import '../models/producto.dart';
import 'producto_remote_service.dart';
class ProductoService {
  static final ProductoService _instance = ProductoService._internal();
  factory ProductoService() => _instance;
  ProductoService._internal();
    final ProductoRemoteService _remote = ProductoRemoteService();

  // This will act like shared memory (singleton pattern)
  final List<Producto> productos = [
  ];

  List<Producto> getAll() => productos;

  void updateAll(List<Producto> nuevos) {
    productos
      ..clear()
      ..addAll(nuevos);
  }
}
