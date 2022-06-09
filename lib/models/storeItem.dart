import 'package:cloud_firestore/cloud_firestore.dart';

class StoreItem{

  String storeItemId;
  final String resturantName;
  final String foodName;
  final String foodImage;
  final String location;
  final String offer;
  final double price;
  final double rating;


  //final String imagePath;

  StoreItem(this.resturantName, this.foodName, this.foodImage, this.location, this.offer, this.price, this.rating, [this.storeItemId]);
  Map<String, dynamic> toMap(){
    return {
      "resturantName": resturantName ,
      "foodName": foodName,
      "foodImage": foodImage,
      "location": location,
      "offer": offer,
      "price": price,
      "rating": rating,
      //"image": imagePath,
    };
  }


  factory StoreItem.fromSnapshot(QueryDocumentSnapshot doc){
    return StoreItem(
      doc["resturantName"],
      doc["foodName"],
      doc["foodImage"],
      doc["location"],
      doc["offer"],
      doc["price"],
      doc["rating"],
    //  doc["imagePath"],


      doc.id,
    );
  }


}