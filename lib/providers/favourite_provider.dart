import 'package:flutter/material.dart';
import 'package:mad/models/Property_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Property> _favoriteProperties = [];

  List<Property> get favoriteProperties => _favoriteProperties;

  void toggleFavorite(Property property) {
    if (_favoriteProperties.any((fav) => fav.name == property.name)) {
      _favoriteProperties.removeWhere((fav) => fav.name == property.name);
    } else {
      _favoriteProperties.add(property);
    }
    notifyListeners();
  }

  bool isFavorite(Property property) {
    return _favoriteProperties.any((fav) => fav.name == property.name);
  }
}
