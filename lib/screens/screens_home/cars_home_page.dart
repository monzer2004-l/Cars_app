import 'package:cars_app_new/components/categore.dart';
import 'package:cars_app_new/screens/Screens_incsert/insert_cars.dart';
import 'package:cars_app_new/screens/screens_tables/table_cars_pages.dart';
import 'package:flutter/material.dart';

class CarsHomePage extends StatelessWidget {
  const CarsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
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
        title: const Text('Cars'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            Categoer(
              text: 'Table Cars',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const TableCars();
                    },
                  ),
                );
              },
            ),
            Categoer(
              text: 'Insert New Car',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const InsertCars();
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
