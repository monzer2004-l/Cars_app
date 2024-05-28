import 'package:cars_app_new/components/categore.dart';
import 'package:cars_app_new/screens/screens_home/branches_home_page.dart';
import 'package:cars_app_new/screens/screens_home/cars_home_page.dart';
import 'package:cars_app_new/screens/loginscreen_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'emp_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 225, 225),
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Color(0xff0D47A1),
        title: const Text(
          'Fix Cars',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.yellow,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            Categoer(
              text: 'Cars',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const CarsHomePage();
                    },
                  ),
                );
              },
            ),
            Categoer(
              text: 'Employees',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const EmployeeHomePage();
                    },
                  ),
                );
              },
            ),
            Categoer(
              text: 'Branches',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const BranchesHomePage();
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
