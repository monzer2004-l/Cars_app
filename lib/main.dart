import 'package:cars_app_new/screens/Screens_incsert/edit_branches.dart';
import 'package:cars_app_new/screens/Screens_incsert/edit_cars.dart';
import 'package:cars_app_new/screens/Screens_incsert/edit_emp.dart';
import 'package:cars_app_new/screens/loginscreen_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/edit_branches': (context) => const EditBranches(),
          '/edit_car': (context) => const EditCars(),
          '/edit_employee': (context) => const EditEmployee(),
        },
        //Branches_page()
      );
}
