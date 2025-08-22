// lib/services/producto_service.dart

import '../models/producto.dart';

class ProductoService {
  static final ProductoService _instance = ProductoService._internal();
  factory ProductoService() => _instance;
  ProductoService._internal();

  // This will act like shared memory (singleton pattern)
  final List<Producto> productos = [
    Producto(
      nombre: 'Yerba Mate',
      descripcion: 'Yerba orgánica 500g',
      precio: 2500.0,
      stock: 12,
      imageUrl: 'https://via.placeholder.com/100',
    ),
    Producto(
      nombre: 'Harina Integral',
      descripcion: 'Harina de trigo 1kg',
      precio: 1500.0,
      stock: 8,
      imageUrl: 'https://via.placeholder.com/100',
    ),
  ];

  List<Producto> getAll() => productos;

  void updateAll(List<Producto> nuevos) {
    productos
      ..clear()
      ..addAll(nuevos);
  }
}
