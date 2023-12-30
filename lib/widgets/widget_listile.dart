import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/widget_rating.dart';

ListTile buildListTile(String name, String city, String rating, ClipRRect clip,
    String id, BuildContext context) {
  return ListTile(
    title: Text(
      name,
      style: const TextStyle(color: Colors.white),
    ),
    subtitle: Text(city),
    subtitleTextStyle: const TextStyle(color: Colors.grey),
    leading: Stack(
      children: [
        clip,
        buildRatings(rating),
      ],
    ),
    onTap: () {
      Navigator.pushNamed(
        context,
        '/restaurant-detail',
        arguments: id,
      );
    },
  );
}
