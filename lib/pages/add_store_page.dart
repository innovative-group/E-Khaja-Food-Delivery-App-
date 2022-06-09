import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_sub_collection/view_models/add_store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/store.dart';
import '../view_models/store_view_model.dart';

class AddStorePage extends StatefulWidget {

  String userId;
  String storeId;
  String check;
  StoreViewModel particularStore;
  StoreViewModel store;
  AddStorePage({Key key, this.userId, this.storeId, this.check, this.store}): super(key: key);

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {



  TextEditingController resName= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AddStoreViewModel _addStoreVM;

  void _saveStore(String imagePath, String loggedUser_uid, String storeId, String check) async{
    if(_formKey.currentState.validate())
      {
        final isSaved= await _addStoreVM.saveStore(imagePath,  loggedUser_uid, storeId, check);
        if(isSaved)
        {
           Navigator.pop(context);
        }
      }
  }




  //---------------------------------->> Image upload <<------------------------
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
          print("\n\n\n ----- File ------->> "+ _image.toString() + "\n\n\n");

        });
      }
      else
      {
        // showing a snackbar with error message to UI part
        showSnackBar("No Image selected", Duration(milliseconds: 1200));
      }
    });

  }

  Future uploadImage(String storeId, String check) async {
    final postID= DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref= FirebaseStorage.instance.ref().child("${widget.userId}/Resturants")
        .child("post_$postID");

    await ref.putFile(_image);
    downloadURL= await ref.getDownloadURL();
    print(downloadURL);

    _saveStore(downloadURL, widget.userId, storeId, check);

  }

  //---------------------------------------------------------------------------

  showSnackBar(String snackText, Duration d){
    final snackBar= SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  bool flag= false;
  @override
  Widget build(BuildContext context) {
    _addStoreVM= Provider.of<AddStoreViewModel>(context);

    return SafeArea(
      child: Scaffold(


          appBar: AppBar(
            backgroundColor: widget.check== "update" ?  Colors.lightBlue : Colors.green[400],
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,
                size: 20.0,
              ),
              onPressed: () {
                // passing this to our root
                Navigator.of(context).pop();
              },
            ),


              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: Container()),
                  widget.check== "update" ? Text("Update Your Store", style: TextStyle(color: Colors.white)) : Text("Add your restaurant",style: TextStyle(color: Colors.white)),
                  Expanded(flex: 6, child: Container()),

                ],),
          ),
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus.unfocus();
            },
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(

                child: Form(
                  key: _formKey,
                  child: Column(

                    children: <Widget> [

                      SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          print("\n\n\n --------->> Image path ------->> "+ _image.toString() + "\n\n\n");
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

                            ) : widget.check== "update" ? Image(
                              // height: 100.0,
                              width: 152.0,
                              image: NetworkImage(widget.store.imagePath),
                              fit: BoxFit.cover,
                            ): Text("Pick Image"),
                            borderRadius: BorderRadius.circular(55.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.0),
                      TextFormField(
                        style: TextStyle(fontSize: 16.0, color: Colors.black54,),
                        //controller: resName,
                        onTap:() {
                          if(resName.text== widget.store.resturantName){
                            _addStoreVM.resturantName= widget.store.resturantName;
                          }
                          else
                            {
                              _addStoreVM.resturantName= resName.text;
                            }
                        },

                        initialValue: widget.check== "update" ? widget.store.resturantName : " ",
                        onChanged: (value) => _addStoreVM.resturantName= value,
                        validator: (value) {
                          if (value.isEmpty) {
                             _addStoreVM.resturantName=widget.store.resturantName;
                            //return "Please enter resturant name";
                          }else
                            {
                              _addStoreVM.resturantName= value;
                            }

                          return null;
                        },
                        onSaved: (input) {
                          print("\n\n\n ------------>> onSaved value:: "+ input +"\n\n\n");
                          _addStoreVM.resturantName= "Hello!";
                        },
                        decoration: InputDecoration(
                          labelText: "Restaurant Name",
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),

                          prefixIcon: Icon(Icons.home,
                            color: Colors.green,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                        ),
                      ),



                      SizedBox(height: 20.0),



                  TextFormField(
                      style: TextStyle(fontSize: 16.0, color: Colors.black54,),
                      initialValue: widget.check== "update" ? widget.store.location : " ",
                     // autofocus: false,
                      validator: (value) {
                       // RegExp regex = new RegExp(r'^.{6,}$');  //------>> for validation
                        if (value.isEmpty) {
                          return ("Restaurant location can't be empty...");
                        }else
                        {
                          _addStoreVM.location= value;
                        }
                        return null;
                      },

                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        labelText: "Restaurant location",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),

                        prefixIcon: Icon(Icons.location_on,
                          color: Colors.green,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),


                      SizedBox(height: 20.0),


                      TextFormField(
                        style: TextStyle(fontSize: 16.0, color: Colors.black54,),
                        initialValue: widget.check== "update" ? widget.store.offer : " ",
                        onChanged: (value) => _addStoreVM.offer= value,
                        validator: (value) {
                          if (value.isEmpty) {
                            _addStoreVM.location=widget.store.offer;
                            //return "Please enter resturant name";
                          }else
                          {
                            _addStoreVM.offer= value;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Discount Offer",
                          labelStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),

                          prefixIcon: Icon(Icons.discount_sharp,
                            color: Colors.green,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                        ),
                      ),

                      SizedBox(height: 30.0),
                     /* RaisedButton(
                          child: Text(widget.check== "update" ? "update" : "save" ,
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {

                            if(_image== null)
                              {
                                print("\n\n------->> image path is null \n\n\n");
                                Fluttertoast.showToast(
                                  msg: "Please select an image",
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  //fontSize: 20.0,

                                );
                              }

                            uploadImage(widget.storeId, widget.check);
                            FocusScope.of(context).unfocus();
                          },
                          color: Colors.blue
                      ),*/


                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color:  widget.check== "update" ? Colors.blue[400] : Colors.green[300],
                    child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () {
                          if(_image== null)
                          {
                            print("\n\n------->> image path is null \n\n\n");
                            Fluttertoast.showToast(
                              msg: "Please select an image",
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              //fontSize: 20.0,

                            );
                          }


                           uploadImage(widget.storeId, widget.check);
                           FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          widget.check== "update" ? "update" : "save" ,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),


                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
