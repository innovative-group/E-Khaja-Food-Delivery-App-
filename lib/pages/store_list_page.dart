
import 'dart:io';

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
          return EmptyResultsWidget(message: Constants.NO_STORES_FOUND);
        }
      }
    );
  }

  Widget _buildList(QuerySnapshot snapshot){
    final stores= snapshot.docs.map((doc)=> StoreViewModel.fromSnapshot(doc)).toList();
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index){
        final store= stores[index];

        return _buildListItem(store, (store){
          _navigateToStoreItems(context, store);
        });
      }
    );
  }


  User user = FirebaseAuth.instance.currentUser;
  Account loggedInUser= Account();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {

      setState(() {
      });
      this.loggedInUser = Account.fromMap(value.data());
      setState(() {
      });
    });
  }





  void _navigateToStoreItems(BuildContext context, StoreViewModel store)
  {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreItemListPage(store, store.storeId )));
  }


  Widget _buildListItem(StoreViewModel store,   void Function(StoreViewModel)  onStoreSelected)
  {
/*    return ListTile(
      title: Text(store.resturantName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Text(store.imagePath),
      trailing: Icon(Icons.arrow_forward_ios),
      leading: Text(store.storeId),

      onTap: () => onStoreSelected(store),
    );*/

    return GestureDetector(
      child: Container(
        //color: Colors.grey,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 1.0,
            color: Colors.grey[300],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                height: 150.0,
                width: 150.0,
                image: NetworkImage(store.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 12.0),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        Container(
                          //color: Colors.green,
                          child: Icon(Icons.home,
                            size: 20.0
                          )),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Container(
                          //color: Colors.blue,
                          child: Text(
                            store.resturantName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),),
                      ],
                    ),
                    //RatingStars(restaurant.rating),

                    SizedBox(height: 4.0),
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
                              store.location,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0,),
                      child: Text(
                        '0.2 miles away',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 4.0),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0, top: 5.0),
                      child: Text(
                        store.offer != "0" ? "Offer "+ store.offer : "",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 20),
        //color: Color(0xfff2f3f4),
        //color: Colors.blue,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              //color: Colors.green,
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
      width: 250.0,
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
                    fit: BoxFit.cover,
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
            margin: EdgeInsets.only(left: 16, bottom: 20.0),
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
            margin: EdgeInsets.only(bottom: 20.0),
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
                  builder: (ctx) => MyAccount(),
                ),
              );
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            title: Text("My Account"),
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
            //color: Colors.green,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [


                _buildTopPart(context),

                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    //color: Colors.yellow,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [

/*
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: <Widget> [

                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget> [Text(loggedInUser.secondName ?? ""),
                                Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Icon(Icons.add),
                                  onTap: () {
                                    _navigateToAddStorePage(context);
                                  },
                                ),
                              ), ]),
                              Text(loggedInUser.firstName ?? ""),
                              Text(loggedInUser.email ?? ""),
                              Text(loggedInUser.uid ?? ""),
                            ],
                          ),
                        ),*/



                      ],
                    ),
                  ),
                ),




               Expanded(
                 flex: 30,
                 child: Container(
                   margin: EdgeInsets.symmetric(horizontal: 20.0),
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

                       Text(
                         'Nearby Restaurants',
                         style: TextStyle(
                           fontSize: 24.0,
                           fontWeight: FontWeight.w600,
                           letterSpacing: 1.2,
                         ),
                       ),
                       Expanded(
                         flex: 7,
                         child: Container(
                             margin: EdgeInsets.only(top: 00.0),
                             //color: Colors.red,
                             child: _buildBody()
                         ),
                       ),

                     ],
                   ),
                 ),
               )


              ],
            ),
          ),
        ),

    );
  }
}
