import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Center buildEmpty(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/empty_white.svg",
          width: 150,
          height: 150,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
