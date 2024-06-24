import 'package:cars_app_new/components/categore.dart';
import 'package:cars_app_new/screens/Screens_incsert/insert_branches.dart';
import 'package:cars_app_new/screens/screens_tables/table_branches_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchesHomePage extends StatefulWidget {
  const BranchesHomePage({super.key});

  @override
  State<BranchesHomePage> createState() => _BranchesHomePageState();
}

class _BranchesHomePageState extends State<BranchesHomePage> {
  late String token;
  bool isAdmin = false;

  SharedPreferences? prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs?.getBool('isAdmin') ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Color(0xff0D47A1),
        title: const Text('Branches'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            Categoer(
              text: 'Table Branches',
              color: Colors.white,
              OnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const TableBranches();
                    },
                  ),
                );
              },
            ),
            if (isAdmin)
              Categoer(
                text: 'Insert New Branch',
                color: Colors.white,
                OnTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const InsertBranches();
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
