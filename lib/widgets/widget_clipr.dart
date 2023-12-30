import 'package:flutter/material.dart';

import '../data/api/api_service.dart';

ClipRRect buildImage(String picture, String id) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Hero(
      tag: id,
      child: Image.network(
        "${ApiService.baseURL}${ApiService.endpointImageMedium}$picture",
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.error_outline);
        },
        fit: BoxFit.fitWidth,
        width: 120,
      ),
    ),
  );
}
