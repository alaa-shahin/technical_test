import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_app/config.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  Configure config = Configure();

  Duration _cacheValidDuration = Duration(hours: 12);
  DateTime _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
  List _userData = [];

  /// If the cache time has expired, records are refreshed from the API before being returned.
  /// Otherwise the cached records are returned.
  Future<List> getUser() async {
    bool shouldRefreshFromApi = (null == _userData ||
        _userData.isEmpty ||
        null == _lastFetchTime ||
        _lastFetchTime.isBefore(DateTime.now().subtract(_cacheValidDuration)));

    if (shouldRefreshFromApi) {
      await fetchUser();
    }

    return _userData;
  }

  Future fetchUser() async {
    await config.initialized;
    String url = '${config.baseUrl}/users';
    final response = await http.get(url);
    final extractData = jsonDecode(response.body);
    notifyListeners();
    _userData = extractData;
    _lastFetchTime = DateTime.now();
    return _userData;
  }
}
