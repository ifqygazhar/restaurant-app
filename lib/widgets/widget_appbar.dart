import 'package:flutter/material.dart';

AppBar buildAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
  );
}
