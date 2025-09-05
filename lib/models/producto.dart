class Producto {
  final String? id; // uuid from DB
  String nombre;
  String descripcion;
  double precio;
  int stock;
  String imageUrl;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.imageUrl,
  });

  factory Producto.fromMap(Map<String, dynamic> map) {
    // Be tolerant to column naming (ES/EN, snake/camel)
    String readString(List<String> keys, [String fallback = '']) {
      for (final k in keys) {
        final v = map[k];
        if (v is String && v.isNotEmpty) return v;
      }
      return fallback;
    }

    double readDouble(List<String> keys, [double fallback = 0.0]) {
      for (final k in keys) {
        final v = map[k];
        if (v is num) return v.toDouble();
        if (v is String) {
          final parsed = double.tryParse(v);
          if (parsed != null) return parsed;
        }
      }
      return fallback;
    }

    int readInt(List<String> keys, [int fallback = 0]) {
      for (final k in keys) {
        final v = map[k];
        if (v is int) return v;
        if (v is num) return v.toInt();
        if (v is String) {
          final parsed = int.tryParse(v);
          if (parsed != null) return parsed;
        }
      }
      return fallback;
    }

    return Producto(
      id: map['id']?.toString(),
      nombre: readString(['nombre', 'name']),
      descripcion: readString(['descripcion', 'description']),
      precio: readDouble(['precio', 'price']),
      stock: readInt(['stock']),
      imageUrl: readString(['image_url', 'imageUrl', 'image']),
    );
  }

  Map<String, dynamic> toMap() {
    // Preferred DB schema (snake_case, ES)
    
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'image_url': imageUrl,
    };
  }

  Producto copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? stock,
    String? imageUrl,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
