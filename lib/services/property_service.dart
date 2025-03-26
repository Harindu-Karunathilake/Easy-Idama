import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Property_model.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _propertiesRef = FirebaseFirestore.instance.collection('Listings');

  // Fetch all properties from Firestore
  Future<List<Property>> fetchProperties() async {
    try {
      QuerySnapshot querySnapshot = await _propertiesRef.orderBy('createdAt', descending: true).get();
      return querySnapshot.docs.map((doc) {
        return Property.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("❌ Error fetching properties: $e");
      return [];
    }
  }

  // Fetch a single property by ID
  Future<Property?> getPropertyById(String propertyId) async {
    try {
      DocumentSnapshot doc = await _propertiesRef.doc(propertyId).get();
      if (doc.exists) {
        return Property.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("❌ Error fetching property by ID: $e");
    }
    return null;
  }

  // Add a new property to Firestore
  Future<String?> addProperty(Property property) async {
    try {
      DocumentReference docRef = await _propertiesRef.add(property.toFirestore());
      return docRef.id;
    } catch (e) {
      print("❌ Error adding property: $e");
      return null;
    }
  }

  // Update a property in Firestore
  Future<bool> updateProperty(String propertyId, Map<String, dynamic> updates) async {
    try {
      // Only include non-null fields in the updates
      Map<String, dynamic> filteredUpdates = {};
      updates.forEach((key, value) {
        if (value != null) {
          filteredUpdates[key] = value;
        }
      });

      await _propertiesRef.doc(propertyId).update(filteredUpdates);
      return true;
    } catch (e) {
      print("❌ Error updating property: $e");
      return false;
    }
  }

  // Delete a property from Firestore
  Future<bool> deleteProperty(String propertyId) async {
    try {
      await _propertiesRef.doc(propertyId).delete();
      return true;
    } catch (e) {
      print("❌ Error deleting property: $e");
      return false;
    }
  }
}
