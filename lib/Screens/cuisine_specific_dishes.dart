import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_app/Screens/cart_screen.dart';
import 'package:restaurent_app/models/cart.dart';
import 'package:restaurent_app/others/utils.dart';
import 'package:restaurent_app/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CuisineScreen extends StatefulWidget {
  final String cuisineName;
  final List<dynamic> items;
  final int cuisineID;

  CuisineScreen({
    required this.cuisineName,
    required this.items,
    required this.cuisineID,
  });

  @override
  State<CuisineScreen> createState() => _CuisineScreenState();
}

class _CuisineScreenState extends State<CuisineScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Menu Card",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final dish = widget.items[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(
                dish["image_url"],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(dish["name"]),
              subtitle: Text('₹${dish["price"]}'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).add_item(
                    CartItem(
                      cuisineID: widget.cuisineID,
                      itemID: int.parse("${dish["id"]}"),
                      name: dish["name"],
                      price: int.parse(dish["price"]),
                    ),
                  );
                  ShowSnackBar(context, "Added Successfully");
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => CartScreen()));
        },
        child: Text(
          "Proceed to checkout",
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
    );
  }
}
