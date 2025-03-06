class Property {
  final String name;
  final String location;
  final String image;
  final String category;

  Property({
    required this.name,
    required this.location,
    required this.image,
    required this.category,
  });

  // Factory method to create a Property object from a Map
  factory Property.fromMap(Map<String, String> map) {
    return Property(
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      image: map['image'] ?? '',
      category: map['catoegary'] ?? '',
    );
  }
}
