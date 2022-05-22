import 'package:cloud_firestore/cloud_firestore.dart';

class StoreListViewModel{
  Stream<QuerySnapshot> get storeAsStream{
    return FirebaseFirestore.instance.collection("stores").snapshots();
  }

  Stream<QuerySnapshot> get userInfoAsStream{
    return FirebaseFirestore.instance.collection("users").snapshots();
  }
}