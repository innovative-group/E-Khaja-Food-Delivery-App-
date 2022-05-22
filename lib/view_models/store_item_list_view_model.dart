import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/storeItem.dart';
import 'package:firebase_sub_collection/view_models/store_view_model.dart';

class StoreItemListViewModel
{

   String resturantName;
   String foodName;
   String foodImage;
   String location;
   String offer;
   double price;
   double rating;
   //String imagePath;

    final StoreViewModel store;

    StoreItemListViewModel({this.store});

    void saveStoreItem(){
        final storeItem= StoreItem(resturantName, foodName, foodImage, location, offer, price, rating);

        print("****************>> "+ store.storeId);
        FirebaseFirestore.instance.collection("stores").doc(store.storeId)
        .collection("Menus").add(storeItem.toMap());
    }


    Stream<QuerySnapshot> get storeItemsAsStream{
        return FirebaseFirestore.instance.collection("stores").doc(store.storeId)
            .collection("Menus").snapshots();
    }
}