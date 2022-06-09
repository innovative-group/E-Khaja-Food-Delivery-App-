
import 'package:flutter/material.dart';

class SingleMenuItem extends StatefulWidget {

  final storeItem;
  const SingleMenuItem({Key key, this.storeItem}) : super(key: key);

  @override
  State<SingleMenuItem> createState() => _SingleMenuItemState();
}

class _SingleMenuItemState extends State<SingleMenuItem> {



  int addCartClicked= 0;

  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage(widget.storeItem.foodImage),
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
                    widget.storeItem.foodName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Rs ${widget.storeItem.price}',
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

              child: GestureDetector(
                onTap:(){

                  if(addCartClicked== 0){
                    setState((){
                      print("\n\n\n----------->> addCartClicked <<---[true part] ----- $addCartClicked ");
                      addCartClicked= 1;
                      print("----------->> addCartClicked <<---[true part] ----- $addCartClicked \n\n\n");
                    });
                  }else {
                    setState((){
                      addCartClicked= 0;
                      print("\n\n\n----------->> addCartClicked <<---[true part] ----- $addCartClicked \n\n\n");
                    });
                  }
                },
                child: Container(

                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(child: addCartClicked== 0 ?  Image.asset("assets/icons/addCartWhite.png") : Image.asset("assets/icons/addCartBlack.png"),
                  ),
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
