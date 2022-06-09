import 'package:firebase_sub_collection/provider/homeCategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RecentOrders extends StatelessWidget {
  MyProvider myProvider;

  _buildRecentOrder(context, {String name, String image}) {
    return Container(

      margin: EdgeInsets.only(left: 5.0, right: 10.0, top: 10.0, bottom: 10.0),
      width: 250.0,
      decoration: BoxDecoration(
        color: Colors.green,
        //color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 1.0,
          color: Colors.grey[200],
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
                    //color: Colors.blueGrey,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow,
                    margin: EdgeInsets.all(12.0),
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
                          "Nov 10, 2019",
                          style: TextStyle(
                            fontSize: 16.0,
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



  @override
  Widget build(BuildContext context) {
    myProvider= Provider.of<MyProvider>(context);
    myProvider.getCategoryProduct();

    return Column(
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
        Container(
          height: 120.0,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            //padding: EdgeInsets.only(left: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: myProvider.getCategoryModelList.length,


            itemBuilder: (BuildContext context, int index) {
             /* Order order = currentUser.orders[index]; */
              return _buildRecentOrder(context,
                name: myProvider.getCategoryModelList[index].name,
                image: myProvider.getCategoryModelList[index].image,

              );
            },
          ),
        ),
      ],
    );
  }
}
