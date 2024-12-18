import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/cities.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class chooseLocation extends StatefulWidget {
  const chooseLocation({super.key});

  @override
  State<chooseLocation> createState() => _chooseLocationState();
}

class _chooseLocationState extends State<chooseLocation> {


  @override
  void initState() {
    foundCities = cities;
    super.initState();
  }

  void _searchCities(String enteredKeyword){
    List<Map<String, dynamic>> results = [];
    if(enteredKeyword.isEmpty){
      results = cities;
    }else{
      results = cities.where((city) =>
          city['cityName'].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      foundCities = results;
    });

  }

  String code='0';

  void updateTime(index)async {
    final _weatherService = WeatherService('e7e47a5f5042f500f651f20c7bffc6f5');
    final updWeather = await _weatherService.getWeather(foundCities[index]['cityName']);
    final updHourlyWeather = await _weatherService.getHourlyWeather(foundCities[index]['cityName']);
    int i =0;
    Navigator.pop(context, {
      'cityName': foundCities[index]['cityName'],  //updWeather.cityName returns Province keyword after many cities
      'condition': updWeather.condition,
      'temperature': updWeather.temperature,
      'humidity': updWeather.humidity,
      'windSpeed': updWeather.windSpeed,
      'time': updHourlyWeather[index].time,

      //daily
      'conditionHourly'[5]: updHourlyWeather[8].conditionHourly,
      'conditionHourly'[6]: updHourlyWeather[16].conditionHourly,
      'conditionHourly'[7]: updHourlyWeather[24].conditionHourly,
      'conditionHourly'[8]: updHourlyWeather[32].conditionHourly,
      'conditionHourly'[9]: updHourlyWeather[39].conditionHourly,
      'temperatureHourly'[5]: updHourlyWeather[8].temperatureHourly.toString(),
      'temperatureHourly'[6]: updHourlyWeather[16].temperatureHourly.toString(),
      'temperatureHourly'[7]: updHourlyWeather[24].temperatureHourly.toString(),
      'temperatureHourly'[8]: updHourlyWeather[32].temperatureHourly.toString(),
      'temperatureHourly'[9]: updHourlyWeather[39].temperatureHourly.toString(),


      //hourly
      'conditionHourly'[1]: updHourlyWeather[1].conditionHourly,
      'conditionHourly'[2]: updHourlyWeather[2].conditionHourly,
      'conditionHourly'[3]: updHourlyWeather[3].conditionHourly,
      'conditionHourly'[4]: updHourlyWeather[4].conditionHourly,
      'temperatureHourly'[1]: updHourlyWeather[1].temperatureHourly.toString(),
      'temperatureHourly'[2]: updHourlyWeather[2].temperatureHourly.toString(),
      'temperatureHourly'[3]: updHourlyWeather[3].temperatureHourly.toString(),
      'temperatureHourly'[4]: updHourlyWeather[4].temperatureHourly.toString(),
      //for(int i=0; i<= updHourlyWeather.length;i++){}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: TextField(
          onChanged: (value)=>_searchCities(value),
          decoration: InputDecoration(labelText: "Search", suffixIcon: Icon(Icons.search)),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(itemCount: foundCities.length,
            itemBuilder: (context, index){
          code = '0${foundCities[index]['id'].toString()}';
            return Card(
              child: ListTile (
                onTap: (){print(foundCities[index]['cityName']); updateTime(index);},
                leading: Text(code.length>2 ? code.substring(1) : code),
                title: Text(foundCities[index]['cityName']),
              ),
            );
        }),
      ),

     // floatingActionButton:  FloatingActionButton(onPressed: (){_fetchWeather();}),
    );
  }
}
