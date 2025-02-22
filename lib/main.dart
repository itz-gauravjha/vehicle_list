import 'package:flutter/material.dart';
import 'list_vehicles_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListVehiclesScreen(),
    );
  }
}