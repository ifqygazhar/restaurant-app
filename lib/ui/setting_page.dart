import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/widgets/widget_appbar.dart';

import '../provider/scheduling_provider.dart';
import '../provider/sharedpref_provider.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = "/setting";
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar("Settings", context),
      body: SafeArea(
        child: Consumer<SharedPrefProvider>(
          builder: (context, provider, child) {
            return ListTile(
              title: const Text(
                'Scheduling Restaurant',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, scheduled, _) {
                  return Switch.adaptive(
                    value: provider.isDailyActive,
                    onChanged: (value) async {
                      scheduled.scheduledRestaurant(value);
                      provider.enableDailyActive(value);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
