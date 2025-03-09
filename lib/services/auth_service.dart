import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String email, String password, String name) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user ID
      User? user = userCredential.user;

      if (user != null) {
        // Store user details in Firestore using UID as Document ID
        await _firestore.collection('Users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'role': 'user', // Default role is "user"
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("User registered and data stored in Firestore!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('FirebaseAuthException: ${e.message}');
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }
}