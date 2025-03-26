import 'package:flutter/material.dart';
import '../models/Property_model.dart';
import '../services/property_service.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyService _propertyService = PropertyService();
  List<Property> _properties = [];
  bool _isLoading = false;

  List<Property> get properties => _properties;
  bool get isLoading => _isLoading;

  // Fetch properties
  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();

    _properties = await _propertyService.fetchProperties();

    _isLoading = false;
    notifyListeners();
  }

  // Add a new property
  Future<void> addProperty(Property property) async {
    String? newPropertyId = await _propertyService.addProperty(property);
    if (newPropertyId != null) {
      _properties.add(property.copyWith(id: newPropertyId));
      notifyListeners();
    }
  }

  // Update property
  Future<void> updateProperty(String propertyId, Map<String, dynamic> updates) async {
    bool success = await _propertyService.updateProperty(propertyId, updates);
    if (success) {
      int index = _properties.indexWhere((property) => property.id == propertyId);
      if (index != -1) {
        // Using the copyWith method to update the property with new values
        _properties[index] = _properties[index].copyWith(
          category: updates['category'] ?? _properties[index].category,
          currency: updates['currency'] ?? _properties[index].currency,
          description: updates['description'] ?? _properties[index].description,
          price: updates['price'] ?? _properties[index].price,
          location: updates['location'] ?? _properties[index].location,
          features: updates['features'] ?? _properties[index].features,
          propertyDeedUrl: updates['propertyDeedUrl'] ?? _properties[index].propertyDeedUrl,
          propertyPlanUrl: updates['propertyPlanUrl'] ?? _properties[index].propertyPlanUrl,
        );
        notifyListeners();
      }
    }
  }

  // Delete property
  Future<void> deleteProperty(String propertyId) async {
    bool success = await _propertyService.deleteProperty(propertyId);
    if (success) {
      _properties.removeWhere((property) => property.id == propertyId);
      notifyListeners();
    }
  }
}
