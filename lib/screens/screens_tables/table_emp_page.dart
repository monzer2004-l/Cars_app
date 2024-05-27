import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TableEmployees extends StatefulWidget {
  const TableEmployees({super.key});

  @override
  State<TableEmployees> createState() => _TableEmployeesState();
}

class _TableEmployeesState extends State<TableEmployees> {
  late String token;
  SharedPreferences? prefs;

  Future<List<dynamic>> fetchEmployee() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('https://somar-jaber.serv00.net/api/workers'),
      headers: {
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      // Ensure that the returned data is a list of objects
      return List.from(json.decode(response.body));
    } else {
      // Handle API request failure (e.g., show an error message)
      throw Exception('Failed to load data');
    }
  }

  Future<bool> deleteEmployee(String id) async {
    final response = await http.delete(
      Uri.parse('https://somar-jaber.serv00.net/api/workers/id'
          .replaceFirst('id', id)),
      headers: {
        'x-auth-token': token,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Information About Workers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
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
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchEmployee(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: 1,
                      showCheckboxColumn: false,
                      border: TableBorder.all(width: 1),
                      //columnSpacing: 2,
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Id',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'First Name',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Last Name',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Birthday',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Hiredate',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Role',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Salary',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Phones',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                        DataColumn(
                            label: Text(
                          'Branch',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                      ],
                      rows: snapshot.data!
                          .map(
                            (emp) => DataRow(
                                onSelectChanged: (x) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(
                                                '${emp['name']} ${emp['l_name']}'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/edit_employee',
                                                          arguments: {
                                                            'id': emp['_id'],
                                                            'f_name':
                                                                emp['f_name'],
                                                            'l_name':
                                                                emp['l_name'],
                                                            'birthdate': emp[
                                                                'birthdate'],
                                                            'hiredate':
                                                                emp['hiredate'],
                                                            'role': emp['role'],
                                                            'salary':
                                                                emp['salary'],
                                                            'phone':
                                                                emp['phone'][0],
                                                            'branch': emp[
                                                                        'branch'] ==
                                                                    null
                                                                ? ""
                                                                : emp['branch']
                                                                        ['name']
                                                                    .toString()
                                                          }).then((value) {
                                                        if (value == true) {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          setState(() {});
                                                        } else {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Edit This Employee\' Data',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )),
                                                const SizedBox(height: 30),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      bool status =
                                                          await deleteEmployee(emp[
                                                                          '_id']
                                                                      .toString()) ==
                                                                  true
                                                              ? true
                                                              : false;
                                                      if (status) {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: const Text(
                                                      '   Delete This Employee   ',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ))
                                              ],
                                            ),
                                          ));
                                },
                                cells: [
                                  DataCell(Text(
                                    emp['_id'].toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    emp['f_name'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(
                                    Text(
                                      emp['l_name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      emp['birthdate'].toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      emp['hiredate'].toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      emp['role'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      emp['salary'].toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      emp['phone'].toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      emp['branch'] == null
                                          ? ""
                                          : emp['branch']['name'].toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                          )
                          .toList(),
                    ),
                  )),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
