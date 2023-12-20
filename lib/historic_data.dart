import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Monitor App',
      home: historic_data(),
    );
  }
}

class historic_data extends StatefulWidget {
  @override
  _historic_dataState createState() => _historic_dataState();
}

class _historic_dataState extends State<historic_data> {
  late Future<List<Map<String, dynamic>>> futureData;
  int currentPage = 1;
  int recordsPerPage = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    futureData = fetchData(currentPage, recordsPerPage);
    _startTimer();
  }

  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    // Fetch data every 5 seconds (adjust the duration as needed)
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      fetchData(currentPage, recordsPerPage);
    });
  }

  Future<List<Map<String, dynamic>>> fetchData(int page, int limit) async {
    final response = await http.get(
        Uri.parse('https://energymonitor.vercel.app/api/getdata?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void loadNextPage() {
    setState(() {
      currentPage++;
      futureData = fetchData(currentPage, recordsPerPage);
    });
  }

  void loadPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        futureData = fetchData(currentPage, recordsPerPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>>? dataList = snapshot.data;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: Colors.red),
                columns: [
                  DataColumn(label: Text('Voltage (V)')),
                  DataColumn(label: Text('Current (A)')),
                  DataColumn(label: Text('Power (W)')),
                  DataColumn(label: Text('Energy (kWh)')),
                  DataColumn(label: Text('Time')),
                ],
                rows: dataList?.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> data = entry.value;
                  Color backgroundColor = index % 2 == 0 ? Colors.white : Colors.purple.shade50;

                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return backgroundColor;
                      },
                    ),
                    cells: [
                      DataCell(
                        Text('${data['voltage']}'),
                        onLongPress: () {
                          showDialog(context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(child: Text('${data['voltage']}')),

                              );
                            },);
                        },
                      ),
                      DataCell(
                        Text('${data['current']}'),
                        onLongPress: () {
                          showDialog(context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(child: Text('${data['current']}')),
                              );
                            },);
                        },
                      ),
                      DataCell(
                        Text('${data['power']}'),
                        onLongPress: () {
                          showDialog(context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(child: Text('${data['power']}')),
                              );
                            },);
                        },
                      ),
                      DataCell(
                        Text('${data['energy']}'),
                        onLongPress: () {
                          showDialog(context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Center(child: Text('${data['energy']}')),
                                );
                              },);
                        },
                      ),
                      DataCell(
                        Text('${data['time']}'),
                        onLongPress: () {
                          showDialog(context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(child: Text('${data['time']}')),
                              );
                            },);
                        },
                        // Customize the appearance of the cell if needed
                      ),
                    ],
                  );
                }).toList() ?? [],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: loadPreviousPage,
            ),
            Text('Page $currentPage'),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: loadNextPage,
            ),
          ],
        ),
      ),
    );
  }
}
