import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add user details (does NOT wipe data)
  Future<void> addUserDetails(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    try {
      await _firestore
          .collection("users")
          .doc(id)
          .set(userInfoMap, SetOptions(merge: true));
      print("User details added/updated successfully for ID: $id");
    } catch (e) {
      print("Error adding user details: $e");
      rethrow;
    }
  }

  /// Add user order details (merge so it doesn't overwrite)
  Future<void> addUserOrderDetails(
    Map<String, dynamic> userOrderMap,
    String id,
    String orderId,
  ) async {
    try {
      await _firestore
          .collection("users")
          .doc(id)
          .collection("orders")
          .doc(userOrderMap["OrderId"])
          .set(userOrderMap, SetOptions(merge: true));
      print("User order details added successfully for ID: $orderId");
    } catch (e) {
      print("Error adding user order details: $e");
      rethrow;
    }
  }

  /// Admin order
  Future<void> addAdminOrderDetails(
    Map<String, dynamic> userOrderMap,
    String orderId,
  ) async {
    try {
      await _firestore
          .collection("orders")
          .doc(userOrderMap["OrderId"])
          .set(userOrderMap, SetOptions(merge: true));
      print("User order details added successfully for ID: $orderId");
    } catch (e) {
      print("Error adding user order details: $e");
      rethrow;
    }
  }

  /// Fetch single user
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

  /// Fetch all users
  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    try {
      return await _firestore.collection("users").get();
    } catch (e) {
      print("Error fetching users: $e");
      rethrow;
    }
  }

  /// Update user (safe even if doc does not exist)
  Future<void> updateUserDetails(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await _firestore
          .collection("users")
          .doc(id)
          .set(updatedData, SetOptions(merge: true));
      print("User details updated for ID: $id");
    } catch (e) {
      print("Error updating user details: $e");
      rethrow;
    }
  }

  /// Delete user
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
