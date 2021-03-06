import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/store.dart';
import 'package:flutter/cupertino.dart';

class AddStoreViewModel extends ChangeNotifier{

  String imagePath= "";
  String  resturantName= "";
  String  location= "";
  String  offer= "";
  int     rating;
  String  message= "";
  String  email= "";
  int     contact;
  String  uid;

  /*void saveStore(){
    final store= Store(storeName, storeAddress);

    *//*FirebaseFirestore.instance.collection("stores").add({
      "name": store.name,
      "address": store.address,
    });*//*
    FirebaseFirestore.instance.collection("stores").add(store.toMap());
  }*/

  Future<bool> saveStore(String imagePath, String loggedUser_uid, String storeId, String check)async{

    bool isSaved= false;

    print("\n\n\n------------------->> "+ loggedUser_uid + "\n\n\n");

    //final store= Store(imagePath, resturantName, location, offer, rating);
    final store= Store(loggedUser_uid, imagePath, resturantName, location, offer, rating,  email, contact);

    try{
     //await FirebaseFirestore.instance.collection("stores").add(store.toMap());

      //await FirebaseFirestore.instance.collection("stores").doc(loggedUser_uid).set(store.toMap()); ------------>> using this a person can only register one store[free version] if he/she
      // try to add new more store then the sem store will be override
      if(check== "update"){
        await FirebaseFirestore.instance.collection("stores").doc(storeId)
            .update(store.toMap());
      }else {
        await FirebaseFirestore.instance.collection("stores").doc().set(store.toMap());
      }           //------------>> this statement will generate a document id everytime unique so user can create multiple store.

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