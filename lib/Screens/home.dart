import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cable_record/Service/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var value = "-1";

  bool isPaid = false;
  bool isConnected = false;

  final GlobalKey<FormState> homeKey = GlobalKey<FormState>();

  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  Stream<QuerySnapshot> customersStream =
      FirebaseFirestore.instance.collection('Customers').snapshots();

  Database db = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Customer"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          db.addCustomer(
              "nandini", "145", "5668786", false, true, "11, ss street", "P1");
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: customersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          // bool isPaid;
          return Form(
            key: homeKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 40, 100, 40),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Search",
                                hintText: "Search...",
                                icon: Icon(Icons.search),
                                focusedBorder: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text("Search")),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 40, 80, 40),
                          child: DropdownButtonFormField(
                              value: value,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              items: const [
                                DropdownMenuItem(
                                  value: "-1",
                                  child: Text("All"),
                                ),
                                DropdownMenuItem(
                                  value: "1",
                                  child: Text("By Name"),
                                ),
                                DropdownMenuItem(
                                  value: "2",
                                  child: Text("By Box number"),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  value = val!;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                  DataTable(
                    border: TableBorder.all(
                      color: Colors.black,
                    ),
                    columns: const [
                      DataColumn(
                          label: Text('Name',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Setup box number',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Connection status',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Payment status',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                    ],
                    rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                      // print(snapshot.data!.docs.length);
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      isConnected = data['Connection'];
                      isPaid = data['Payment'];

                      return DataRow(cells: [
                        DataCell(
                          Text(
                            data['Name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(Text(data['BoxNumber'])),
                        DataCell(Switch(
                          onChanged: (val) {
                            setState(() {
                              isConnected = val;
                            });
                          },
                          value: isConnected,
                          activeColor: Colors.green,
                          activeTrackColor: Colors.greenAccent,
                        )),
                        DataCell(Switch(
                          onChanged: (val) {
                            setState(() {
                              isPaid = val;
                            });
                          },
                          value: isPaid,
                          activeColor: Colors.green,
                          activeTrackColor: Colors.greenAccent,
                        ))
                      ]);
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
