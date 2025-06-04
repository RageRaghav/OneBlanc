import 'package:flutter/material.dart';
import 'package:restaurent_app/Services/get_by_filter.dart';
import 'package:restaurent_app/Screens/post_filter_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCuisine;
  double minPrice = 0;
  double maxPrice = 500;
  double minRating = 0;

  final List<String> cuisineTypes = ["North Indian", "Chinese"];

  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;

  @override
  void initState() {
    super.initState();
    minPriceController = TextEditingController(
      text: minPrice.toInt().toString(),
    );
    maxPriceController = TextEditingController(
      text: maxPrice.toInt().toString(),
    );
  }

  void clearFilters() {
    setState(() {
      selectedCuisine = null;
      minRating = 0;
      minPrice = 0;
      maxPrice = 500;
      minPriceController.text = '0';
      maxPriceController.text = '500';
    });
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
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
                "Apply Filters",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cuisine Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedCuisine,
              hint: Text("Select Cuisine"),
              isExpanded: true,
              items:
                  cuisineTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCuisine = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              "Price Range (₹)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Min"),
                    onChanged: (val) => minPrice = double.tryParse(val) ?? 0,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Max"),
                    onChanged: (val) => maxPrice = double.tryParse(val) ?? 500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Minimum Rating",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: minRating,
              min: 0,
              max: 5,
              divisions: 10,
              label: minRating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  minRating = value;
                });
              },
            ),
            ElevatedButton.icon(
              onPressed: clearFilters,
              icon: Icon(Icons.clear_all),
              label: Text("Clear Filters"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                final response = await ApiService3.getItemByFilter(
                  cuisine: selectedCuisine,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  minRating: minRating,
                  context: context,
                );

                if (response != null && response['cuisines'] != null) {
                  final List<dynamic> cuisines = response['cuisines'];
                  final List<dynamic> allItems =
                      cuisines.expand((c) => c['items'] ?? []).toList();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PostFilterScreen(
                          cuisineID:
                              selectedCuisine == "Chinese" ? 475674 : 234552,
                          filteredDishes: allItems,
                        );
                      },
                    ),
                  );
                }
              },
              icon: Icon(Icons.filter_alt, color: Colors.white),
              label: Text(
                "Apply Filters",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(
                  double.infinity,
                  56,
                ),
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
