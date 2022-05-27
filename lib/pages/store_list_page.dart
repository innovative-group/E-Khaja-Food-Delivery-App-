
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sub_collection/models/accounts.dart';
import 'package:firebase_sub_collection/pages/add_store_page.dart';
import 'package:firebase_sub_collection/pages/login_page.dart';
import 'package:firebase_sub_collection/pages/store_item_list_page.dart';
import 'package:firebase_sub_collection/provider/myprovider.dart';
import 'package:firebase_sub_collection/utils/constants.dart';
import 'package:firebase_sub_collection/view_models/add_store_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_list_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_view_model.dart';
import 'package:firebase_sub_collection/widgets/empty_results_widget.dart';
import 'package:firebase_sub_collection/widgets/recent_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_account.dart';

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPage createState() => _StoreListPage();
}

class _StoreListPage extends State<StoreListPage> {

  StoreListViewModel _storeListVM= StoreListViewModel();


  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
        stream: _storeListVM.storeAsStream,
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.data.docs.isNotEmpty){
            return _buildList(snapshot.data);
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  Widget _buildList(QuerySnapshot snapshot){
    final stores= snapshot.docs.map((doc)=> StoreViewModel.fromSnapshot(doc)).toList();
    /*return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index){
        final store= stores[index];

        return _buildListItem(store, (store){
          _navigateToStoreItems(context, store);
        });
      }
    );*/

    return GridView.count(
      //padding: EdgeInsets.only(left: 10.0, right: 10.0),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: List.generate(stores.length, (index) {
        final storeItem= stores[index];
        final store= stores[index];

        return _buildListItem(store, (store){
          _navigateToStoreItems(context, store);
        });

      }),


    );


  }


  User user = FirebaseAuth.instance.currentUser;
  Account loggedInUser= Account();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }





  void _navigateToStoreItems(BuildContext context, StoreViewModel store)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreItemListPage(store, store.storeId )));
  }


  Widget _buildListItem(StoreViewModel store,   void Function(StoreViewModel)  onStoreSelected)
  {
   /* return ListTile(
      title: Text(store.resturantName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Text(store.imagePath),
      trailing: Icon(Icons.arrow_forward_ios),
      leading: Text(store.storeId),

      onTap: () => onStoreSelected(store),
    );*/

    return GestureDetector(
      child: Container(


        // color: Colors.grey,
        //margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 1.0,
            color: Colors.grey[400],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                height: 100.0,
                width: 152.0,
                image: NetworkImage(store.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(

              child: Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /* ListTile(
                      leading: Icon(Icons.home),
                      title: Text(
                        store.resturantName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),*/
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        Container(
                          //color: Colors.green,
                            child: Icon(Icons.home,
                                size: 12.0
                            )),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Container(
                            //color: Colors.blue,
                            child: Text(
                              store.resturantName,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),),
                      ],
                    ),
                    //RatingStars(restaurant.rating),

                    //SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        Container(
                          //color: Colors.green,
                            child: Icon(Icons.location_on_sharp,
                              size: 12.0,
                            )),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Container(
                            //color: Colors.blue,
                            child: Text(
                              store.location,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),),
                      ],
                    ),
                    //SizedBox(height: 4.0),

                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget> [
                        Padding(
                          padding: EdgeInsets.only(left: 3.0),
                          child: Text(
                            '0.2 miles away',
                            //textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //SizedBox(height: 4.0),

                        SizedBox(width: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            Container(
                              //color: Colors.green,
                                child: Icon(Icons.discount,
                                  size: 12.0,
                                )),

                            SizedBox(width: 5.0),
                            Padding(
                              padding: EdgeInsets.only(left: 3.0, top: 5.0),
                              child: Text(
                                //store.offer != "0" ? "Offer "+ store.offer : "",

                                store.offer != "0" ?  store.offer : "",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )

                      ],
                    ),


                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        Container(
                            color: Colors.green,
                            child: Icon(Icons.local_offer_outlined)),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.blue,
                            child: Text(
                              store.offer,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),),
                      ],
                    ),*/

                  ],
                ),
              ),
            ),

          ],
        ),
      ),

      onTap: () => onStoreSelected(store),
    );

  }

  void _navigateToAddStorePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeNotifierProvider(
      create: (context)=> AddStoreViewModel(),
      child: AddStorePage(userId: loggedInUser.uid),

    )


    ));
  }



  MyProvider myProvider;


//----------------------------------------->> Building recent orders list <<-----------------------------------
  Widget _buildBottomPart(context) {
    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              // color: Colors.green,
              height: 90,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: myProvider.categoryModelList.length,
                      itemBuilder: (ctx, index)=>
                          _buildSingleCategory(
                              name: myProvider.getCategoryModelList[index].name,
                              image: myProvider.getCategoryModelList[index].image),

                    ),
                  ),
                ],
              ),
            ),
            /*     SizedBox(
              height: 10,
            ),*/

          ],
        ),
      ),
    );
  }



  Widget _buildSingleCategory({String image, String name}) {
    return Container(

      margin: EdgeInsets.all(10.0),
      width: 230.0,
      decoration: BoxDecoration(
        //color: Colors.orange,
        //color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 1.0,
          color: Colors.grey[300],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image(
                    height: 100.0,
                    width: 100.0,
                    image: NetworkImage(image),
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Container(
                    //color: Colors.yellow,
                    margin: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "resturant 1",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "Nov 20, 2019",
                          style: TextStyle(
                            //fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }











//-------------------------------------------------------------------------------------
  Widget _buildTopPart(context) {

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),

          )
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, bottom: 10.0),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.sort,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),



              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            //color: Colors.yellow,

            //color: Colors.green,

            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  maxRadius: 45,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    maxRadius: 40,
                    backgroundImage:
                    AssetImage("images/profilePic.PNG"),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 80,

                    child: ListTile(
                      title: Text(
                        "Are you hungry ?",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Need Food?",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),


          /*  Container(
            margin: EdgeInsets.only(bottom: 15.0, top: 0.0, left: 16.0, right: 16.0),
            padding: EdgeInsets.only(top: 0.0),
            child: TextFormField(

              //controller: searchQuery,
              decoration: InputDecoration(
                fillColor: Color(0xfff5d8e4),
                filled: true,
                hintText: "Search location",
                suffixIcon: IconButton(icon: Icon(Icons.search_sharp,),
                  onPressed: () {
                   *//* if(searchQuery.text.isEmpty)
                    {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        test= 0;
                        locations= "";
                      });
                    }
                    else
                    {
                      setState(() {

                        print("=========>> searchIcon Pressed <<========");
                        print(searchQuery.text);
                        locations= searchQuery.text;

                        FocusScope.of(context).requestFocus(FocusNode());
                        searchQuery.clear();
                      });
                    }*//*
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),


            ),
          ),
*/


        ],
      ),



    );
  }


//-------------------------------------------------------------------------------------

//--------------------------->> Drawer Part <<--------------------------------

  Widget _buildMyDrawer(context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("images/profilePic.PNG"),
            ),
            accountName: Text("Hari Shrestha"),
            accountEmail: Text("harishrestha@gmail.com"),
          ),
          TextButton(
            onPressed:() {Navigator.of(context).pop(); },
            child: ListTile(
              leading: Icon(
                Icons.home,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              title: Text("HomePage"),
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => LoginScreen(),
                ),
              );
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            title: Text("Register Shop"),
          ),

          ListTile(
            onTap: () {
              /* Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => About(),
                ),
              );*/
            },
            leading: Icon(
              Icons.info,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("About Us"),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("My Order"),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              title: Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------------------------------------------------------------

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    myProvider= Provider.of<MyProvider>(context);
    myProvider.getCategoryProduct();

    return Scaffold(

      key: _scaffoldKey,
      drawer: _buildMyDrawer(context),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          //---------------------------------------------------->> Main Background to all <<---------------
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [

              //------------>> Header-section Top [profile] part <<--------------
              _buildTopPart(context),
              //-----------------------------------------------------------------


              SizedBox(height: 10.0,),

              Expanded(
                flex: 30,
                child: Container(
                  //color: Colors.red,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(
                        'Recent Orders',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      _buildBottomPart(context),

                      SizedBox(height: 5.0),
                     /* Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(30.0),
                        ),

                        //color: Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                          child: Text(
                            'Nearby Restaurants',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),*/


                      Container(


                        //color: Colors.black12,
                        child: Text(
                          'Nearby Restaurants',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0),
                      Expanded(
                        flex: 7,
                        child: Container(

                                  //color: Colors.red,
                                    child: _buildBody()
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              )





    );
  }
}
