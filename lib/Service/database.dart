import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Database();

  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  Future<void> addCustomer(String name, String bnum, String pnum,
      bool connection, bool payment, String address, String package) {
    return customers
        .add({
          'Name': name,
          'Connection': connection,
          'Payment': payment,
          'BoxNumber': bnum,
          'PhoneNumber': pnum,
          'Address': address,
          'Package': package,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
