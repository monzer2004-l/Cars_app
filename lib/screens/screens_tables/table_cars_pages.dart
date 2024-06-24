import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TableCars extends StatefulWidget {
  const TableCars({super.key});

  @override
  State<TableCars> createState() => _TableCarsState();
}

class _TableCarsState extends State<TableCars> {
  late String token;

  SharedPreferences? prefs;

  Future<List<dynamic>> fetchCars() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs?.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('https://somar-jaber.serv00.net/api/cars'),
      headers: {
        'x-auth-token': token,
      },
    );
    if (response.statusCode == 200) {
      return List.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> deleteCar(String id) async {
    final response = await http.delete(
      Uri.parse(
          'https://somar-jaber.serv00.net/api/cars/id'.replaceFirst('id', id)),
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
        future: fetchCars(),
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
                      'Model',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                    DataColumn(
                        label: Text(
                      'Number Car',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                    DataColumn(
                        label: Text(
                      'Color',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                    DataColumn(
                        label: Text(
                      'Branches',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                  ],
                  rows: snapshot.data!
                      .map((car) => DataRow(
                              onSelectChanged: (x) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(
                                              'Car model:   ${car['model']}'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, '/edit_car',
                                                        arguments: {
                                                          'id': car['_id'],
                                                          'number':
                                                              car['number'],
                                                          'model': car['model'],
                                                          'owner_phone':
                                                              car['owner_phone']
                                                                  [0],
                                                          'color': car['color'],
                                                          'visit_times':
                                                              car['visit_times']
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
                                                    'Edit This Car Information',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )),
                                              const SizedBox(height: 30),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    bool status =
                                                        await deleteCar(car[
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
                                  car['_id'].toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text(
                                  car['model'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataCell(
                                  Text(
                                    car['number'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    car['color'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    car['branches'][0]['name'],
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
