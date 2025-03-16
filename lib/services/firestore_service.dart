import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Users').get();
      return snapshot.docs.map((doc) => {
            "uid": doc.id,
            "name": doc["name"],
            "email": doc["email"],
            "role": doc["role"],
            "status": doc["status"] ?? "Active",
          }).toList();
    } catch (e) {
      throw Exception("Failed to fetch users: $e");
    }
  }

  // Update user role
  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('Users').doc(uid).update({"role": newRole});
    } catch (e) {
      throw Exception("Failed to update role: $e");
    }
  }

  // Update user status (Active/Inactive)
  Future<void> updateUserStatus(String uid, String status) async {
    try {
      await _firestore.collection('Users').doc(uid).update({"status": status});
    } catch (e) {
      throw Exception("Failed to update status: $e");
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('Users').doc(uid).delete();
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }
}
