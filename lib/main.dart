import 'package:flutter/material.dart';
import 'package:weather_app/pages/choose_location.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
      routes: {
        '/home': (context) => WeatherPage(),
        '/location': (context) => chooseLocation(),
      }
    );
  }
}
