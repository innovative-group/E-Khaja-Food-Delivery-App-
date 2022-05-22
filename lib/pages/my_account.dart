import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sub_collection/models/accounts.dart';
import 'package:firebase_sub_collection/pages/add_store_page.dart';
import 'package:firebase_sub_collection/pages/store_list_page.dart';
import 'package:firebase_sub_collection/view_models/add_store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatelessWidget {
  MyAccount({Key key}) : super(key: key);




  User user = FirebaseAuth.instance.currentUser;
  Account loggedInUser= Account();

  void _navigateToAddStorePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeNotifierProvider(
      create: (context)=> AddStoreViewModel(),
      child: AddStorePage(userId: loggedInUser.uid),

    )


    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget> [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/profilePic.PNG"),
              ),
              accountName: Text("Hari Shrestha"),
              accountEmail: Text("harishrestha@gmail.com"),
            ),

            SizedBox(height: 20),
            Text(
              'WelCome To DashBoard',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 100.0),

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
                _navigateToAddStorePage(context);
              },

            ),



            FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'close',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> StoreListPage(),
                ));
              },

            ),


          ],
        ),
      ),
    );
  }
}
