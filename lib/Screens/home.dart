import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cable_record/Service/database.dart';
import 'package:cable_record/model/customer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var value = "-1";

  bool isConnected = false;
  bool isPaid = false;
  Customer customer = Customer();

  final GlobalKey<FormState> homeKey = GlobalKey<FormState>();

  final GlobalKey<FormState> customerKey = GlobalKey<FormState>();

  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  Stream<QuerySnapshot> customersStream =
      FirebaseFirestore.instance.collection('Customers').snapshots();

  Database db = Database();

  DateTime selectedDate = DateTime.now();

  TextEditingController _datecontrol = TextEditingController();

  TextEditingController _dateupdate = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _datecontrol.text = _picked.toString().split(" ")[0];
        customer.date = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _updateDate(String date) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateupdate.text = _picked.toString().split(" ")[0];
        custUpdate.date = _picked.toString().split(" ")[0];
      });
    } else {
      custUpdate.date = date;
    }
  }

  Customer custUpdate = Customer();

  void updateBox(Customer cust, String id) {
    _dateupdate.text = cust.date!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Update Customer Details"),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: 600,
            child: Form(
              key: customerKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: cust.name,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter name";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        custUpdate.name = val;
                      });
                    },
                    decoration: const InputDecoration(
                        label: Text("Name"), hintText: "Enter customer name"),
                  ),
                  TextFormField(
                    initialValue: cust.boxnumber,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "enter box number";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        custUpdate.boxnumber = val;
                      });
                    },
                    decoration: InputDecoration(
                        label: Text(cust.boxnumber!),
                        hintText: "Enter box Number"),
                  ),
                  TextFormField(
                    initialValue: cust.phonenumber,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Phone number";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        custUpdate.phonenumber = val;
                      });
                    },
                    decoration: InputDecoration(
                        label: Text(cust.phonenumber!),
                        hintText: "Enter phone number"),
                  ),
                  TextFormField(
                    initialValue: cust.package,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "enter package";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        custUpdate.package = val;
                      });
                    },
                    decoration: InputDecoration(
                        label: Text(cust.package!), hintText: "Enter package"),
                  ),
                  TextFormField(
                    initialValue: cust.address,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "enter address";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        custUpdate.address = val;
                      });
                    },
                    decoration: InputDecoration(
                        label: Text(cust.address!), hintText: "Enter Address"),
                  ),
                  Row(
                    children: [
                      const Text("Connection Status : "),
                      Switch(
                        onChanged: (val) {
                          setState(() {
                            custUpdate.isconnected = val;
                          });
                        },
                        value: cust.isconnected,
                        activeColor: Colors.green,
                        activeTrackColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                  TextFormField(
                    //initialValue: cust.date,
                    // validator: (val) {
                    //   if (val!.isEmpty) {
                    //     return "Select date";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _dateupdate,
                    decoration: const InputDecoration(
                      //labelText: cust.date,
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () {
                      _updateDate(cust.date!);
                    },
                  ),
                  Row(
                    children: [
                      const Text("Payment Status : "),
                      Switch(
                        onChanged: (val) {
                          setState(() {
                            custUpdate.ispaid = val;
                          });
                        },
                        value: cust.ispaid,
                        activeColor: Colors.green,
                        activeTrackColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            onPressed: () {
              if (customerKey.currentState!.validate()) {
                db.updateCustomer(custUpdate, id);
                Navigator.of(ctx).pop();
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Customer"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          // db.addCustomer( "nandini", "145", "5668786", false, true, "11, ss street", "P1");
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Enter Customer Details"),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 600,
                  child: Form(
                    key: customerKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter name";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              customer.name = val;
                            });
                          },
                          decoration: const InputDecoration(
                              label: Text("Name"),
                              hintText: "Enter customer name"),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter box number";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              customer.boxnumber = val;
                            });
                          },
                          decoration: const InputDecoration(
                              label: Text("Box Number"),
                              hintText: "Enter box Number"),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Phone number";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              customer.phonenumber = val;
                            });
                          },
                          decoration: const InputDecoration(
                              label: Text("Phone Number"),
                              hintText: "Enter phone number"),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter package";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              customer.package = val;
                            });
                          },
                          decoration: const InputDecoration(
                              label: Text("Package"),
                              hintText: "Enter package"),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter address";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              customer.address = val;
                            });
                          },
                          decoration: const InputDecoration(
                              label: Text("Address"),
                              hintText: "Enter Address"),
                        ),
                        Row(
                          children: [
                            const Text("Connection Status : "),
                            Switch(
                              onChanged: (val) {
                                setState(() {
                                  customer.isconnected = val;
                                });
                              },
                              value: customer.isconnected,
                              activeColor: Colors.green,
                              activeTrackColor: Colors.greenAccent,
                            ),
                          ],
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Select date";
                            } else {
                              return null;
                            }
                          },
                          controller: _datecontrol,
                          decoration: const InputDecoration(
                            labelText: 'Connection Date',
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                        ),
                        Row(
                          children: [
                            const Text("Payment Status : "),
                            Switch(
                              onChanged: (val) {
                                setState(() {
                                  customer.ispaid = val;
                                });
                              },
                              value: customer.ispaid,
                              activeColor: Colors.green,
                              activeTrackColor: Colors.greenAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    if (customerKey.currentState!.validate()) {
                      db.createCustomer(customer);
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          );
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
                          label: Text('Address',
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
                          onDoubleTap: () {
                            custUpdate.name = data['Name'];
                            custUpdate.boxnumber = data['BoxNumber'];
                            custUpdate.address = data['Address'];
                            custUpdate.date = data['ConnectAt'];
                            custUpdate.isconnected = data['Connection'];
                            custUpdate.ispaid = data['Payment'];
                            custUpdate.package = data['Package'];
                            custUpdate.phonenumber = data['PhoneNumber'];

                            updateBox(custUpdate, document.id);
                          },
                          Text(
                            data['Name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          updateBox(custUpdate, document.id);
                        }, Text(data['BoxNumber'])),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          updateBox(custUpdate, document.id);
                        }, Text(data['Address'] ?? "not found")),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          updateBox(custUpdate, document.id);
                        },
                            Switch(
                              onChanged: (val) {
                                setState(() {
                                  isConnected = val;
                                });
                              },
                              value: isConnected,
                              activeColor: Colors.green,
                              activeTrackColor: Colors.greenAccent,
                            )),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          updateBox(custUpdate, document.id);
                        },
                            Switch(
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
