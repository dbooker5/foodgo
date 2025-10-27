import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add user details to Firestore
  Future<void> addUserDetails(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    try {
      await _firestore.collection("users").doc(id).set(userInfoMap);
      print("User details added successfully for ID: $id");
    } catch (e) {
      print("Error adding user details: $e");
      rethrow;
    }
  }

  /// Fetch a single user's details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
    String id,
  ) async {
    try {
      return await _firestore.collection("users").doc(id).get();
    } catch (e) {
      print("Error fetching user details: $e");
      rethrow;
    }
  }

  /// Fetch all users (optional helper)
  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    try {
      return await _firestore.collection("users").get();
    } catch (e) {
      print("Error fetching users: $e");
      rethrow;
    }
  }

  /// Update user details
  Future<void> updateUserDetails(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await _firestore.collection("users").doc(id).update(updatedData);
      print("User details updated for ID: $id");
    } catch (e) {
      print("Error updating user details: $e");
      rethrow;
    }
  }

  /// Delete a user (optional, for admin or testing)
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection("users").doc(id).delete();
      print("User deleted: $id");
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }
}
