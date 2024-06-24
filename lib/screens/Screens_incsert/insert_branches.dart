import 'dart:convert';

import 'package:cars_app_new/screens/screens_tables/table_branches_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InsertBranches extends StatefulWidget {
  const InsertBranches({super.key});

  @override
  State<InsertBranches> createState() => _InsertBranchesState();
}

class _InsertBranchesState extends State<InsertBranches> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  late String token;

  SharedPreferences? prefs;

  Future<bool> insert() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('https://somar-jaber.serv00.net/api/branches'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode(<String, String>{
        'name': nameController.text,
        'location': locationController.text,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to insert branch');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0D47A1),
        title: const Text(
          'Insert Branch',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          hintText: 'Enter the branch name',
                          border: InputBorder.none),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
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
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the location',
                        border: InputBorder.none,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a location';
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
                              return const TableBranches();
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
