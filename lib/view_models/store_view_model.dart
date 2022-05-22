import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/accounts.dart';
import 'package:firebase_sub_collection/models/store.dart';

class StoreViewModel
{
  final Store store;
  StoreViewModel({this.store});



  String get imagePath{
    return store.imagePath;
  }
  String get storeId{
    return store.storeId;
  }

  String get resturantName{
    return store.resturantName;
  }



  String get location{
    return store.location;
  }

  String get offer{
    return store.offer;
  }

  int  get rating{
    return store.rating;
  }

  int get contact{
    return store.contact;
  }

  String get email{
    return store.email;
  }



  //----------------------------->> Singleton Factory Function <<-----------------
  factory StoreViewModel.fromSnapshot(QueryDocumentSnapshot doc){
    final store= Store.fromSnapshot(doc);
    return StoreViewModel(store: store);

  }



}