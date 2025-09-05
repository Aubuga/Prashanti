class Dolar {
  // Acá actualizás el valor manualmente cada día
  static double  compra = venta;
  static double  venta = 1400.0;

  static double dolarHoy = ((compra+venta)/2);
  static int roundToNext50(double value) {
    return ((value / 50).ceil() * 50); //change to the rounding, edit here to edit rounding rule
  }


    // 🔹 Function that gives the final price in pesos
  static String precioFinal(double precioProducto) {
    final valorPesos = precioProducto * dolarHoy;
    final redondeado = roundToNext50(valorPesos);
    return '\$$redondeado'; //change to the rounding, edit here to edit rounding rule
  }
}
