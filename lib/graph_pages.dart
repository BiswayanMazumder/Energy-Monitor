import 'package:energy_monitor/historic_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<Map<String, dynamic>> dataList = [];
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    fetchData();
    _startTimer();
  }
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    // Fetch data every 5 seconds (adjust the duration as needed)
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      fetchData();
    });
  }
  Future<void> fetchData() async {
    try {
      final response =
      await http.get(Uri.parse('https://energymonitor.vercel.app/api/getdata'));
      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body);
        List<Map<String, dynamic>> newDataList = [];
        for (var data in rawData) {
          newDataList.add({
            'label': data['label'],
            'voltage': data['voltage'],
            'time': data['time'],
            'current':data['current'],
            'power':data['power'],
            'energy':data['energy']
          });
        }
        setState(() {
          dataList = newDataList;
        });
      } else {
        // Handle error
        print('Failed to fetch data');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
    }
  }
  bool showvoltage=true;
  bool showcurrent=true;
  bool showpower=true;
  bool showenergy=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Energy Graph',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 25),),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Voltage Data From Esp32',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.purple),
              ),
              SizedBox(height: 50),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return value.toString();
                        },
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        rotateAngle: -45,
                        interval: 1,
                        getTitles: (value) {
                          int index = value.toInt();
                          if (index >= 0 && index < dataList.length) {
                            return dataList[index]['time'];
                          }
                          return '';
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: dataList.length.toDouble() - 1,
                    minY: 219,
                    maxY: 225,
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          return FlSpot(index.toDouble(), parseDouble(data['voltage']));
                        }).toList(),
                        isCurved: false,
                        colors: [Colors.blue],
                        barWidth: 5,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Text(
                'Current Data From Esp32',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.purple),
              ),
              SizedBox(height: 50),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return value.toString();
                        },
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        rotateAngle: -45,
                        interval: 1,
                        getTitles: (value) {
                          int index = value.toInt();
                          if (index >= 0 && index < dataList.length) {
                            return dataList[index]['time'];
                          }
                          return '';
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: dataList.length.toDouble() - 1,
                    minY: 0,
                    maxY: 1.8,
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          print('Current Value at Index $index: ${data['current']}');
                          return FlSpot(index.toDouble(), parseDouble(data['current']));
                        }).toList(),

                        isCurved: false,
                        colors: [Colors.red],
                        barWidth: 5,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // LineChartBarData(
                      //   spots: dataList.asMap().entries.map((entry) {
                      //     final index = entry.key;
                      //     final data = entry.value;
                      //     return FlSpot(index.toDouble(), parseDouble(data['time']));
                      //   }).toList(),
                      //   isCurved: false,
                      //   colors: [Colors.blue],
                      //   barWidth: 5,
                      //   dotData: FlDotData(show: true),
                      //   belowBarData: BarAreaData(show: false),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Text(
                'Power Data From Esp32',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.purple),
              ),
              SizedBox(height: 50),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return value.toString();
                        },
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        rotateAngle: -45,
                        interval: 1,
                        getTitles: (value) {
                          int index = value.toInt();
                          if (index >= 0 && index < dataList.length) {
                            return dataList[index]['time'];
                          }
                          return '';
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: dataList.length.toDouble() - 1,
                    minY: 4.1,
                    maxY: 6.1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          print('Power Value at Index $index: ${data['power']}');
                          return FlSpot(index.toDouble(), parseDouble(data['power']));
                        }).toList(),

                        isCurved: false,
                        colors: [Colors.green],
                        barWidth: 5,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Text(
                'Unit Data From Esp32',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.purple),
              ),
              SizedBox(height: 50),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return value.toString();
                        },
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        rotateAngle: -45,
                        interval: 1,
                        getTitles: (value) {
                          int index = value.toInt();
                          if (index >= 0 && index < dataList.length) {
                            return dataList[index]['time'];
                          }
                          return '';
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: dataList.length.toDouble() - 1,
                    minY: 8,
                    maxY: 50,
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          print('energy Value at Index $index: ${data['energy']}');
                          return FlSpot(index.toDouble(), parseDouble(data['energy']));
                        }).toList(),

                        isCurved: false,
                        colors: [Colors.black],
                        barWidth: 5,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // LineChartBarData(
                      //   spots: dataList.asMap().entries.map((entry) {
                      //     final index = entry.key;
                      //     final data = entry.value;
                      //     return FlSpot(index.toDouble(), parseDouble(data['time']));
                      //   }).toList(),
                      //   isCurved: false,
                      //   colors: [Colors.blue],
                      //   barWidth: 5,
                      //   dotData: FlDotData(show: true),
                      //   belowBarData: BarAreaData(show: false),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Text(
                'Energy Data From Esp32',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.purple),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  TextButton(onPressed: (){
                    setState(() {
                      showvoltage=!showvoltage;
                    });
                  },
                      child:Text('🔵 Voltage',style: TextStyle(color: showvoltage?Colors.black:Colors.grey,fontWeight: FontWeight.bold),)),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      showcurrent=!showcurrent;
                    });
                  },
                      child:Text('⚫ Current',style: TextStyle(color: showcurrent?Colors.black:Colors.grey,fontWeight: FontWeight.bold))),
                  SizedBox(
                    width:5,
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      showpower=!showpower;
                    });
                  },
                      child:Text('🟢 Power',style: TextStyle(color: showpower?Colors.black:Colors.grey,fontWeight: FontWeight.bold))),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      showenergy=!showenergy;
                    });
                  },
                      child:Text('🔴 Energy',style: TextStyle(color: showenergy?Colors.black:Colors.grey,fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(height: 50),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return value.toString();
                        },
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        rotateAngle: -45,
                        interval: 1,
                        getTitles: (value) {
                          int index = value.toInt();
                          if (index >= 0 && index < dataList.length) {
                            return dataList[index]['time'];
                          }
                          return '';
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: dataList.length.toDouble() - 1,
                    minY: 0,
                    maxY: 250,
                    lineBarsData: [
                      if(showvoltage)
                        LineChartBarData(
                          spots: dataList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            return FlSpot(
                                index.toDouble(), parseDouble(data['voltage']));
                          }).toList(),
                          isCurved: false,
                          colors: [Colors.blue],
                          barWidth: 5,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),

                        ),
                      if(showenergy)
                        LineChartBarData(
                          spots: dataList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            return FlSpot(
                                index.toDouble(), parseDouble(data['current']));
                          }).toList(),
                          isCurved: false,
                          colors: [Colors.red],
                          barWidth: 5,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: true),

                        ),
                      if(showpower)
                        LineChartBarData(
                          spots: dataList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            return FlSpot(index.toDouble(), parseDouble(data['power']));
                          }).toList(),
                          isCurved: false,
                          colors: [Colors.green],
                          barWidth: 5,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),

                        ),
                     if(showcurrent)
                       LineChartBarData(
                         spots: dataList.asMap().entries.map((entry) {
                           final index = entry.key;
                           final data = entry.value;
                           return FlSpot(
                               index.toDouble(), parseDouble(data['energy']));
                         }).toList(),
                         isCurved: false,
                         colors: [Colors.black],
                         barWidth: 5,
                         dotData: FlDotData(show: false),
                         belowBarData: BarAreaData(show: false),

                       ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 180),
              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                      ),
                      child: ElevatedButton(onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder:(context) => historic_data()));
                      },
                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white),elevation: MaterialStatePropertyAll(0)),
                          child:Text('View History',style: GoogleFonts.amaranth(color: Colors.black,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  double parseDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is double) {
      return value;
    }

    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }

    return 0.0;
  }
}
