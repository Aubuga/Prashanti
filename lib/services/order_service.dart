// lib/services/order_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';

class OrderService {
  final _supabase = Supabase.instance.client;
  /// 🔹 Crear un pedido con sus items
  Future<void> createOrder(Order order, List<OrderItem> items) async {
    // 1. Insertar el pedido en "orders"
    final orderResponse = await _supabase
        .from('orders')
        .insert(order.toMap())
        .select()
        .single();

    final orderId = orderResponse['id'];

    // 2. Insertar los items en "order_items"
    for (var item in items) {
      final itemWithOrder = item.copyWith(orderId: orderId);
      await _supabase.from('order_items').insert(itemWithOrder.toMap());
    }
  }
  

  /// 🔹 Obtener todos los pedidos (para admin)
  Future<List<Order>> fetchOrders() async {
    final response =
        await _supabase.from('orders').select().order('created_at', ascending: false);

    return (response as List)
        .map((row) => Order.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  /// 🔹 Cambiar el estado de un pedido (ej: "PAGO RECIBIDO" o "CANCELADO")
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    await _supabase
        .from('orders')
        .update({'status': newStatus})
        .eq('id', orderId);
  }

  /// 🔹 Obtener los items de un pedido (para detalle en admin)
  Future<List<OrderItem>> fetchOrderItems(int orderId) async {
    final response = await _supabase
        .from('order_items')
        .select()
        .eq('order_id', orderId);

    return (response as List)
        .map((row) => OrderItem.fromMap(row as Map<String, dynamic>))
        .toList();
  }
}
