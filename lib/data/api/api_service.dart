import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/restaurant.dart' as Restaurants;
import '../model/restaurant_detail.dart';
import '../model/restaurant_search.dart' as Find;

class ApiService {
  static const baseURL = "https://restaurant-api.dicoding.dev";
  static const _endpointListRestaurant = "/list";
  static const _endpointDetailRestaurant = "/detail/";
  static const _endpointSearchRestaurant = "/search?q=";
  static const endpointImageMedium = "/images/medium/";
  static const endpointImageLarge = "/images/large/";

  Future<Restaurants.Restaurant> getAll(http.Client client) async {
    final response =
        await client.get(Uri.parse("$baseURL$_endpointListRestaurant"));

    if (response.statusCode == 200) {
      return Restaurants.Restaurant.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception("Failed load Restaurants");
    }
  }

  Future<RestaurantDetail> getDetail(String id) async {
    final response = await http.get(
      Uri.parse("$baseURL$_endpointDetailRestaurant$id"),
    );

    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception("Failed load Restaurants");
    }
  }

  Future<Find.FindRestaurant> search(String query) async {
    final response = await http.get(
      Uri.parse("$baseURL$_endpointSearchRestaurant$query"),
    );
    var findRestaurant = Find.FindRestaurant.fromJson(
      jsonDecode(response.body),
    );

    if (response.statusCode == 200) {
      return findRestaurant;
    } else {
      throw Exception("Failed load Restaurants");
    }
  }
}
