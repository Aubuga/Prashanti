// import 'package:flutter/material.dart';
// import '../services/cart_service.dart';
// import '../services/order_service.dart';
// import '../models/order.dart';

// class CheckoutPage extends StatefulWidget {
//   final CartService cartService;
//   final OrderService orderService;

//   const CheckoutPage({
//     super.key,
//     required this.cartService,
//     required this.orderService,
//   });

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   bool isLoading = false;

//   Future<void> _confirmOrder() async {
//     setState(() {
//       isLoading = true;
//     });

//     // Crear lista de OrderItem desde el carrito
//     final orderItems = widget.cartService.items.values.map((cartItem) {
//       return OrderItem(
//         productId: cartItem.producto.id!, // producto.id no puede ser null
//         nameSnapshot: cartItem.producto.nombre,
//         priceSnapshot: cartItem.producto.precio,
//         quantity: cartItem.cantidad,
//       );
//     }).toList();

//     // Crear la orden (basada en nuestro modelo Order)
//     final order = Order(
//       alias: "prashanti.coliving", // hardcoded por ahora
//       status: "pending",
//       total: widget.cartService.totalPrice,
//       itemsCount: orderItems.length,
//     );

//     try {
//       // Guardamos orden + items
//       await widget.orderService.createOrder(order, orderItems);

//       // Vaciamos carrito
//       widget.cartService.clear();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Orden confirmada con éxito')),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error al crear la orden: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartItems = widget.cartService.items.values.toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Checkout')),
//       body: cartItems.isEmpty
//           ? const Center(child: Text('Tu carrito está vacío'))
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final item = cartItems[index];
//                       return ListTile(
//                         title: Text(item.producto.nombre),
//                         subtitle: Text('Cantidad: ${item.cantidad}'),
//                         trailing: Text(
//                           '\$${(item.producto.precio * item.cantidad).toStringAsFixed(2)}',
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'Total: \$${widget.cartService.totalPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.end,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: isLoading ? null : _confirmOrder,
//                         child: isLoading
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : const Text('Confirmar Orden'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
