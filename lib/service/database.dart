import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserDetails(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    await _firestore
        .collection("users")
        .doc(id)
        .set(userInfoMap, SetOptions(merge: true));
  }

  Future<void> addUserOrderDetails(
    Map<String, dynamic> userOrderMap,
    String id,
    String orderId,
  ) async {
    await _firestore
        .collection("users")
        .doc(id)
        .collection("orders")
        .doc(orderId)
        .set(userOrderMap, SetOptions(merge: true));
  }

  Future<void> addAdminOrderDetails(
    Map<String, dynamic> userOrderMap,
    String orderId,
  ) async {
    await _firestore
        .collection("orders")
        .doc(orderId)
        .set(userOrderMap, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      String id) async {
    return _firestore.collection("users").doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    return _firestore.collection("users").get();
  }

  Future<void> updateUserDetails(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    await _firestore
        .collection("users")
        .doc(id)
        .set(updatedData, SetOptions(merge: true));
  }

  Future<void> deleteUser(String id) async {
    await _firestore.collection("users").doc(id).delete();
  }
}
