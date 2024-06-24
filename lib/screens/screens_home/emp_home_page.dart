import 'package:cars_app_new/components/categore.dart';
import 'package:cars_app_new/screens/screens_tables/table_emp_page.dart';
import 'package:flutter/material.dart';

import '../Screens_incsert/insert_emp.dart';

class EmployeeHomePage extends StatelessWidget {
  const EmployeeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Color(0xff0D47A1),
        title: const Text('Employees'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            Categoer(
              text: 'Table Employees',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const TableEmployees();
                    },
                  ),
                );
              },
            ),
            Categoer(
              text: 'Insert New Employee',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const InsertEmployee();
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
