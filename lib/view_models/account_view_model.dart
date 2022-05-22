import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub_collection/models/accounts.dart';



class AccountViewModel
{
  final Account store;
  AccountViewModel({this.store});


  String get uid{
    return store.uid;
  }

  String get email{
    return store.email;
  }

  String get firstName{
    return store.uid;
  }

  String get secondName{
    return store.secondName;
  }








  //----------------------------->> Singleton Factory Function <<-----------------
  factory AccountViewModel.fromSnapshot(QueryDocumentSnapshot doc){
    final store= Account.fromSnapshot(doc);
    return AccountViewModel(store: store);

  }
}