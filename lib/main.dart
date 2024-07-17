import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:journal_app/app_router.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: 'api.env');
    print('Environment file loaded successfully');
  } catch (e) {
    print('Failed to load environment file: $e');
  }

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      theme: ThemeData(),
      routerConfig: AppRouter.router,
    );
  }
}