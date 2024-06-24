import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditCars extends StatefulWidget {
  const EditCars({super.key});

  @override
  State<EditCars> createState() => _InsertCarsState();
}

class _InsertCarsState extends State<EditCars> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numberCarController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController visitTimeController = TextEditingController();

  late String token;
  late String id = '';

  SharedPreferences? prefs;

  Future<bool> edit() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';

    final response = await http.put(
      Uri.parse(
          'https://somar-jaber.serv00.net/api/cars/id'.replaceFirst('id', id)),
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
    numberCarController.dispose();
    modelController.dispose();
    ownerPhoneController.dispose();
    colorController.dispose();
    visitTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    if (id.isEmpty) id = arguments['id'].toString();
    if (numberCarController.text.isEmpty) {
      numberCarController.text = arguments['number'].toString();
    }
    if (modelController.text.isEmpty) {
      modelController.text = arguments['model'].toString();
    }
    if (ownerPhoneController.text.isEmpty) {
      ownerPhoneController.text = arguments['owner_phone'].toString();
    }
    if (colorController.text.isEmpty) {
      colorController.text = arguments['color'].toString();
    }
    if (visitTimeController.text.isEmpty) {
      visitTimeController.text = arguments['visit_times'].toString();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0D47A1),
        title: const Text(
          'Edit Car',
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
                        if (value.length != 6 && value.length != 4) {
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
                      bool status = await edit() == true ? true : false;
                      if (status) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: const Text('Edit Car'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
