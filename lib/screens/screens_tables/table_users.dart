import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TableUsers extends StatefulWidget {
  const TableUsers({super.key});

  @override
  State<TableUsers> createState() => _TableUsersState();
}

class _TableUsersState extends State<TableUsers> {
  late String token;

  SharedPreferences? prefs;

  Future<List<dynamic>> fetchUsers() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('https://somar-jaber.serv00.net/api/users'),
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

  Future<bool> deleteUsers(String id) async {
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
          'Information About Cars',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 20,
        backgroundColor: Color(0xff0D47A1),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
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
                  border: TableBorder.all(width: 1),
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
                      'WorKerId',
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
                      'Email',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                  ],
                  rows: snapshot.data!
                      .map((user) => DataRow(
                              onSelectChanged: (x) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title:
                                              Text('Name:   ${user['name']}'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, '/edit_user',
                                                        arguments: {
                                                          'id': user['_id'],
                                                          'name': user['name'],
                                                          'email':
                                                              user['email'],
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
                                                    'Edit This Users Information',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )),
                                              const SizedBox(height: 30),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    bool status =
                                                        await deleteUsers(user[
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
                                                    '        Delete This Car        ',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          ),
                                        ));
                              },
                              cells: [
                                DataCell(Text(
                                  user['_id'].toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text(
                                  user['workerId'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataCell(
                                  Text(
                                    user['name'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    user['email'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]))
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
