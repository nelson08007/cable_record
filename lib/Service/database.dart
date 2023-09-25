import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cable_record/model/customer.dart';

class Database {
  Database();

  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  Future<void> createCustomer(Customer customer) {
    return customers
        .add({
          'Name': customer.name,
          'Connection': customer.isconnected,
          'Payment': customer.ispaid,
          'BoxNumber': customer.boxnumber,
          'PhoneNumber': customer.phonenumber,
          'Address': customer.address,
          'Package': customer.package,
          'ConnectAt': customer.date,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateCustomer(Customer customer, String id) {
    return customers
        .doc(id)
        .update({
          'Name': customer.name,
          'Connection': customer.isconnected,
          'Payment': customer.ispaid,
          'BoxNumber': customer.boxnumber,
          'PhoneNumber': customer.phonenumber,
          'Address': customer.address,
          'Package': customer.package,
          'ConnectAt': customer.date,
        })
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
