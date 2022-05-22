
import 'package:cloud_firestore/cloud_firestore.dart';

class Store{

  final String imagePath;
  final String resturantName;
  final String location;
  final String offer;
  final int rating;
  final String email;
  final int contact;

  DocumentReference reference;

  Store(this.imagePath, this.resturantName, this.location, this.offer, this.rating,   this.email, this.contact, [this.reference] );
  //Store(this.imagePath, this.resturantName, this.location, this.offer, this.rating, [this.reference]);

  String get storeId{
    return reference.id;
  }

  Map<String, dynamic> toMap(){
    return {
      "imagePath": imagePath,
      "resturantName":  resturantName,
      "location": location,
      "offer":    offer,
      "rating":   rating,
      //"contact": contact,
      "email":   email,

    };
  }

  //----------------------------->> Singleton Factory Function <<-----------------
  factory Store.fromSnapshot(doc){
    //return Store(doc.data()["imagePath"], doc().data()["resturantName"],doc().data()["location"], doc().data()["offer"], doc().data()["rating"], doc.reference);
   return Store(doc.data()["imagePath"], doc.data()["resturantName"],doc.data()["location"], doc.data()["offer"], doc.data()["rating"],  doc.data()["email"], doc.data()["contact"], doc.reference);
  }
}