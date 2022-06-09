import 'package:firebase_sub_collection/pages/login_page.dart';
import 'package:firebase_sub_collection/pages/store_list_page.dart';
import 'package:firebase_sub_collection/provider/homeCategory.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,

  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<MyProvider>(
      create: (ctx)=> MyProvider(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.green
          ),

        //home: LoginScreen(),
        home: StoreListPage(),

    ),


    );

    
  }
}
