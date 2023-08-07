import 'package:flutter/material.dart';
import 'package:weather_api/Screens/screenWeather.dart';

void main(){
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:ScreenWeather(),
    );
  }
}
