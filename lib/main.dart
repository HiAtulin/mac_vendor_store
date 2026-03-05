import 'package:flutter/material.dart';
import 'package:mac_vendor_store/views/screens/authentication/login_screen.dart';
import 'package:mac_vendor_store/views/screens/authentication/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: RegisterScreen(),
    );
  }
}
