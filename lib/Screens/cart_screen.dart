import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_app/Services/payment.dart';
import 'package:restaurent_app/models/cart.dart';
import 'package:restaurent_app/others/utils.dart';
import 'package:restaurent_app/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double total = 0;
  double netTotal(List<CartItem> cart) =>
      cart.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  double tax(List<CartItem> cart) => netTotal(cart) * 0.05;
  double grandTotal(total, List<CartItem> cart) =>
      total = netTotal(cart) + tax(cart);

  List<Map<String, dynamic>> calCart(List<CartItem> cart) {
    return cart.map((item) {
      return {
        "cuisine_id": item.cuisineID,
        "item_id": item.itemID,
        "item_price": item.price,
        "item_quantity": item.quantity,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Place Order",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    title: Text("${item.name}"),
                    subtitle: Text("Qty: ${item.quantity} x ₹${item.price}"),
                    trailing: Text("₹${item.price * item.quantity}"),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Net Total"),
              trailing: Text("Subtotal: ₹${netTotal(cart).toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("CGST + SGST (5%)"),
              trailing: Text("Tax (5%): ₹${tax(cart).toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text(
                "Grand Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "Total: ₹${grandTotal(total, cart).toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final data = calCart(cart);
                final totalAmount = grandTotal(0, cart).toDouble();
                final res = await ApiService4.make_payment(
                  totalAmount: totalAmount.toString(),
                  totalItems: cart.length,
                  data: data,
                  context: context,
                );

                if (res != null) {
                  ShowSnackBar(context, "${res["response_message"]}");
                } else {
                  ShowSnackBar(context, "Payment Failed");
                }
                // Place order logic here
              },
              child: Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 56),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
