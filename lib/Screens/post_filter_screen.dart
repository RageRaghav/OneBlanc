import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_app/Screens/cart_screen.dart';
import 'package:restaurent_app/Services/get_by_id.dart';
import 'package:restaurent_app/models/cart.dart';
import 'package:restaurent_app/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class PostFilterScreen extends StatefulWidget {
  final List<dynamic> filteredDishes;
  final int cuisineID;

  PostFilterScreen({required this.filteredDishes, required this.cuisineID});

  @override
  State<PostFilterScreen> createState() => _PostFilterScreenState();
}

class _PostFilterScreenState extends State<PostFilterScreen> {
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
                "Your Preferences !",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      body:
          widget.filteredDishes.isEmpty
              ? Center(child: Text("No dishes match your filters."))
              : ListView.builder(
                itemCount: widget.filteredDishes.length,
                itemBuilder: (context, index) {
                  final dish = widget.filteredDishes[index];

                  return FutureBuilder<Map<String, dynamic>?>(
                    future: ApiService2.getItemById(
                      itemID: dish["id"],
                      context: context,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: LinearProgressIndicator(),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return ListTile(
                          title: Text(dish['name']),
                          subtitle: Text("Error loading details"),
                        );
                      }

                      final item = snapshot.data!;
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            item['item_image_url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['item_name']),
                          subtitle: Text(
                            "₹${item['item_price']} | ⭐ ${item['item_rating']}",
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Provider.of<CartProvider>(
                                context,
                                listen: false,
                              ).add_item(
                                CartItem(
                                  cuisineID: widget.cuisineID,
                                  itemID: dish["id"],
                                  name: item['item_name'],
                                  price: item['item_price'],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
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
