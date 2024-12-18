import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/hourly_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('e7e47a5f5042f500f651f20c7bffc6f5');
  Weather? _weather;
  late List<hourlyWeather?> _hourlyWeather = [];


  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentLocation();

    //get weather for  current city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e){
      print(e);
    }
    try {
      final hourlyWeather = await _weatherService.getHourlyWeather(cityName);
      setState(() {
        _hourlyWeather = hourlyWeather;
      });
    } catch (e){
      print(e);
    }
  }

  String getWeatherAnimation(String? condition){
    if(condition == null){return "assets/sunny.json";}

    switch (condition.toLowerCase()){
      case"rain":
      case"drizzle":
        return"assets/rainy.json";
      case"thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      case "snow":
        return "assets/snowy.json";
      case "clouds":
      case "mist":
      case "smoke":
      case "fog":
      case"haze":
      case "dust":
      case "squall":
        return "assets/cloudy.json";
      default:
        return "assets/sunny.json";
    }

  }
  void initState(){
    super.initState();

    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2*kToolbarHeight, 40, 50),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amberAccent,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amberAccent,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 600,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    //city name
                    Text(_weather?.cityName ?? "loading city..",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w500
                    )),

                    Container(height: 195,
                    child: Lottie.asset(getWeatherAnimation(_weather?.condition))),
                    SizedBox(height: 0,),
                    Builder(
                      builder: (context) {
                        return ElevatedButton.icon(onPressed: () async{
                          dynamic result = await Navigator.pushNamed(context, '/location');
                          final hourlyWeather = await _weatherService.getHourlyWeather(result['cityName']);
                          setState(() {
                            _weather?.cityName = result['cityName'];
                            _weather?.temperature = result['temperature'];
                            _weather?.condition = result['condition'];
                            _weather?.humidity = result['humidity'];
                            _weather?.windSpeed = result['windSpeed'];
                            //daily

                            _hourlyWeather[8]?.conditionHourly = result['conditionHourly'[5]];
                            _hourlyWeather[16]?.conditionHourly = result['conditionHourly'[6]];
                            _hourlyWeather[24]?.conditionHourly = result['conditionHourly'[7]];
                            _hourlyWeather[32]?.conditionHourly = result['conditionHourly'[8]];
                            _hourlyWeather[39]?.conditionHourly = result['conditionHourly'[9]];

                            _hourlyWeather[8]?.temperatureHourly = double.parse(result['temperatureHourly'[5]]);
                            _hourlyWeather[16]?.temperatureHourly = double.parse(result['temperatureHourly'[6]]);
                            _hourlyWeather[24]?.temperatureHourly = double.parse(result['temperatureHourly'[7]]);
                            _hourlyWeather[32]?.temperatureHourly = double.parse(result['temperatureHourly'[8]]);
                            _hourlyWeather[39]?.temperatureHourly = double.parse(result['temperatureHourly'[9]]);

                            //hourly
                            _hourlyWeather[4]?.conditionHourly = result['conditionHourly'[4]];
                            _hourlyWeather[3]?.conditionHourly = result['conditionHourly'[3]];
                            _hourlyWeather[2]?.conditionHourly = result['conditionHourly'[2]];
                            _hourlyWeather[1]?.conditionHourly = result['conditionHourly'[1]];
                            _hourlyWeather[4]?.temperatureHourly = double.parse(result['temperatureHourly'[4]]);
                            _hourlyWeather[3]?.temperatureHourly = double.parse(result['temperatureHourly'[3]]);
                            _hourlyWeather[2]?.temperatureHourly = double.parse(result['temperatureHourly'[2]]);
                            _hourlyWeather[1]?.temperatureHourly = double.parse(result['temperatureHourly'[1]]);
                          });

                        }, icon: Icon(Icons.edit_location), label: Text('Edit Location'));
                      }
                    ),
                    SizedBox(height: 10,),
                    //Text(_hourlyWeather.length>0 ? _hourlyWeather[16]?.time ?? '..' : ''),
                    //Text(_hourlyWeather.length>0 ? _hourlyWeather[8]?.conditionHourly ?? '..' : ''),
                    //Text(_hourlyWeather.length>0 ? _hourlyWeather[16]?.temperatureHourly.toString() ?? '..' : ''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                          Icon(Icons.water_drop, size: 50, color: Colors.blue),
                          //child: AssetImage("assets/humidity.png"),

                        Text('${_weather?.temperature.round()}°C',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                         ),
                        ),

                        Icon(Icons.air, size: 50, color: Colors.blueGrey[200]),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(),
                        SizedBox(
                          height: 50,
                          width: 61,
                          child: Text('${_weather?.humidity.round()}%',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                           ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          width: 91,
                        ),
                        SizedBox(),
                        SizedBox(
                          height: 50,
                          width: 70,
                          child: Text('${_weather?.windSpeed}m/s',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height:0),
                    SizedBox(height: 20,),

                    Container(
                      height:125,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? _hourlyWeather[1]!.time.substring(11,16) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[1]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[1]!.temperatureHourly.toString().substring(0,_hourlyWeather[1]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 100,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? _hourlyWeather[2]!.time.substring(11,16) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[2]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[2]!.temperatureHourly.toString().substring(0,_hourlyWeather[2]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 100,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? _hourlyWeather[3]!.time.substring(11,16) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[3]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[3]!.temperatureHourly.toString().substring(0,_hourlyWeather[3]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 100,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? _hourlyWeather[4]!.time.substring(11,16) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[4]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[4]!.temperatureHourly.toString().substring(0,_hourlyWeather[4]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 30),
                    Container(
                      height:125,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? DateFormat('EEEE').format(DateTime.parse(_hourlyWeather[8]!.time)) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[8]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[8]!.temperatureHourly.toString().substring(0,_hourlyWeather[8]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 120,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? DateFormat('EEEE').format(DateTime.parse(_hourlyWeather[16]!.time)) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[16]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[16]!.temperatureHourly.toString().substring(0,_hourlyWeather[16]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 120,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? DateFormat('EEEE').format(DateTime.parse(_hourlyWeather[24]!.time)) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[24]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[24]!.temperatureHourly.toString().substring(0,_hourlyWeather[24]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 120,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? DateFormat('EEEE').format(DateTime.parse(_hourlyWeather[32]!.time)) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[32]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[32]!.temperatureHourly.toString().substring(0,_hourlyWeather[32]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: Colors.white),
                          SizedBox(
                            width: 120,
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_hourlyWeather.length > 0 ? DateFormat('EEEE').format(DateTime.parse(_hourlyWeather[39]!.time)) : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                    Container( height: 50,
                                        child: Lottie.asset(getWeatherAnimation(_hourlyWeather.length > 0 ? _hourlyWeather[39]?.conditionHourly : ''))),
                                    Text(_hourlyWeather.length > 0 ? '${_hourlyWeather[39]!.temperatureHourly.toString().substring(0,_hourlyWeather[39]!.temperatureHourly.toString().indexOf('.')+2)}°C' : '..', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],

          ),
        ),
      ),
      //floatingActionButton: FloatingActionButton(onPressed: _fetchWeather,),
    );
  }
}
