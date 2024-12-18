import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/models/hourly_model.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService{
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  static const HOURLY_URL = 'https://api.openweathermap.org/data/2.5/forecast';
  final String apiKey;
  List<hourlyWeather> hourly = [];

  WeatherService(this.apiKey);
  Future<Weather> getWeather(String cityName) async {
    //gets from api with parameters
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    //checks if api response is valid
    if(response.statusCode == 200){
      //print(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error');
    }
  }

  Future<List<hourlyWeather>> getHourlyWeather(String cityName) async {
    //gets from api with parameters
    final response = await http.get(Uri.parse('$HOURLY_URL?q=$cityName&appid=$apiKey&units=metric'));
    //checks if api response is valid
    if(response.statusCode == 200){
      //print(response.body);
      var jsonData = jsonDecode(response.body);
      for(var eachHour in jsonData['list']){
        final hour = hourlyWeather(
            time: eachHour['dt_txt'],
        conditionHourly: eachHour['weather'][0]['main'],
        temperatureHourly: eachHour['main']['temp'].toDouble());
        hourly.add(hour);
      }
      return hourly;
      //return hourlyWeather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error');
    }
  }


  Future<String> getCurrentLocation() async{

    //get permission for location
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Permission Denied');
      }
    }

    //get coordinates
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


    //get city from coordinates
    print(position.latitude);
    print(position.longitude);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    print(city);


    return city ?? "";

    /*var address = await GeoCode().reverseGeocoding(
        latitude: position.latitude, longitude: position.longitude);

    print(address.city);
    //return cityname
    return address.city ?? "";
     */
  }
}