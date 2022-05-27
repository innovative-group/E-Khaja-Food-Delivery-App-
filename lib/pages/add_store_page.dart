import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_sub_collection/view_models/add_store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddStorePage extends StatefulWidget {

  String userId;

  AddStorePage({Key key, this.userId}): super(key: key);

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _formKey = GlobalKey<FormState>();

  AddStoreViewModel _addStoreVM;

  void _saveStore(String imagePath, String loggedUser_uid) async{
    if(_formKey.currentState.validate())
      {
        final isSaved= await _addStoreVM.saveStore(imagePath, loggedUser_uid);
        if(isSaved)
        {
           Navigator.pop(context);
        }
      }
  }




  //---------------------------------->> Image upload <<-----------------------
  File _image;
  final imagePicker= ImagePicker();
  String downloadURL;

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
    Reference ref= FirebaseStorage.instance.ref().child("${widget.userId}/Resturants")
        .child("post_$postID");

    await ref.putFile(_image);
    downloadURL= await ref.getDownloadURL();
    print(downloadURL);

    _saveStore(downloadURL, widget.userId);

  }

  //---------------------------------------------------------------------------

  showSnackBar(String snackText, Duration d){
    final snackBar= SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  @override
  Widget build(BuildContext context) {
    _addStoreVM= Provider.of<AddStoreViewModel>(context);

    return Scaffold(
        appBar: AppBar(title: Text("Add Store")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

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
                  onChanged: (value) => _addStoreVM.resturantName= value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter resturant name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Enter resturant name"),
                ),
                TextFormField(
                  onChanged: (value) => _addStoreVM.location= value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter resturant location";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Enter store address"),
                ),

               /* TextFormField(
                  onChanged: (value) => _addStoreVM.image= "https://www.pngall.com/wp-content/uploads/2016/05/Salad-PNG-Image.png",
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter resturant image";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Enter resturant image"),
                ),*/

                TextFormField(
                  onChanged: (value) => _addStoreVM.rating= int.parse(value),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter resturant rating";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Enter resturant rating"),
                ),

                TextFormField(
                  onChanged: (value) => _addStoreVM.offer= value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter resturant offer";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Enter resturant offer"),
                ),


                RaisedButton(
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      uploadImage();
                    },
                    color: Colors.blue),
                    Spacer(),
                    Text(_addStoreVM.message)
              ],
            ),
          ),
        ));
  }
}
