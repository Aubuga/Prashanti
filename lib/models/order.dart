// lib/models/order.dart

class Order {
  final String? id;           // uuid (orders.id)
  final DateTime? createdAt;  // orders.created_at
  String alias;               // orders.alias
  String status;              // 'pending' | 'paid' | 'canceled'
  double total;               // orders.total
  int itemsCount;             // orders.items_count

  Order({
    this.id,
    this.createdAt,
    required this.alias,
    required this.status,
    required this.total,
    required this.itemsCount,
  });

  // --- tolerant readers ---
  static String _s(Map<String, dynamic> m, List<String> keys, {String fallback = ''}) {
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.isNotEmpty) return v;
    }
    return fallback;
  }

  static double _d(Map<String, dynamic> m, List<String> keys, {double fallback = 0.0}) {
    for (final k in keys) {
      final v = m[k];
      if (v is num) return v.toDouble();
      if (v is String) {
        final p = double.tryParse(v);
        if (p != null) return p;
      }
    }
    return fallback;
  }

  static int _i(Map<String, dynamic> m, List<String> keys, {int fallback = 0}) {
    for (final k in keys) {
      final v = m[k];
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) {
        final p = int.tryParse(v);
        if (p != null) return p;
      }
    }
    return fallback;
  }

  static DateTime? _date(dynamic v) {
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toString(),
      createdAt: _date(map['created_at']),
      alias: _s(map, ['alias']),
      status: _s(map, ['status'], fallback: 'pending'),
      total: _d(map, ['total']),
      itemsCount: _i(map, ['items_count']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'alias': alias,
      'status': status,
      'total': total,
      'items_count': itemsCount,
      // 'created_at' is server-side default
    };
  }

  bool get isPending => status == 'pending';

  Order copyWith({
    String? id,
    DateTime? createdAt,
    String? alias,
    String? status,
    double? total,
    int? itemsCount,
  }) {
    return Order(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      alias: alias ?? this.alias,
      status: status ?? this.status,
      total: total ?? this.total,
      itemsCount: itemsCount ?? this.itemsCount,
    );
  }
}

class OrderItem {
  final String? id;            // uuid (order_items.id)
  String? orderId;             // order_items.order_id
  final String productId;      // order_items.producto_id (DB uses 'producto_id')
  final String nameSnapshot;   // order_items.nombre_snapshot
  final double priceSnapshot;  // order_items.precio_snapshot
  final int quantity;          // order_items.cantidad

  OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.nameSnapshot,
    required this.priceSnapshot,
    required this.quantity,
  });

  double get subtotal => priceSnapshot * quantity;

  // tolerant readers reused
  static String _s(Map<String, dynamic> m, List<String> keys, {String fallback = ''}) {
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.isNotEmpty) return v;
    }
    return fallback;
  }

  static double _d(Map<String, dynamic> m, List<String> keys, {double fallback = 0.0}) {
    for (final k in keys) {
      final v = m[k];
      if (v is num) return v.toDouble();
      if (v is String) {
        final p = double.tryParse(v);
        if (p != null) return p;
      }
    }
    return fallback;
  }

  static int _i(Map<String, dynamic> m, List<String> keys, {int fallback = 0}) {
    for (final k in keys) {
      final v = m[k];
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) {
        final p = int.tryParse(v);
        if (p != null) return p;
      }
    }
    return fallback;
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toString(),
      orderId: map['order_id']?.toString(),
      productId: _s(map, ['producto_id', 'product_id']),
      nameSnapshot: _s(map, ['nombre_snapshot', 'name_snapshot']),
      priceSnapshot: _d(map, ['precio_snapshot', 'price_snapshot']),
      quantity: _i(map, ['cantidad', 'quantity']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'producto_id': productId,
      'nombre_snapshot': nameSnapshot,
      'precio_snapshot': priceSnapshot,
      'cantidad': quantity,
      'subtotal': subtotal,
    };
  }

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? nameSnapshot,
    double? priceSnapshot,
    int? quantity,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      priceSnapshot: priceSnapshot ?? this.priceSnapshot,
      quantity: quantity ?? this.quantity,
    );
  }
}
