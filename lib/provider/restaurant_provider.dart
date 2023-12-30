import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/api/api_service.dart';
import '../data/model/restaurant.dart';
import '../helpers/enum_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late Restaurant _restaurant;
  ResultState _state = ResultState.loading;
  String _message = "";

  String get message => _message;
  Restaurant get restaurant => _restaurant;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getAll(http.Client());
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = restaurant;
      }
    } catch (e) {
      if (e is SocketException) {
        _state = ResultState.noInet;
        notifyListeners();
        return _message = 'No internet';
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Something Went Wrong';
      }
    }
  }
}
