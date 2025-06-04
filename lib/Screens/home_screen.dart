import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_app/Screens/filter_screen.dart';
import 'package:restaurent_app/Services/get_items.dart';
import 'package:restaurent_app/Screens/cuisine_specific_dishes.dart';
import 'package:restaurent_app/Screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> cuisines = [];
  bool isLoading = true;
  List<Map<String, dynamic>> highestRatedItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final response = await ApiService1.getItemList(context: context);
    if (response != null) {
      setState(() {
        cuisines = response['cuisines'];
        for (var cuisine in cuisines) {
          List<dynamic> items = cuisine['items'];

          items.sort((a, b) {
            double ratingA = double.tryParse(a['rating']) ?? 0.0;
            double ratingB = double.tryParse(b['rating']) ?? 0.0;
            return ratingB.compareTo(ratingA);
          });

          List<Map<String, dynamic>> topItems =
              items.take(3).map((item) {
                return {
                  'name': item['name'],
                  'image_url': item['image_url'],
                  'rating': item['rating'],
                  'cuisine': cuisine['cuisine_name'],
                };
              }).toList();

          highestRatedItems.addAll(topItems);
        }
        isLoading = false;
      });
    }
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
                "Home",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FilterScreen()),
                  );
                },
                child: Icon(Icons.tune_outlined),
              ),
            ],
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cuisines",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 160,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                        initialPage: 0,
                      ),
                      items:
                          cuisines.map((cuisine) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CuisineScreen(
                                          cuisineID: int.parse(
                                            "${cuisine["cuisine_id"]}",
                                          ),
                                          cuisineName:
                                              "${cuisine["cuisine_name"]}",
                                          items: cuisine["items"],
                                        ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      cuisine['cuisine_image_url'],
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(8),
                                      color: Colors.black45,
                                      child: Text(
                                        cuisine["cuisine_name"],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Top Dishes",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: highestRatedItems.length,
                        itemBuilder: (context, index) {
                          final dish = highestRatedItems[index];
                          return Container(
                            width: 140,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    dish["image_url"],
                                    width: 140,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${dish['rating']}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Previous Order",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "06/01/2025 12:26:07",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Order id",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "#wid830cw738zc29",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹550",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CartScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "View order",
                                  style: GoogleFonts.poppins(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
