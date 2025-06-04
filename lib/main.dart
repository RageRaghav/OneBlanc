import 'package:flutter/material.dart';
import 'package:restaurent_app/Screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_app/providers/cart_provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> CartProvider())
      ],
      child: MaterialApp(
        title: 'OneBanc Restaurant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: HomeScreen(),
      ),
    );
  }
}

