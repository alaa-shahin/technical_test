import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/cart/cart_screen.dart';
import 'package:test_app/home_page/product_details_screen.dart';
import 'package:test_app/profile_page/profile_screen.dart';
import 'package:test_app/providers/cart.dart';
import 'package:test_app/providers/products.dart';
import 'package:test_app/providers/users.dart';
import 'home_page/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider<Products>(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider<Users>(
          create: (_) => Users(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test App',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.deepOrange,
        ),
        home: HomePage(),
        initialRoute: '/',
        routes: {
          CartScreen.routeName: (ctx) => CartScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
