import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String category;
  final Timestamp createdAt;
  final String currency;
  final String description;
  final List<String> imageUrls;
  final String name;
  final String price;
  final String propertyDeedUrl;
  final String propertyPlanUrl;
  final String userId;
  final String location;
  final List<String> features;

  Property({
    required this.id,
    required this.category,
    required this.createdAt,
    required this.currency,
    required this.description,
    required this.imageUrls,
    required this.name,
    required this.price,
    required this.propertyDeedUrl,
    required this.propertyPlanUrl,
    required this.userId,
    required this.location,
    required this.features,
  });

  // Factory method to create a Property object from Firestore data
  factory Property.fromFirestore(Map<String, dynamic> data, String id) {
    return Property(
      id: id,
      category: data['category'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      currency: data['currency'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      propertyDeedUrl: data['propertyDeedUrl'] ?? '',
      propertyPlanUrl: data['propertyPlanUrl'] ?? '',
      userId: data['userId'] ?? '',
      location: data['location'] ?? '',
      features: List<String>.from(data['features'] ?? []),
    );
  }

  // Add the `fromMap` method to create a Property object from a map
  factory Property.fromMap(Map<String, String> map) {
    return Property(
      id: map['id'] ?? '', // Assuming 'id' exists as a String in the map
      category: map['category'] ?? '',
      createdAt: Timestamp.now(), // Default to now if no value is provided
      currency: map['currency'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']?.split(',') ?? []), // If imageUrls is a comma-separated string
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      propertyDeedUrl: map['propertyDeedUrl'] ?? '',
      propertyPlanUrl: map['propertyPlanUrl'] ?? '',
      userId: map['userId'] ?? '',
      location: map['location'] ?? '',
      features: List<String>.from(map['features']?.split(',') ?? []), // If features are stored as a comma-separated string
    );
  }

  // Convert Property object to a Firestore-friendly Map
  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'createdAt': createdAt,
      'currency': currency,
      'description': description,
      'imageUrls': imageUrls,
      'name': name,
      'price': price,
      'propertyDeedUrl': propertyDeedUrl,
      'propertyPlanUrl': propertyPlanUrl,
      'userId': userId,
      'location': location,
      'features': features,
    };
  }

  // 📌 Add the copyWith method
  Property copyWith({
    String? id,
    String? category,
    Timestamp? createdAt,
    String? currency,
    String? description,
    List<String>? imageUrls,
    String? name,
    String? price,
    String? propertyDeedUrl,
    String? propertyPlanUrl,
    String? userId,
    String? location,
    List<String>? features,
  }) {
    return Property(
      id: id ?? this.id,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      name: name ?? this.name,
      price: price ?? this.price,
      propertyDeedUrl: propertyDeedUrl ?? this.propertyDeedUrl,
      propertyPlanUrl: propertyPlanUrl ?? this.propertyPlanUrl,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      features: features ?? this.features,
    );
  }
}
