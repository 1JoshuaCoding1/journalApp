import 'package:flutter/material.dart';
import 'package:journal_app/screens/entryscreen.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      theme: ThemeData(
      ),
      home: const EntryScreen(), 
    );
  }
}