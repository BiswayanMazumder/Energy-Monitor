import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:energy_monitor/graph_pages.dart';
import 'package:energy_monitor/historic_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Monitor',
      home: AnimatedSplashScreen(
        splash: Image.network(
          'https://cloud.appwrite.io/v1/storage/buckets/651bfb2d40b8880da24a/files/65828e1b10ca822193be/view?project=64e0600003aac5802fbc&mode=admin',
          width: 500,
          height: 500,
        ),
        backgroundColor: Colors.black,
        animationDuration: Duration(seconds: 2),
        splashTransition: SplashTransition.decoratedBoxTransition,
        centered: true,
        // nextScreen:HomeScreen(),
        nextScreen:MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDark = true;
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('https://energymonitor.vercel.app/api/getdata'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonData = json.decode(response.body);

      // Assuming the structure is similar to the provided dataList
      return jsonData.map((data) => data as Map<String, dynamic>).toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }
  int chartValue = 25; // Initial chart value

  late Timer _timer; // Timer for updating the chart

  @override
  void initState() {
    super.initState();
    // Start the timer to update the chart every second
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Update the chart value with a random integer between 1 and 100
      setState(() {
        chartValue = Random().nextInt(100) + 1;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Energy Monitor',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,

      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://cloud.appwrite.io/v1/storage/buckets/651bfb2d40b8880da24a/files/6582a56546d6bbb4a1eb/view?project=64e0600003aac5802fbc&mode=admin'),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text('Amount Of Energy Wasted v/s Saved on Daily Basis',style: GoogleFonts.abel(color: Colors.white,
                fontWeight: FontWeight.bold,fontSize: 18),),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: chartValue.toDouble(),
                            color: Colors.green,
                            title: '$chartValue%', // Display the current value
                            titleStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: (100 - chartValue).toDouble(),
                            color: Colors.red,
                            title: '${100 - chartValue}%',
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        centerSpaceRadius: 40,
                        startDegreeOffset: 180,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'View Energy Dashboard',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark?Colors.white:Colors.black
                    )
                  ),
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) => GraphPage()));
                  },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(isDark?Colors.black:Colors.white)
                    ),
                      child: Text('View Dashboard',style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),),
                ),
                SizedBox(
                  height: 50,
                ),
                Text('ABOUT',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 10,
                ),
                Text('ESP32 Energy Monitor',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Card(
                    color: Colors.black,
                    elevation: 40,
                    shape: Border.all(color: Colors.red),
                    shadowColor: Colors.white,
                    child: Column(
                      children: [
                        Text('      \nHistorical Data Review      ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        Text('\nhistorical energy data to identify trends, patterns, and potential areas for optimization.\n',style: TextStyle(color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder:(context) => historic_data(),));
                            },
                                child:Row(
                                  children: [
                                    Text('Learn More',style: TextStyle(color: Colors.red)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.arrow_right_alt_rounded,color: Colors.red,)
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.yellow,
                  endIndent: 50,
                  indent: 50,
                  thickness: 1,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black
                      )
                  ),
                  child: Card(
                    color: Colors.black,
                    elevation: 40,
                    shape: Border.all(color: Colors.red),
                    shadowColor: Colors.white,
                    child: Column(
                      children: [
                        Text('      \nReal-time Monitoring      ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        Text('\nGet live updates on voltage, current, power, and energy consumption from your ESP32 devices.\n',style: TextStyle(color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  try {
                                    // Fetch data before navigating to YourWidget
                                    final List<Map<String, dynamic>> dataList = await fetchData();

                                    // Navigate to YourWidget page with fetched dataList
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GraphPage(),
                                      ),
                                    );
                                  } catch (e) {
                                    // Handle error
                                    print('Error: $e');
                                  }
                                },
                                child:Row(
                                  children: [
                                    Text('Learn More',style: TextStyle(color: Colors.red)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.arrow_right_alt_rounded,color: Colors.red,)
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.yellow,
                  endIndent: 50,
                  indent: 50,
                  thickness: 1,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black
                      )
                  ),
                  child: Card(
                    color: Colors.black,
                    elevation: 40,
                    shape: Border.all(color: Colors.red),
                    shadowColor: Colors.white,
                    child: Column(
                      children: [
                        Text('      \nAI-powered Suggestions      ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        Text('\nExplore AI-generated suggestions based on your energy data.\n',style: TextStyle(color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder:(context) => GraphPage()));
                            },
                                child:Row(
                                  children: [
                                    Text('Learn More',style: TextStyle(color: Colors.red)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.arrow_right_alt_rounded,color: Colors.red,)
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.yellow,
                  endIndent: 50,
                  indent: 50,
                  thickness: 1,
                ),
                SizedBox(
                  height: 30,
                ),
                Text('How it works',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text('ESP32 and Sensors',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Install and configure ESP32 and other sensors to measure voltage, current, and power',style: TextStyle(color: Colors.white,fontSize: 15),),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                        backgroundColor: Colors.red,
                      child:Icon(Icons.check,color: Colors.white,)
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Data Transmission',style: GoogleFonts.amaranth(fontWeight: FontWeight.bold,color: Colors.white,
                    fontSize: 20),),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('ESP32 devices send energy data to our platform via the Internet.',style: GoogleFonts.amaranth(color: Colors.white,
                    fontSize: 15),),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                        backgroundColor: Colors.red,
                        child:Icon(Icons.check,color: Colors.white,)
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Real-time Visualization',style: GoogleFonts.amaranth(fontWeight: FontWeight.bold,color: Colors.white,
                        fontSize: 20),),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('View real-time graphs and charts on the dashboard to monitor energy metrics.',style: GoogleFonts.amaranth(color: Colors.white,
                    fontSize: 15),),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                        backgroundColor: Colors.red,
                        child:Icon(Icons.check,color: Colors.white,)
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Historical Analysis',style: GoogleFonts.amaranth(fontWeight: FontWeight.bold,color: Colors.white,
                        fontSize: 20),),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Dive into historical data to gain Link deeper understanding of your energy consumption patterns.',style: GoogleFonts.amaranth(color: Colors.white,
                    fontSize: 15),),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                        backgroundColor: Colors.red,
                        child:Icon(Icons.check,color: Colors.white,)
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('AI Insights',style: GoogleFonts.amaranth(fontWeight: FontWeight.bold,color: Colors.white,
                        fontSize: 20),),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Generate AI-powered suggestions to optimize energy usage and reduce environmental impact.',style: GoogleFonts.amaranth(color: Colors.white,
                    fontSize: 15),),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.yellow,
                  endIndent: 50,
                  indent: 50,
                  thickness: 1,
                ),
                SizedBox(
                  height: 80,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
