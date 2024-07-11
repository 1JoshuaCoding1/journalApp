import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:journal_app/app_router.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      theme: ThemeData(
      ),
      routerConfig: AppRouter.router, 
    );
  }
}