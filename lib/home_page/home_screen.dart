import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/cart/cart_screen.dart';
import 'package:test_app/home_page/product_details_screen.dart';
import 'package:test_app/profile_page/profile_screen.dart';
import 'package:test_app/providers/cart.dart';
import 'package:test_app/providers/products.dart';
import 'package:test_app/widgets/badge.dart';
import 'package:pagination_view/pagination_view.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  static const String coin = 'EGP';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page;
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    page = -1;
    key = GlobalKey<PaginationViewState>();
    super.initState();
  }

  Future<List<dynamic>> pageFetch(int offset) async {
    page = (offset / 4).round();
    var data =
        await Provider.of<Products>(context, listen: false).fetchProducts(page);
    return page == 2 ? [] : data;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Home Page'),
        elevation: 2.0,
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
          SizedBox(width: 10.0),
          InkWell(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/account.png'),
              radius: 25,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: PaginationView(
          key: key,
          pageFetch: pageFetch,
          paginationViewType: PaginationViewType.listView,
          shrinkWrap: true,
          itemBuilder: (ctx, product, _) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailsScreen.routeName,
                    arguments: product,
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/LazyLoadingHeader.png',
                            image: product['product_image'],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name']),
                          SizedBox(height: 10.0),
                          Text(
                            '${HomePage.coin}: ${product['price'].toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          RaisedButton(
                            child: Text(
                              'Add To Cart',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.orange,
                            onPressed: () {
                              cart.addItem(product['id'].toString(),
                                  product['name'], product['price']);
                              displaySnackBar(context, product, cart);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          pullToRefresh: true,
          onError: (dynamic error) => Center(
            child: Text('Some error occured'),
          ),
          onEmpty: Center(
            child: Text('Sorry! This is empty'),
          ),
          bottomLoader: Center(
            child: CircularProgressIndicator(),
          ),
          initialLoader: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  displaySnackBar(BuildContext context, Map product, Cart cart) {
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
          cart.removeSingleItem(product['id'].toString());
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
