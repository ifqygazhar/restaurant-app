import 'package:flutter/material.dart';

Positioned buildRatings(String rating) {
  return Positioned(
    bottom: 8,
    right: 8,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            size: 12,
            color: Colors.orange,
          ),
          Text(
            rating,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
