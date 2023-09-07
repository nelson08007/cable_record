import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String value = "By Name";

  final GlobalKey<FormState> homeKey = GlobalKey<FormState>();

  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  final Stream<QuerySnapshot> _customersStream =
      FirebaseFirestore.instance.collection('Customers').snapshots();
  Future<void> addCustomer() {
    // Call the user's CollectionReference to add a new user
    return customers
        .add({
          'Name': 'Nelson',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _customersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['Name']),
              );
            }).toList(),
          );
        },
      ),
    );

    // Scaffold(
    //   body: Form(
    //     key: homeKey,
    //     child: Column(
    //       children: [
    //         Row(
    //           children: [
    //             Expanded(
    //               child: Padding(
    //                 padding: const EdgeInsets.fromLTRB(50, 40, 100, 40),
    //                 child: TextFormField(
    //                   decoration: const InputDecoration(
    //                       labelText: "Search",
    //                       hintText: "Search...",
    //                       icon: Icon(Icons.search),
    //                       focusedBorder: OutlineInputBorder()),
    //                 ),
    //               ),
    //             ),
    //             ElevatedButton(onPressed: () {}, child: const Text("Search")),
    //             Expanded(
    //               child: Padding(
    //                 padding: const EdgeInsets.fromLTRB(30, 40, 80, 40),
    //                 child: DropdownButtonFormField(
    //                     decoration:
    //                         const InputDecoration(border: OutlineInputBorder()),
    //                     items: const [
    //                       DropdownMenuItem(
    //                         value: "-1",
    //                         child: const Text("By Name"),
    //                       ),
    //                       DropdownMenuItem(
    //                         value: "1",
    //                         child: Text("By Box number"),
    //                       ),
    //                     ],
    //                     onChanged: (val) {
    //                       setState(() {
    //                         value = val!;
    //                       });
    //                     }),
    //               ),
    //             )
    //           ],
    //         ),
    //         const SizedBox(height: 20.0),
    //         ElevatedButton(
    //             onPressed: addCustomer, child: const Text("Add customer")),
    //         const SizedBox(height: 20.0),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text("Back")),
    //       ],
    //     ),
    //   ),
    // );
  }
}
