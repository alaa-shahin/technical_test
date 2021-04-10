import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/cart/cart_screen.dart';
import 'package:test_app/home_page/home_screen.dart';
import 'package:test_app/providers/cart.dart';
import 'package:test_app/widgets/badge.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/ProductDetailsScreen';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map argument = {};

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    argument = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(argument['name']),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      enlargeCenterPage: true,
                    ),
                    items: [
                      for (int i = 0; i < argument['slider_images'].length; i++)
                        Container(
                          child: Center(
                            child: FadeInImage.assetNetwork(
                              image: argument['slider_images'][i]['url'],
                              placeholder: 'assets/LazyLoadingHeader.png',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        argument['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${HomePage.coin}: ${argument['price'].toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(argument['description']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RaisedButton(
        onPressed: () {
          cart.addItem(
              argument['id'].toString(), argument['name'], argument['price']);
          displaySnackBar(context, cart);
        },
        child: Row(
          children: [
            Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            SizedBox(width: 100),
            Text(
              'Add To CART',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  displaySnackBar(BuildContext context, Cart cart) {
    final snackBar1 = SnackBar(
      content: Text(
        'Added to Cart',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.orange,
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.white,
        onPressed: () {
          cart.removeSingleItem(argument['id'].toString());
          final snackBar2 = SnackBar(
            content: Text(
              'Product was removed from cart',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          );
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(snackBar2);
        },
      ),
    );
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar1);
  }
}
