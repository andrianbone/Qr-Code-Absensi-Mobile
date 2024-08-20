import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_mobile_apps/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue)),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}
