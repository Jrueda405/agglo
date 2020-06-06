import 'package:agglo/model/Store.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static DatabaseReference _databaseReference;

  static Future<void> instantiate() async {
    if (_databaseReference == null) {
      _databaseReference = FirebaseDatabase.instance.reference();
    }
  }

  static Stream<Store> listenForChanges() {
    final stream= _databaseReference.child('stores').onChildChanged.map((event) => Store.fromSnapshot(event.snapshot));
    return stream;
  }

  static Future<List<Store>> getStores() {
    List<Store> stores=List();
    return _databaseReference.child('stores').orderByChild('people').once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        stores.add(Store.fromJson(values));
      });
      return stores;
    } );
  }

}
