import 'dart:convert';

import 'package:cars_app_new/screens/screens_tables/table_cars_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens_tables/table_emp_page.dart';

class InsertEmployee extends StatefulWidget {
  const InsertEmployee({super.key});

  @override
  State<InsertEmployee> createState() => _InsertCarsState();
}

class _InsertCarsState extends State<InsertEmployee> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController hireDateController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  late String token;
  String branch = '';
  String dropDownValue = '';
  bool isLoading = false;
  late List branches = [];

  SharedPreferences? prefs;

  Future<bool> insert() async {
    // print(branchController.text);
    final response = await http.post(
      Uri.parse('https://somar-jaber.serv00.net/api/workers'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'f_name': fNameController.text,
        'l_name': lNameController.text,
        'birthdate': birthdateController.text,
        'hiredate': hireDateController.text,
        'role': roleController.text,
        'salary': double.parse(salaryController.text),
        'phone': [phoneController.text],
        'branch': branchController.text
      }),
    );
    // print(response.body);
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
    if (prefs!.containsKey('branchId')) {
      setState(() {
        branch = prefs!.getString('branch') ?? '';
        branchController.text = prefs!.getString('branchId') ?? '';
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
          dropDownValue = branches[0]['_id'];
          branchController.text = branches[0]['_id'];
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
    lNameController.dispose();
    fNameController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    hireDateController.dispose();
    roleController.dispose();
    salaryController.dispose();
    branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0D47A1),
        title: const Text(
          'Insert Employee',
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
                      controller: fNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the First Name',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter First Name';
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
                      controller: lNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the Last Name',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Last Name';
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
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the phone',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone';
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
                      controller: birthdateController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the birthdate',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a birthdate';
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
                      controller: hireDateController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the hireDate',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a hireDate';
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
                      controller: roleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the  role',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a role';
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
                      controller: salaryController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the  salary',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a salary';
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
                                      value: items['_id'].toString(),
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
                                  initialValue: branch,
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
                              return const TableEmployees();
                            },
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Insert Employee'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
