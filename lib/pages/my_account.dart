import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sub_collection/models/accounts.dart';
import 'package:firebase_sub_collection/pages/add_store_page.dart';
import 'package:firebase_sub_collection/pages/store_item_list_page.dart';
import 'package:firebase_sub_collection/pages/store_list_page.dart';
import 'package:firebase_sub_collection/view_models/add_store_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_item_list_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_item_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_list_view_model.dart';
import 'package:firebase_sub_collection/view_models/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key key}) : super(key: key);

  int flag= 1;
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  User user = FirebaseAuth.instance.currentUser;
  StoreListViewModel _storeListVM= StoreListViewModel();

  Account loggedInUser= Account();



  @override
  void initState(){
    super.initState();

    FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((value){
      this.loggedInUser= Account.fromMap(value.data());
      setState((){

      });

    });
  }


  void _navigateToAddStorePage(BuildContext context, String loggedInUserUid) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeNotifierProvider(
      create: (context)=> AddStoreViewModel(),
      child: AddStorePage(userId: loggedInUserUid),

    )


    ));
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        print("Back Button is pressed.");
        return false;
      },

      child: Scaffold(
        body: Column(
          children: <Widget> [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/profilePic.PNG"),
              ),
              accountName: Text(loggedInUser.firstName !=null ? loggedInUser.firstName + " " + loggedInUser.secondName :   " "),
              accountEmail: Text(loggedInUser.email !=null ? loggedInUser.email : " "),
            ),

            SizedBox(height: 10),
            Text(
              'WelCome To DashBoard',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            Text(
              loggedInUser.firstName != null ? loggedInUser.firstName : " ",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 30.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Add Resturant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    _navigateToAddStorePage(context, loggedInUser.uid);
                    print("\n\n\n ------------_navigateToAddStorePage--------->> "+ loggedInUser.uid + "\n\n\n");
                  },

                ),



                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState((){
                      widget.flag= 0;
                    });

                    print("\n\n\n -----logout----->> "+widget.flag.toString());
                    Navigator.of(context).push(MaterialPageRoute(                       // this ntg value is not used just for to match method signature
                      builder: (context)=> StoreListPage(flag: widget.flag, logButton: "ntg"),
                    ));
                  },

                ),
              ],
            ),

            SizedBox(height: 10.0,),

            Expanded(
              child: Container(
                //margin: EdgeInsets.only(left: 10.0, right: 10.0,),


                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),

                  ),
                  border: Border.all(
                    width: 3,
                    color: Colors.green,
                    style: BorderStyle.solid,
                  ),
                ),

                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _storeListVM.storeAsStream,
                      builder: (context, snapshot){
                        if(snapshot.hasData && snapshot.data.docs.isNotEmpty){
                          return _buildList(snapshot.data);
                        }
                        else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                  ),
                ),

              ),
            ),


          ],
        ),
      ),
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


        if(loggedInUser.uid == store.store.loggedInUser_uid) {
          print("\n\n\n -------------| equal value | ---->> "+loggedInUser.uid);
          return _buildListItem(store, (store){
            _navigateToStoreItems(context, store);
          });

        }

        return Container(
          height: 10,
          width: 10.0,
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Center(child: Text("Scroll down")),
              Center(child: Text("to find your store")),
              //SizedBox(height: 50.0,),

              SizedBox(height: 50.0),
              Text("App is still under"),
              Text("construction"),


            ],
          ),
        );

      }),
    );



  }

  void _navigateToStoreItems(BuildContext context, StoreViewModel store)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreItemListPage(store, store.storeId, widget.flag)));
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

    return  GestureDetector(
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
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(
                  height: 100.0,
                  width: 152.0,
                  image: NetworkImage(store.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
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
                          padding: EdgeInsets.only(left: 0.0),
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

}
