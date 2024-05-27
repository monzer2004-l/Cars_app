import 'dart:convert';

import 'package:cars_app_new/screens/screens_tables/table_cars_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InsertCars extends StatefulWidget {
  const InsertCars({super.key});

  @override
  State<InsertCars> createState() => _InsertCarsState();
}

class _InsertCarsState extends State<InsertCars> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numberCarController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController visitTimeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  late String token;
  String branch = '';
  String dropDownValue = '';
  bool isLoading = false;
  late List branches = [];

  SharedPreferences? prefs;

  Future<bool> insert() async {
    final response = await http.post(
      Uri.parse('https://somar-jaber.serv00.net/api/cars'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'number': numberCarController.text,
        'model': modelController.text,
        'owner_phone': [ownerPhoneController.text],
        'color': colorController.text,
        'visit_times': visitTimeController.text,
        'branches': [branchController.text],
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to insert branch');
    }
  }

  Future<void> fetchBranches() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';
    if (prefs!.containsKey('branch')) {
      setState(() {
        branch = prefs!.getString('branch') ?? '';
        branchController.text = branch;
      });
    } else {
      final response = await http.get(
        Uri.parse('https://somar-jaber.serv00.net/api/branches'),
        headers: {
          'x-auth-token': token,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          branches = List.from(json.decode(response.body));
          dropDownValue = branches[0]['name'];
          branchController.text = dropDownValue;
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchBranches();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    numberCarController.dispose();
    modelController.dispose();
    ownerPhoneController.dispose();
    colorController.dispose();
    visitTimeController.dispose();
    branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.blue,
                Colors.green
              ], // استخدم الألوان التي تختارها
            ),
          ),
        ),
        title: const Text(
          'Insert Car',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: numberCarController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the  Number car',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Number car';
                        }
                        if (value.length != 4 && value.length != 6) {
                          return 'Please enter a Number car with length 4 or 6';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the Model',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Model';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: ownerPhoneController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the owner phone',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a owner phone';
                        }
                        if (value.length < 10 || value.length > 10) {
                          return 'Please enter a valid phone with length 10';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: colorController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the color',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a color';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: visitTimeController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the visit times',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a visit times';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const LinearProgressIndicator()
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 223, 223),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: branch.isEmpty
                              ? DropdownButton(
                                  // Initial Value
                                  value: dropDownValue,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: branches.map((items) {
                                    return DropdownMenuItem(
                                      value: items['name'].toString(),
                                      child: Text(items['name'].toString()),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropDownValue = newValue!;
                                      branchController.text = dropDownValue;
                                    });
                                  },
                                )
                              : TextFormField(
                                  readOnly: true,
                                  controller: branchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter the  Branch',
                                    border: InputBorder.none,
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a Branch';
                                    }
                                    return null;
                                  },
                                ),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white; // لون النص عند الضغط
                        }
                        return Colors.white; // لون النص في حالة عدم الضغط
                      },
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red), // لون الخلفية
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                          // لون الزر عند الضغط باستخدام MaterialAccentColor
                        }
                        return Colors.blue;
                      },
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bool status = await insert() == true ? true : false;
                      if (status) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const TableCars();
                            },
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Insert Car'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
