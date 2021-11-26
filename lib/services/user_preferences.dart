import 'package:cloud_firestore/cloud_firestore.dart';

class UserPref {
  CollectionReference pref =
      FirebaseFirestore.instance.collection('preferences');

  Future<void> updatePref(
      String pincode, String day, String month, String year, bool notif) {
    return pref
        .doc('1')
        .update({
          'pincode': pincode,
          'day': day,
          'month': month,
          'year': year,
          'notif': notif,
        })
        .then((value) => print("Preferences Updated"))
        .catchError((error) => print("Failed to update preferences: $error"));
  }

  Future<void> updateStatus(bool notif) {
    return pref
        .doc('1')
        .update({
          'notif': notif,
        })
        .then((value) => print("Preferences Updated"))
        .catchError((error) => print("Failed to update preferences: $error"));
  }

  Future<Map<String, dynamic>?> getData() async {
    var collection = FirebaseFirestore.instance.collection('preferences');
    var docSnapshot = await collection.doc('1').get();
    Map<String, dynamic>? data = docSnapshot.data();
    return data;
  }
}
