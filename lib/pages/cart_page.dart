import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view_models/store_view_model.dart';
import '../widgets/store_items_widget.dart';

class CartPage extends StatefulWidget {


  final StoreViewModel store;
  final String title, description, buttonText;
  final Image image;

  const CartPage({Key key, this.title, this.description, this.buttonText, this.image, this.store}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [

          Container(
            padding: EdgeInsets.only(top: 100.0, bottom: 16.0, left: 16.0, right: 16.0,),
            margin: EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow:  [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0,),
                )
              ],),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 16.0,),
                Text(widget.description, style: TextStyle(fontSize: 16.0,)),
                SizedBox(height: 24.0),


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

                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             const Text(
                              'call',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  letterSpacing: 1.0,

                                ),
                              ),

                              SizedBox(width: MediaQuery.of(context).size.width/40),
                             const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                        ],

                       ),


                        onPressed: () {

                        //----------->> call functionality for review mechanism
                          /*launch('tel:+977 ${widget.store.contact}');*/
                          launch('tel:+977 ${9810129951}');
                        },
                      ),


                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),



                        child: const Text(
                          "confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 1.0
                          ),
                        ),

                        onPressed: () {
                          print("\n\n\n--------->> order is confirm resturant will receiver notificatin <<----------\n\n\n");
                          Navigator.pop(context);
                         },
                      ),
                    ],
                  ),
                ),

               /* Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Confirm"),
                  ),
                ),*/

              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 16.0,
            right: 16.0,
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}

