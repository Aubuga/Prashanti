// lib/services/producto_service.dart

import '../models/producto.dart';
class ProductoService {
  static final ProductoService _instance = ProductoService._internal();
  factory ProductoService() => _instance;
  ProductoService._internal();

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
