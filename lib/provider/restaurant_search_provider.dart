import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';
import 'package:restaurant_app/helpers/enum_state.dart';

class FindRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  FindRestaurantProvider({required this.apiService}) {
    fetchSearchRestaurant("");
  }

  late List<FilteredRestaurant> _filteredRestaurants;

  List<FilteredRestaurant> get filteredRestaurants => _filteredRestaurants;

  ResultState _state = ResultState.loading;
  String _message = "";

  String get message => _message;

  ResultState get state => _state;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.search(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = ' not found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _filteredRestaurants = restaurant.restaurants
            .map((originalRestaurant) => FilteredRestaurant(
                  id: originalRestaurant.id,
                  name: originalRestaurant.name,
                  city: originalRestaurant.city,
                  rating: originalRestaurant.rating,
                  pictureId: originalRestaurant.pictureId,
                ))
            .toList();
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
