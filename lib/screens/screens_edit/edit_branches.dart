import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditBranches extends StatefulWidget {
  const EditBranches({super.key});

  @override
  State<EditBranches> createState() => _EditBranchesState();
}

class _EditBranchesState extends State<EditBranches> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  late String token;
  String id = '';

  SharedPreferences? prefs;

  Future<bool> edit() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';

    final response = await http.put(
      Uri.parse('https://somar-jaber.serv00.net/api/branches/id'
          .replaceFirst('id', id)),
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
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    if (id.isEmpty) id = arguments['id'].toString();
    if (nameController.text.isEmpty) {
      nameController.text = arguments['name'].toString();
    }
    if (locationController.text.isEmpty) {
      locationController.text = arguments['location'].toString();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0D47A1),
        title: const Text('Edit Branch'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the new branch name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the new location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bool status = await edit() == true ? true : false;
                      if (status) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: const Text('Edit Branch'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
