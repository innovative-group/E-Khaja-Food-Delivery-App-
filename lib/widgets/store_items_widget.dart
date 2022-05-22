
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_sub_collection/view_models/store_item_list_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_item_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreItemsWidget extends StatefulWidget {

  String storeId;
  final StoreViewModel store;
  StoreItemListViewModel _storeItemListVM;


  StoreItemsWidget(this.store, this.storeId){
    _storeItemListVM= StoreItemListViewModel(store: store);
  }

  @override
  State<StoreItemsWidget> createState() => _StoreItemsWidgetState();
}

class _StoreItemsWidgetState extends State<StoreItemsWidget> {
  final _resturantNameController = TextEditingController();

  final _foodNameController = TextEditingController();

  final _foodImageController = TextEditingController();

  final _offerController = TextEditingController();

  final _locationController = TextEditingController();

  final _priceController = TextEditingController();

  final _ratingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _validate(String value) {
    if(value.isEmpty) {
      return "Field cannot be empty";
    }

    return null;
  }

  String downloadURL;

  void _saveStoreItem(){


    print("----->> below upload method call");
    print(downloadURL);
    if(_formKey.currentState.validate())
    {

      widget._storeItemListVM.resturantName= _resturantNameController.text;
      widget._storeItemListVM.foodName= _foodNameController.text;

      // print(widget._storeItemListVM.foodImage);
      widget._storeItemListVM.location= _locationController.text;
      widget._storeItemListVM.offer= _offerController.text;
      widget._storeItemListVM.price= double.parse(_priceController.text);
      widget._storeItemListVM.rating= double.parse(_ratingController.text);
      widget._storeItemListVM.foodImage= downloadURL;


      // save the store item

      widget._storeItemListVM.saveStoreItem();
      _clearTextBoxes();
    }
  }

  void _clearTextBoxes() {
    _foodNameController.clear();
    _resturantNameController.clear();
    _foodImageController.clear();
    _locationController.clear();
    _offerController.clear();
    _priceController.clear();
    _ratingController.clear();
  }

  File _image;

  final imagePicker= ImagePicker();

  Future imagePickerMethod() async
  {
    final pick= await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(pick != null)
      {
        _image= File(pick.path);

      }
      else
      {
        // showing a snackbar with error message to UI part
        showSnackBar("No Image selected", Duration(milliseconds: 1200));
      }
    });
  }

  Future uploadImage() async {
    final postID= DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref= FirebaseStorage.instance.ref().child("${widget.storeId}/images")
        .child("post_$postID");

    await ref.putFile(_image);
    var path=await ref.getDownloadURL();
    downloadURL= path;

    _saveStoreItem();

  }

  showSnackBar(String snackText, Duration d){
    final snackBar= SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Menus"),
        ),
        body:  Padding(
          padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(children: [


              GestureDetector(
                onTap: () {
                  imagePickerMethod();
                },
                child: CircleAvatar(
                  radius: 56.0,
                  child: ClipRRect(
                    child: Text("Pick Image"),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),

              TextFormField(
                controller: _foodNameController,
                validator: _validate,
                decoration: InputDecoration(
                  hintText: "Enter food name"
                ),
              ),



          /*TextFormField(
                    controller: _foodImageController,
                    validator: _validate,
                    decoration: InputDecoration(
                        hintText: "Enter food image"
                    ),
                  ),*/


          // -------------->> for showing location in 3d map
          // or to simply calculate the distance of customer to delivery food source

          /*TextFormField(
                    controller: _locationController,
                    validator: _validate,
                    decoration: InputDecoration(
                        hintText: "Enter resturant location"
                    ),
                  ),*/


              TextFormField(
                controller: _priceController,
                validator: _validate,
                decoration: InputDecoration(
                  hintText: "Enter price"
                ),
              ),

              TextFormField(
                controller: _offerController,
                validator: _validate,
                decoration: InputDecoration(
                  hintText: "Enter food offer"
                ),
              ),

              TextFormField(
                controller: _ratingController,
                validator: _validate,
                decoration: InputDecoration(
                    hintText: "Enter rating"
                ),
              ),

              RaisedButton(
                child: Text("Save", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
                onPressed: () {
                  uploadImage();
                  //Navigator.pop(context);
                },
              ),

              ]),
            ),
        ),
      ),
    );
  }
}