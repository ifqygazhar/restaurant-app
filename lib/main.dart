import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/provider/sharedpref_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';
import 'package:restaurant_app/ui/favorite_page.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/ui/setting_page.dart';

import 'data/db/database_helper.dart';
import 'helpers/background_service.dart';
import 'helpers/notification.dart';
import 'provider/database_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  await AndroidAlarmManager.initialize();
  service.initializeIsolate();

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FindRestaurantProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(create: (_) => SharedPrefProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: HomePage.routeName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF100F1F),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          HomePage.routeName: (context) {
            return const HomePage();
          },
          RestaurantDetail.routeName: (context) {
            final restaurantId =
                ModalRoute.of(context)?.settings.arguments as String;
            return ChangeNotifierProvider(
              create: (context) => RestaurantDetailProvider(
                apiService: ApiService(),
                restaurantId: restaurantId,
              ),
              child: RestaurantDetail(restaurantId: restaurantId),
            );
          },
          SearchPage.routeName: (context) {
            return const SearchPage();
          },
          FavoritePage.routeName: (context) {
            return const FavoritePage();
          },
          SettingPage.routeName: (context) {
            return const SettingPage();
          }
        },
      ),
    );
  }
}
