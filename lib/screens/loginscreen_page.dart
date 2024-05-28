import 'dart:convert';

import 'package:cars_app_new/screens/screens_home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  late SharedPreferences prefs;
  bool isLoading = false;

  Future<bool> login() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
        Uri.parse('https://somar-jaber.serv00.net/api/auth'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({"email": email.text, "password": password.text}));
    if (response.statusCode == 200) {
      prefs.setString('token', response.body);
      await isAdminOrUser(response.body);
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  isAdminOrUser(String token) async {
    final response = await http.get(
      Uri.parse('https://somar-jaber.serv00.net/api/users/me'),
      headers: {
        'x-auth-token': token,
      },
    );
    if (response.statusCode == 200) {
      // اذا ماكان ادمن منحتفظ باسم الفرع و id الفرع
      if (!json.decode(response.body)['isAdmin']) {
        prefs.setString(
            'branch', json.decode(response.body)['workerId']['branch']['name']);
        prefs.setString('branchId',
            json.decode(response.body)['workerId']['branch']['_id']);
      }

      prefs.setBool('isAdmin', json.decode(response.body)['isAdmin']);
    } else {
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Center(
          child: Form(
            child: Container(
              width: 800,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 141,
                    backgroundColor: Color(0xff0D47A1),
                    child: CircleAvatar(
                      radius: 135,
                      backgroundImage: AssetImage('images/Car.jpg'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'SIGN IN',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 208, 205, 205),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) => !input!.contains("@")
                              ? "Email id should be valid"
                              : null,
                          controller: email,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email@gmail.com',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 208, 205, 205),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          validator: (input) => input!.length < 3
                              ? "Password should be more than 3 characters"
                              : null,
                          controller: password,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility_outlined),
                                color: Colors.blue[900],
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextButton(
                            onPressed: () async {
                              bool status = await login();
                              if (status) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const HomePage();
                                    },
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                      title: Text(
                                        'Failed log in ',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Text('Wrong password or email')),
                                );
                              }
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue[900],
                              ),
                              child: const Center(
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
