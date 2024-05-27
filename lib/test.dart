import 'package:flutter/material.dart';

class DataFilteringExample extends StatefulWidget {
  @override
  _DataFilteringExampleState createState() => _DataFilteringExampleState();
}

class _DataFilteringExampleState extends State<DataFilteringExample> {
  List<String> originalData = [
    'Apple',
    'Banana',
    'Cherry',
    'Durian',
    'Elderberry'
  ];
  List<String> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData.addAll(originalData);
  }

  void filterData(String query) {
    setState(() {
      filteredData = originalData
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Filtering Example'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) => filterData(value),
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredData[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
