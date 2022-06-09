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
    final image= await imagePicker.pickImage(source: ImageSource.gallery );

    setState(() {
      if(image != null)
      {

        final imageTemporary= File(image.path);
        setState((){
          this._image= imageTemporary;

        });
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

        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: Container()),
                Text("Add Your Store",),
                Expanded(flex: 6, child: Container()),

              ],),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(

            child: Form(
              key: _formKey,
              child: Column(

                children: <Widget> [


                  GestureDetector(
                    onTap: () {
                      imagePickerMethod();
                    },
                    child: CircleAvatar(
                      radius: 56.0,
                      child: ClipRRect(
                        child: _image != null ? Image.file(
                          _image,
                          width: 110.0,
                          height: 110.0,
                          fit: BoxFit.cover,

                        ) : Text("Pick Image"),
                        borderRadius: BorderRadius.circular(55.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 5.0),
                  TextFormField(
                    onChanged: (value) => _addStoreVM.resturantName= value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter resturant name";
                        return "Please enter resturant name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Enter resturant name"),
                  ),

                  SizedBox(height: 5.0),
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

                  SizedBox(height: 5.0),
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

                  SizedBox(height: 5.0),
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


                  SizedBox(height: 10.0),
                  RaisedButton(
                      child: Text("Save", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        uploadImage();
                      },
                      color: Colors.blue
                  ),



                ],
              ),
            ),
          ),
        ),
    );
  }
}
