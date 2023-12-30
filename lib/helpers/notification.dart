import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

import '../common/navigation.dart';
import '../data/api/api_service.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload != null) {
          print('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Restaurant restaurant,
  ) async {
    if (Platform.isAndroid) {
      var channelId = "1";
      var channelName = "channel_01";
      var channelDescription = "Trending restaurant channel";

      var restaurantList = await ApiService().getAll(http.Client());
      var restaurantBreed = restaurantList.restaurants.toList();

      var randomIndex = Random().nextInt(restaurantBreed.length);
      var randomRestaruant = restaurantBreed[randomIndex];

      var title = "<b>Trending Restaurant</b>";
      var bodyNotification = randomRestaruant.name;

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true),
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      var titleNotification = title;
      var titleNews = "$bodyNotification di ${randomRestaruant.city}";

      await flutterLocalNotificationsPlugin.show(
        0,
        titleNotification,
        titleNews,
        platformChannelSpecifics,
        payload: json.encode(restaurant.toJson()),
      );
    }
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = Restaurant.fromJson(json.decode(payload));
        var result = data.restaurants[0];
        Navigation.intentWithData(route, result);
      },
    );
  }
}
