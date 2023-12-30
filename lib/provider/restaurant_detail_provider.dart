import 'dart:io';

import 'package:flutter/foundation.dart';

import '../data/api/api_service.dart';
import '../data/model/restaurant_detail.dart';
import '../helpers/enum_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider(
      {required this.apiService, required this.restaurantId}) {
    fetchRestaurantDetail();
  }

  late RestaurantDetail _restaurantDetail;
  ResultState _state = ResultState.loading;
  String _message = "";

  String get message => _message;
  RestaurantDetail get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;

  Future<dynamic> fetchRestaurantDetail() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.getDetail(restaurantId);
      if (restaurantDetail.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = restaurantDetail;
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
