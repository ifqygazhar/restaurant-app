import 'package:shared_preferences/shared_preferences.dart';

Future<bool> get isDailyRestaurantActive async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDailyRestaurantActive') ?? false;
}

Future<void> setDailyRestaurant(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDailyRestaurantActive', value);
}
