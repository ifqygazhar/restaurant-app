import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/helpers/enum_state.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/widget_appbar.dart';
import 'package:restaurant_app/widgets/widget_empty.dart';
import 'package:restaurant_app/widgets/widget_listile.dart';

import '../data/model/restaurant_detail.dart';
import '../widgets/widget_clipr.dart';

class FavoritePage extends StatelessWidget {
  static const String routeName = "/favorite";
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar("favorites", context),
      body: Consumer<DatabaseProvider>(
        builder: (context, state, child) {
          if (state.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = state.favorites[index];
                return Column(
                  children: [
                    Dismissible(
                      key: Key(restaurant.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        state.removeFavorite(restaurant.id);
                        const snackBar = SnackBar(
                          content: Text(
                            'Success delete favorite',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: (Colors.black12),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: buildListTile(
                          restaurant.name,
                          restaurant.city,
                          restaurant.rating.toString(),
                          buildImage(restaurant.pictureId, restaurant.id),
                          restaurant.id,
                          context),
                    ),
                  ],
                );
              },
            );
          } else {
            return buildEmpty(state.message);
          }
        },
      ),
    );
  }
}
