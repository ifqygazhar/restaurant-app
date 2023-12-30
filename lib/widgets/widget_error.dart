import 'package:flutter/material.dart';

import '../helpers/enum_state.dart';

Center buildError(String message, ResultState state) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          state == ResultState.error
              ? Icons.error
              : Icons.signal_wifi_connected_no_internet_4,
          color: Colors.white,
          size: 120,
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
