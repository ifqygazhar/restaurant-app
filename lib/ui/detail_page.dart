import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/widget_empty.dart';

import '../data/api/api_service.dart';
import '../data/model/restaurant_detail.dart';
import '../helpers/enum_state.dart';
import '../provider/restaurant_detail_provider.dart';
import '../widgets/widget_error.dart';

class RestaurantDetail extends StatelessWidget {
  static const routeName = "/restaurant-detail";
  final String restaurantId;
  const RestaurantDetail({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Consumer<DatabaseProvider>(builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorite(restaurantId),
          builder: (context, snapshot) {
            var isMarked = snapshot.data ?? false;
            return Consumer<RestaurantDetailProvider>(
              builder: (context, state, child) {
                if (state.state == ResultState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.state == ResultState.hasData) {
                  final restaurantDetail = state.restaurantDetail.restaurant;
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 200.0,
                        floating: false,
                        pinned: true,
                        leading: _buildButtonBack(context),
                        actions: [
                          _buildButtonLove(isMarked, provider, state, context),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Hero(
                            tag: restaurantId,
                            child: Image.network(
                              "${ApiService.baseURL}${ApiService.endpointImageLarge}${restaurantDetail.pictureId}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _buildDetailContent(restaurantDetail),
                      ),
                    ],
                  );
                } else if (state.state == ResultState.noData) {
                  return _buildStateHandle(state);
                } else if (state.state == ResultState.noInet) {
                  return _buildStateHandle(state);
                } else if (state.state == ResultState.error) {
                  return _buildStateHandle(state);
                } else {
                  return const Center(
                    child: Text(""),
                  );
                }
              },
            );
          },
        );
      }),
    );
  }

  Padding _buildStateHandle(RestaurantDetailProvider state) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 10),
      child: Column(
        children: [
          Expanded(
            child: state.state == ResultState.noData
                ? buildEmpty(state.message)
                : buildError(state.message, state.state),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildDetailContent(Restaurant restaurantDetail) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  restaurantDetail.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                _buildRating(restaurantDetail.rating.toString()),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            _buildCity(restaurantDetail.city),
            const SizedBox(
              height: 8,
            ),
            Text(
              restaurantDetail.description,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.justify,
              maxLines: 7,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Foods",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            _buildMenuItem(restaurantDetail.menus.foods),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Drinks",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            _buildMenuItem(restaurantDetail.menus.drinks),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildMenuItem(List<Category> foods) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: foods
            .map(
              (food) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[500],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  food.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Container _buildCity(String city) {
    return Container(
      width: 102,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.red[500],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 20,
          ),
          Text(
            city,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildRating(String rating) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          const Icon(
            Icons.star,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            rating,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Padding _buildButtonBack(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            iconSize: 24.0,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Padding _buildButtonLove(bool isMarked, DatabaseProvider provider,
      RestaurantDetailProvider state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: isMarked
            ? IconButton(
                onPressed: () => provider.removeFavorite(restaurantId),
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              )
            : IconButton(
                onPressed: () =>
                    provider.addFavorite(state.restaurantDetail.restaurant),
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
