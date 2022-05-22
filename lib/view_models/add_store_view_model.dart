import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/store.dart';
import 'package:flutter/cupertino.dart';

class AddStoreViewModel extends ChangeNotifier{

  String imagePath= "";
  String  resturantName= "";
  String  location= "";
  String  offer= "";
  int rating;
  String message= "";
  String email= "";
  int contact;

  /*void saveStore(){
    final store= Store(storeName, storeAddress);

    *//*FirebaseFirestore.instance.collection("stores").add({
      "name": store.name,
      "address": store.address,
    });*//*
    FirebaseFirestore.instance.collection("stores").add(store.toMap());
  }*/

  Future<bool> saveStore(String imagePath)async{

    bool isSaved= false;


    //final store= Store(imagePath, resturantName, location, offer, rating);
    final store= Store(imagePath, resturantName, location, offer, rating,  email, contact);

    try{
      await FirebaseFirestore.instance.collection("stores").add(store.toMap());
      isSaved= true;
      message= "Store has been Saved";


    } on Exception catch(_){
      message= "unable to save the store.";

    } catch(error) //----->> "error" is an generic error type
    {
      message= "Error occured!";
    }

    notifyListeners();
    return isSaved;
  }


}