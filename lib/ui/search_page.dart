import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';

import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/widgets/widget_appbar.dart';
import 'package:restaurant_app/widgets/widget_empty.dart';
import 'package:restaurant_app/widgets/widget_error.dart';

import '../data/api/api_service.dart';
import '../helpers/enum_state.dart';
import '../widgets/widget_listile.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search";

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar("Search", context),
      backgroundColor: Theme.of(context).primaryColor,
      body: _buildConsumer(),
    );
  }

  Widget _buildConsumer() {
    return Consumer<FindRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          return _buildListItem(state);
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

  Padding _buildStateHandle(FindRestaurantProvider state) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 10),
      child: Column(
        children: [
          _buildInputSearch(searchController, context),
          Expanded(
            child: state.state == ResultState.noData
                ? buildEmpty("${searchController.text}${state.message}")
                : buildError(state.message, state.state),
          ),
        ],
      ),
    );
  }

  Column _buildListItem(FindRestaurantProvider findRestaurantProvider) {
    final searchResults = findRestaurantProvider.filteredRestaurants;

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 10),
          child: _buildInputSearch(searchController, context),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              FilteredRestaurant restaurant = searchResults[index];
              return buildListTile(
                restaurant.name,
                restaurant.city,
                restaurant.rating.toString(),
                _buildImage(restaurant),
                restaurant.id,
                context,
              );
            },
          ),
        ),
      ],
    );
  }
}

Container _buildInputSearch(TextEditingController searchController, context) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: TextField(
      controller: searchController,
      decoration: const InputDecoration(
        hintText: 'Enter restaurant name or city...',
        hintStyle: TextStyle(fontSize: 14.8, color: Colors.grey),
        prefixIcon: Icon(
          Icons.search,
        ),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          Provider.of<FindRestaurantProvider>(context, listen: false)
              .fetchSearchRestaurant(searchController.text);
        }
      },
    ),
  );
}

ClipRRect _buildImage(FilteredRestaurant restaurant) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Hero(
      tag: restaurant.id,
      child: Image.network(
        "${ApiService.baseURL}${ApiService.endpointImageMedium}${restaurant.pictureId}",
        fit: BoxFit.fitWidth,
        width: 120,
      ),
    ),
  );
}
