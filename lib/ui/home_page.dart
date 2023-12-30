import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/widgets/widget_empty.dart';

import '../data/api/api_service.dart';
import '../helpers/enum_state.dart';
import '../widgets/widget_error.dart';
import '../widgets/widget_rating.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Restaurant",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/search'),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/favorite'),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/setting'),
          ),
        ],
      ),
      body: _buildConsumer(),
    );
  }
}

Widget _buildConsumer() {
  return Consumer<RestaurantProvider>(
    builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.state == ResultState.hasData) {
        return _buildRestaurantItem(state);
      } else if (state.state == ResultState.noData) {
        return _buildStateHandle(state);
      } else if (state.state == ResultState.noInet) {
        return _buildStateHandle(state);
      } else if (state.state == ResultState.error) {
        return _buildStateHandle(state);
      } else {
        return const Center(
          child: Text(
            "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        );
      }
    },
  );
}

Widget _buildRestaurantItem(RestaurantProvider restaurantProvider) {
  return ListView.builder(
    itemCount: restaurantProvider.restaurant.restaurants.length,
    itemBuilder: (context, index) {
      RestaurantElement restaurant =
          restaurantProvider.restaurant.restaurants[index];
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 8),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            "/restaurant-detail",
            arguments: restaurant.id,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: restaurant.id,
                          child: Image.network(
                            "${ApiService.baseURL}${ApiService.endpointImageMedium}${restaurant.pictureId}",
                            errorBuilder: (_, __, ___) {
                              return const Icon(Icons.error_outline);
                            },
                            fit: BoxFit.fitWidth,
                            width: 120,
                          ),
                        ),
                      ),
                      buildRatings(restaurant.rating.toString()),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildDescription(restaurant),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Column _buildStateHandle(RestaurantProvider state) {
  return Column(
    children: [
      Expanded(
        child: state.state == ResultState.noData
            ? buildEmpty(state.message)
            : buildError(state.message, state.state),
      ),
    ],
  );
}

Expanded _buildDescription(RestaurantElement restaurant) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        Text(
          restaurant.description,
          style: const TextStyle(color: Colors.grey),
          overflow: TextOverflow.clip,
          maxLines: 2,
        ),
        const SizedBox(
          height: 8,
        ),
        _buildCity(restaurant)
      ],
    ),
  );
}

Row _buildCity(RestaurantElement restaurant) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red[500],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 245, 245, 245),
                size: 18,
              ),
              Text(
                restaurant.city,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
