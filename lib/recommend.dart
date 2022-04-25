import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantFormatError implements Exception {
  DocumentSnapshot? doc;
  String message;
  RestaurantFormatError(this.message, [this.doc]);

  @override
  String toString() {
    return "$runtimeType: $message (restaurants/${doc?.id})";
  }
}

/// Stores the data of a recommended restaurant.
class Restaurant {
  /// The name of the restaurant
  String name;
  /// A few sentences describing the restaurant. TODO.
  String description;
  /// The location of the restaurant, i.e. Johnson Center.
  String location;
  /// A 7-element array of the hours of the restaurant. Each element is for a specific
  /// day of the week.
  List<String> hours;
  /// The dietary options provided by the restaurant, i.e. gluten-free, vegan.
  List<String> dietary;

  /// Initialize a new `Restaurant` with the given data.
  Restaurant(this.name, this.location, this.description, this.hours, this.dietary);

  /// Create a new restaurant from the given Firestore record. This handles all the
  /// necessary `dynamic` -> `String` or `dynamic` ->` List<String>` conversions and throws
  /// exceptions if unable to convert.
  static Restaurant fromRecord(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data();

    if (data == null) {
      throw RestaurantFormatError('unable to fetch restaurant', doc);
    }

    // runtime type checks
    if (data['name'] is! String) {
      throw RestaurantFormatError('invalid name', doc);
    } else if (data['location'] is! String) {
      throw RestaurantFormatError('invalid location', doc);
    } else if (data['description'] is! String) {
      throw RestaurantFormatError('invalid description', doc);
    } else if (data['hours'] is! List) {
      throw RestaurantFormatError('invalid hours', doc);
    } else if (data['dietary'] is! List) {
      throw RestaurantFormatError('invalid dietary restrictions', doc);
    }

    return Restaurant(data['name'],
                      data['location'],
                      data['description'],
                      List<String>.from(data['hours']),
                      List<String>.from(data['dietary']));
  }
}

/// A class to recommend determine which restaurant to recommend, given user
/// history, preferences, and a list of qualifying restaurants. A lot of the
/// calculations are actually done at init time, inside `forUser`.
class RestaurantRecommender {
  /// The user's preferences
  List<QueryDocumentSnapshot<Map<String, dynamic>>> preferences;
  /// The user's restaurant history
  List<QueryDocumentSnapshot<Map<String, dynamic>>> history;
  /// A list of possible restaurants that could be recommended to the user.
  /// This could be all restaurants, but will usually be filtered by dietary
  /// or culinary preferences.
  List<QueryDocumentSnapshot<Map<String, dynamic>>> restaurants;
  /// A list of all past recommendations. This is used to ensure that a restaurant
  /// isn't re-recommended when trying again.
  List<Restaurant> recommendations = [];

  /// Initialize a `RestaurantRecommender` with the given data.
  RestaurantRecommender(this.preferences, this.history, this.restaurants);

  /// Initialize a `RestaurantRecommender`, fetching the data for the given user.
  /// This should fail if the given user is not currently logged in.
  static Future<RestaurantRecommender> forUser(User user) async {
    var firestore = FirebaseFirestore.instance;
    var preferencesFuture = firestore.collection('preferences')
                                     .where('user', isEqualTo: user.uid)
                                     .get();
    var historyFuture = firestore.collection('history')
                                 .where('user', isEqualTo: user.uid)
                                 .get();
    // separating xFuture from x allows us to load them faster
    var preferences = await preferencesFuture;
    var history = await historyFuture;
    var restaurantsFuture = firestore.collection('restaurants')
                                     .get(); // todo check preferences and history

    return RestaurantRecommender(preferences.docs, history.docs, (await restaurantsFuture).docs);
  }

  /// Actually recommend a restaurant.
  Restaurant recommend() {
    var random = Random(DateTime.now().millisecondsSinceEpoch).nextInt(restaurants.length);
    return Restaurant.fromRecord(restaurants[random]);
  }
}