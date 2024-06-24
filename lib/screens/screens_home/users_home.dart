import 'package:cars_app_new/components/categore.dart';
import 'package:cars_app_new/screens/Screens_incsert/insert_users.dart';
import 'package:cars_app_new/screens/screens_tables/table_users.dart';
import 'package:flutter/material.dart';

class UsersHomePage extends StatelessWidget {
  const UsersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Color(0xff0D47A1),
        title: const Text('Users'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            Categoer(
              text: 'Table Users',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const TableUsers();
                    },
                  ),
                );
              },
            ),
            Categoer(
              text: 'Insert New User',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const InsertUsers();
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
