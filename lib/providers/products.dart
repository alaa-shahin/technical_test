import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/config.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  Configure config = Configure();

  Future<List<dynamic>> fetchProducts(int offset) async {
    await config.initialized;
    String url = '${config.baseUrl}/products';
    final response = await http.get(url);
    final extractData = jsonDecode(response.body);
    notifyListeners();
    return extractData;
  }
}
