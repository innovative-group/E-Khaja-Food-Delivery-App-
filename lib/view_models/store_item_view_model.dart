import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/storeItem.dart';

class StoreItemViewModel{

  final StoreItem storeItem;
  StoreItemViewModel({this.storeItem});

  String get foodName{
    return storeItem.foodName;
  }

  String get foodImage{
    return storeItem.foodImage;
  }

  double get price{
    return storeItem.price;
  }

  double get rating{
    return storeItem.rating;
  }

/*
  String get resturantName{
    return storeItem.resturantName;
  }
*/


  String get storeItemId{
    return storeItem.storeItemId;
  }


  factory StoreItemViewModel.fromSnapshot(QueryDocumentSnapshot doc){
    final storeItem= StoreItem.fromSnapshot(doc);

    return StoreItemViewModel(storeItem: storeItem);
  }


}