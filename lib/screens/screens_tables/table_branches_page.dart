import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TableBranches extends StatefulWidget {
  const TableBranches({super.key});

  @override
  State<TableBranches> createState() => _TableBranchesState();
}

class _TableBranchesState extends State<TableBranches> {
  late String token;

  SharedPreferences? prefs;
  bool isAdmin = false;

  Future<List<dynamic>> fetchBranches() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';
    isAdmin = prefs?.getBool('isAdmin') ?? false;
    final response = await http.get(
      Uri.parse('https://somar-jaber.serv00.net/api/branches'),
      headers: {
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      // Ensure that the returned data is a list of objects
      return List.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> deleteBranch(String id) async {
    final response = await http.delete(
      Uri.parse('https://somar-jaber.serv00.net/api/branches/id'
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

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          'Information About Branches',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchBranches(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SizedBox(
              width: double.infinity,
              child: DataTable(
                  sortColumnIndex: 1,
                  showCheckboxColumn: false,
                  // columnSpacing: 350,
                  border: TableBorder.all(
                    width: 1,
                  ),
                  columns: const <DataColumn>[
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
                      'Name',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                    DataColumn(
                        label: Text(
                      'Location',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                  ],
                  rows: snapshot.data!
                      .map(
                        (data) => DataRow(
                            selected: isSelected,
                            onSelectChanged: (x) {
                              if (isAdmin) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(data['name'] + ' Branch'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/edit_branches',
                                                        arguments: {
                                                          "id": data['_id'],
                                                          "name": data['name'],
                                                          "location":
                                                              data['location'],
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
                                                    '  Edit This Branch  ',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )),
                                              const SizedBox(height: 30),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    bool status =
                                                        await deleteBranch(data[
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
                                                    'Delete This Branch',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          ),
                                        ));
                              }
                            },
                            cells: [
                              DataCell(Text(
                                data['_id'].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(
                                data['name'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(
                                Text(
                                  data['location'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                      )
                      .toList()),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
