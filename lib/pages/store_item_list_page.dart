
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_sub_collection/pages/SingleMenuItem.dart';
import 'package:firebase_sub_collection/pages/cart_page.dart';
import 'package:firebase_sub_collection/view_models/store_item_list_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_item_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_view_model.dart';
import 'package:firebase_sub_collection/widgets/store_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreItemListPage extends StatefulWidget {

  int flag;
  String storeId;
  bool hasInternet;
  final StoreViewModel store;
  StoreItemListViewModel _storeItemListVM;


  StoreItemListPage(this.store, this.storeId, this.flag, [this.hasInternet]){
    _storeItemListVM= StoreItemListViewModel(store: store);
  }

  @override
  State<StoreItemListPage> createState() => _StoreItemListPageState();
}

class _StoreItemListPageState extends State<StoreItemListPage> {
  StoreItemListViewModel _storeItemListViewModel;




  //--------------------------------------------------------------------------------







  Widget _buildStoreItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._storeItemListVM.storeItemsAsStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Text("No items found!");

        final storeItems= snapshot.data.docs.map((item)=> StoreItemViewModel.fromSnapshot(item)).toList();

        return ListView.builder(
          itemCount: storeItems.length,
          itemBuilder: (BuildContext context, int index) {

            final storeItem= storeItems[index];
            /*return ListTile(
              title: Text(storeItem.foodName ?? ""),
              subtitle: Text(storeItem.price.toString() ?? ""),
              leading: Text(storeItem.storeItemId ?? ""),
            );*/





          }
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            //elevation: 0.0,
            //centerTitle: true,
            backgroundColor: Colors.green,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(flex: 10, child:  Text(widget.store.resturantName,)),
                  Expanded(flex: 2, child:  Container(
                   // padding: EdgeInsets.all(5),

                    color: Colors.red,
                    child: GestureDetector(

                      onTap: () {

                        print("\n\n\n ---------> cart is pressed \n\n\n");
                        showDialog(
                          context: context,
                          builder: (context)=> CartPage(
                            title: "Your Order List",
                            description: "This app is still under construction. Right now confirm_button doesn't work you can confirm your order by making a direct call.",
                          ),
                        );

                      },
                      child: Image(
                        image: AssetImage("assets/icons/e1green.png",),
                      ),
                    ),
                  )),

                ],),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context, true);
                },


              ),



          ),
        ),
        body: SafeArea(
          child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: widget.hasInternet != true ? Center(child: CircularProgressIndicator()) : widget.store.imagePath,
                        child: Image(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          image: NetworkImage(widget.store.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /*IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                              iconSize: 30.0,
                              onPressed: () => Navigator.pop(context),
                            ),

                            //ext(widget.store.resturantName,),

                            IconButton(
                              icon: Icon(Icons.favorite),
                              color: Theme.of(context).primaryColor,
                              iconSize: 35.0,
                              onPressed: () {},
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.store.resturantName,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            '0.2 miles away',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),

                          ),
                        ],
                      ),

                      SizedBox(height: 6.0),
                      /*Text(
                        widget.store.location,
                        style: TextStyle(fontSize: 18.0),
                      ),*/

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Container(
                            //color: Colors.green,
                              child: Icon(Icons.location_on_sharp,
                                size: 16.0,
                              )),
                          SizedBox(width: 13.0),
                          Expanded(
                            flex: 2,
                            child: Container(
                              //color: Colors.blue,
                              child: Text(
                                widget.store.location,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),),
                        ],
                      ),

                    ],
                  ),
                ),


                SizedBox(height: 5.0),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          widget.flag== 1 ? "Add Menu" : "Review",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                              letterSpacing: 1.0
                          ),
                        ),
                        onPressed: () {
                         /* final toEmail= 'righthuman082@gmail.com';
                          final subject='Just an email';
                          final message= 'Hello! I am fine.';

                          final url= 'mailto:$toEmail?subject=${subject}&body=${message}';
                          if(await canLaunch(url))
                            {
                              await launch(url);
                            }*/


                          if(widget.flag== 1) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StoreItemsWidget(widget.store,
                                          widget.storeId),
                                ));

                          }else {
                            launch('sms:+977 ${widget.store.contact}');   //----------->> SMS functionality for review mechanism
                          }


                            //launch('mailto:righthuman082@gmail.com?subject=This is a subject');

                           /*
                           //---------->> using email launcher package <<------
                           Email email = Email(

                                to: ['righthuman082@gmail.com'],
                                cc: ['foo@gmail.com'],
                                bcc: ['bar@gmail.com'],
                                subject: 'subject',
                                body: 'body'
                            );
                            await EmailLauncher.launch(email);*/
                        },
                      ),


                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                letterSpacing: 1.0,

                              ),
                            ),

                            SizedBox(width: MediaQuery.of(context).size.width/40),
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context)=> const CartPage(
                              title: "Your Order List",
                              description: "This app is still under construction. Right now confirm_button doesn't work you can confirm your order by making a direct call.",
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 10.0),


                SizedBox(height: 5.0),
                Expanded(
                  flex: 3,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: widget._storeItemListVM.storeItemsAsStream,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) return Text("No items found!");

                      final storeItems= snapshot.data.docs.map((item)=> StoreItemViewModel.fromSnapshot(item)).toList();

                      /*return GridView.count(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        crossAxisCount: 2,
                          children: List.generate(storeItems.length, (index) {
                            final storeItem= storeItems[index];
                            return Center(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      //margin: EdgeInsets.all(10.0),
                                      height: 175.0,
                                      width: 175.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(storeItem.foodImage),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    Container(
                                      //margin: EdgeInsets.all(10.0),
                                      height: 175.0,
                                      width: 175.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black87.withOpacity(0.3),
                                            Colors.black54.withOpacity(0.3),
                                            Colors.black38.withOpacity(0.3),
                                          ],
                                          stops: [0.1, 0.4, 0.6, 0.9],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 65.0,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            storeItem.foodName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          Text(
                                            'Rs ${storeItem.price}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10.0,
                                      right: 10.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 30.0,
                                          color: Colors.white,
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                          }),




                      );*/

                      return GridView.count(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        crossAxisCount: 2,
                        children: List.generate(storeItems.length, (index) {
                          final storeItem= storeItems[index];

                          return SingleMenuItem(storeItem: storeItem);



                        }),




                      );

                    },
                  ),
                ),

              ],

          ),
        ),
    );

  }
}