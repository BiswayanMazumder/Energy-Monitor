import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> stringList = [
    'Hello',
    'Flutter',
    'Random',
    'String',
    'Example',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Random String App'),
          backgroundColor: Colors.white, // Set app bar background color
        ),
        body: Container(
          color: Colors.white, // Set background color of the body
          child: Center(
            child: RandomStringWidget(stringList: stringList),
          ),
        ),
      ),
    );
  }
}

class RandomStringWidget extends StatefulWidget {
  final List<String> stringList;

  RandomStringWidget({required this.stringList});

  @override
  _RandomStringWidgetState createState() => _RandomStringWidgetState();
}

class _RandomStringWidgetState extends State<RandomStringWidget> {
  late String randomString;

  @override
  void initState() {
    super.initState();
    // Initialize with a random string from the list
    randomString = getRandomString();
  }

  String getRandomString() {
    final random = Random();
    final index = random.nextInt(widget.stringList.length);
    return widget.stringList[index];
  }

  void changeRandomString() {
    setState(() {
      randomString = getRandomString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding for a well-organized look
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Random String:',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            randomString,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: changeRandomString,
            child: Text('Change String'),
          ),
        ],
      ),
    );
  }
}
