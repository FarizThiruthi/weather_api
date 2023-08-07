import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/Constraints/constraints.dart' as k;
import 'package:http/http.dart' as http;

class ScreenWeather extends StatefulWidget {
  ScreenWeather({super.key});

  @override
  State<ScreenWeather> createState() => _ScreenWeatherState();
}

class _ScreenWeatherState extends State<ScreenWeather> {
  num? temp;
  num? pressure;
  num? humidity;
  num? cover;
  String weatherDescription = '';
  String cityName = '';
  String currentDate = DateFormat.MMMMEEEEd().format(DateTime.now());

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/backgroundImage.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Text(
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: Colors.white54,
                          letterSpacing: 5),
                      '$cityName'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  currentDate,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Icon(
                  Icons.cloud,
                  color: Colors.white60,
                  size: 50,
                ),
                Text(
                  weatherDescription.toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white60,
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.cloud_circle_outlined,
                      size: 50,
                      color: Colors.white60,
                    ),
                    //SizedBox(width: 30,),
                    Text(
                      '${pressure?.toInt()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white60),
                    ),
                    Icon(
                      Icons.cloud_circle_outlined,
                      size: 50,
                      color: Colors.white60,
                    ),
                    //SizedBox(width: 30,),
                    Text(
                      '${humidity?.toInt()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white60),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Opacity(opacity: .8,
                  child: Text(
                    '${temp?.toStringAsFixed(2)}^C',
                    style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (position != null) {
      print('lat: ${position.latitude}');
      getCurrentCityWeather(position);
    } else {
      print('Data unavailable');
    }
  }

  Future<void> getCurrentCityWeather(Position pos) async {
    var url =
        '${k.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${k.apikey}';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data);
      print(decodedData);
      updateUI(decodedData);
    }
    else{
      print(response.statusCode);
    }
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        pressure = 0;
        humidity = 0;
        cover = 0;
      } else {
        print("pressure${pressure}");
        temp = (decodedData['main']['temp'] - 273).toDouble();
        pressure = decodedData['main']['pressure'] ;
        humidity = decodedData['main']['humidity'] ;
        weatherDescription = decodedData['weather'][0]['description'];
        cityName = decodedData['name'];
      }
    });
  }
}
