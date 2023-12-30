import 'package:flutter/foundation.dart';

import '../helpers/shared_preferences.dart';

class SharedPrefProvider extends ChangeNotifier {
  SharedPrefProvider() {
    _getDailyActive();
  }

  bool _isDailyActive = false;
  bool get isDailyActive => _isDailyActive;

  void _getDailyActive() async {
    _isDailyActive = await isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDailyActive(bool value) {
    setDailyRestaurant(value);
    _getDailyActive();
  }
}
