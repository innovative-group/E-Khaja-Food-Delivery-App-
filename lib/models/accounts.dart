


import 'package:cloud_firestore/cloud_firestore.dart';

class Account{

    String uid;
    String email;
    String firstName;
    String secondName;
    String password;


  DocumentReference reference;

  Account({this.uid, this.email, this.firstName, this.secondName, this.password});

  String get storeId{
    return reference.id;
  }

  Map<String, dynamic> toMap(){
    return {
      "uid":  uid,
      "email": email,
      "firstName":    firstName,
      "secondName":    secondName,
      "password": password,

    };
  }

  //----------------------------->> Singleton Factory Function <<-----------------
  factory Account.fromSnapshot(doc){
    return Account(uid: doc["uid"],email: doc["email"], firstName: doc["firstName"], secondName: doc["secondName"], password: doc["password"]);
  }

    factory Account.fromMap(map) {
      return Account(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
      );
    }

}