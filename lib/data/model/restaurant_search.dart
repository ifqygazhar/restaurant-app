class FindRestaurant {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  FindRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory FindRestaurant.fromJson(Map<String, dynamic> json) => FindRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  List<Map<String, dynamic>> filterRestaurants() {
    return restaurants
        .map((restaurant) => {
              "id": restaurant.id,
              "pictureId": restaurant.pictureId,
              "title": restaurant.name,
              "city": restaurant.city,
              "rating": restaurant.rating,
            })
        .toList();
  }
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );
}

class FilteredRestaurant {
  String id;
  String name;
  String city;
  double rating;
  String pictureId;

  FilteredRestaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.pictureId,
  });

  factory FilteredRestaurant.fromJson(Map<String, dynamic> json) {
    return FilteredRestaurant(
      id: json["id"],
      name: json["name"],
      city: json["city"],
      rating: json["rating"]?.toDouble() ?? 0.0,
      pictureId: json["pictureId"],
    );
  }
}
