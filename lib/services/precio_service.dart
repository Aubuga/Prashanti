
//import '../admin_despensa.dart'; 
class Dolar {
  // Acá actualizás el valor manualmente cada día
  static double  compra = venta;
  static double  venta = 1450.0;

  static double dolarHoy = ((compra+venta)/2);
}

class Margen {
  // Acá actualizás el valor manualmente cada día


  static double porcentajeGanancia = 40;
}



class PrecioFinal {    // 🔹 Function that gives the final price in pesos
  static int roundToNext50(double value) {
    return ((value / 100).ceil() * 100); //change to the rounding, edit here to edit rounding rule
    
  }
    static String precioFinal(double precioProducto) {
    final valorPesos = precioProducto * Dolar.dolarHoy;
    final precioVenta = valorPesos * (1+(Margen.porcentajeGanancia)/100);
    final redondeado = roundToNext50(precioVenta);
    return '\$$redondeado'; //change to the rounding, edit here to edit rounding rule
  }
}