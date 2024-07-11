import 'package:flutter/material.dart';
import 'package:flutter_sqflite/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SQFLite Demo',
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
