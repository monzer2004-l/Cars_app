import 'dart:convert';

import 'package:cars_app_new/screens/screens_tables/table_cars_pages.dart';
import 'package:cars_app_new/screens/screens_tables/table_users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController isadminController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  late String token;
  String branch = '';
  String dropDownValue = '';
  bool isLoading = false;
  late List branches = [];

  SharedPreferences? prefs;

  Future<bool> insert() async {
    final response = await http.post(
      Uri.parse('https://somar-jaber.serv00.net/api/users/id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    if (nameController.text.isEmpty) {
      nameController.text = arguments['name'].toString();
    }

    if (passwordController.text.isEmpty) {
      passwordController.text = arguments['password'].toString();
    }

    if (emailController.text.isEmpty) {
      emailController.text = arguments['email'].toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0D47A1),
        title: const Text(
          'Edit User',
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
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the  Name',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Name';
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the  Password',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Password';
                        }
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
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the Email',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Email';
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
                              return const TableUsers();
                            },
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Edit User'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
