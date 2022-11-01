import 'package:flutter/material.dart';
import 'package:space_station/views/application.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Station',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ApplicationContainer(),
    );
  }
}
