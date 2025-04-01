import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/Property_model.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
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

  // Delete a property and its images from Firestore & Firebase Storage
   Future<void> deleteProperty(String docId) async {
    try {
      DocumentSnapshot docSnapshot = await _propertiesRef.doc(docId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Delete property images
          if (data.containsKey('imageUrls')) {
            List<dynamic> imageUrls = data['imageUrls'];
            for (String imageUrl in imageUrls) {
              await _deleteFileFromStorage(imageUrl);
            }
          }

          // Delete property deed document
          if (data.containsKey('propertyDeedUrl')) {
            await _deleteFileFromStorage(data['propertyDeedUrl']);
          }

          // Delete property plan document
          if (data.containsKey('propertyPlanUrl')) {
            await _deleteFileFromStorage(data['propertyPlanUrl']);
          }
        }
      }

      // Delete the Firestore document
      await _propertiesRef.doc(docId).delete();
      print("✅ Property deleted successfully!");
    } catch (e) {
      print("❌ Error deleting property: $e");
    }
  }

  // Helper function to delete files from Firebase Storage
  Future<void> _deleteFileFromStorage(String fileUrl) async {
    try {
      Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
      print("✅ Deleted file: $fileUrl");
    } catch (e) {
      print("❌ Error deleting file: $e");
    }
  }

}
