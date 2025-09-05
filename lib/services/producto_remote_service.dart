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

Future<List<Producto>> saveProductos(List<Producto> productos) async {
  final List<Producto> saved = [];

  for (final p in productos) {
    final data = p.toMap(); // id omitted automatically if null

    if (p.id == null || (p.id?.isEmpty ?? true)) {
      // NEW → INSERT and return the created row (with generated id)
      final inserted = await _supabase
          .from('despensa_items')
          .insert(data)
          .select()
          .single();

      saved.add(Producto.fromMap(inserted));
    } else {
      // EXISTING → UPSERT by id and return the row
      final upserted = await _supabase
          .from('despensa_items')
          .upsert(data, onConflict: 'id')
          .select()
          .single();

      saved.add(Producto.fromMap(upserted));
    }
  }

  return saved;
}

  Future<void> deleteProducto(String id) async {
  await _supabase.from('despensa_items').delete().eq('id', id);
}

  /// Decrement stock in the DB for the given map `id -> qty`.
  /// Throws on first error.
  Future<void> decrementStocks(Map<String, int> idToQty) async {
    for (final entry in idToQty.entries) {
      final id = entry.key;
      final qty = entry.value;

      // 1) read current stock
      final currentResp = await _supabase
          .from('despensa_items')
          .select('stock')
          .eq('id', id)
          .maybeSingle();

      if (currentResp == null) {
        throw Exception('Producto no encontrado en DB (id=$id)');
      }

      // parse current stock safely
      final dynamic stockRaw = currentResp['stock'];
      final int currentStock = stockRaw is num
          ? (stockRaw as num).toInt()
          : int.tryParse(stockRaw?.toString() ?? '') ?? 0;

      final int newStock = (currentStock - qty) < 0 ? 0 : (currentStock - qty);

      // 2) update with new stock and update timestamp
      await _supabase
          .from('despensa_items')
          .update({'stock': newStock, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    }
  }


}
