import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/accounts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationViewModel {

   String uid="";
   String email= "";
   String password= "";
   String firstName= "";
   String secondName= "";

  String message= "";

  /*void saveStore(){
    final store= Store(storeName, storeAddress);

    *//*FirebaseFirestore.instance.collection("stores").add({
      "name": store.name,
      "address": store.address,
    });*//*
    FirebaseFirestore.instance.collection("stores").add(store.toMap());
  }*/





}