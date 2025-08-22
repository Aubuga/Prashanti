// lib/services/producto_remote_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/producto.dart';

class ProductoRemoteService {
  final _supabase = Supabase.instance.client;

  Future<List<Producto>> fetchProductos() async {
    final response = await _supabase.from('despensa_items').select();
    return (response as List)
        .map((row) => Producto.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProductos(List<Map<String, dynamic>> productos) async {
    // Upsert = insert or update if conflict on "id"
    await _supabase.from('despensa_items').upsert(productos);
  }
}
