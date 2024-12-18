class hourlyWeather {
 // String name;
  String time;
  double temperatureHourly;
  String conditionHourly;

  hourlyWeather({
  //  required this.name,
    required this.time,
    required this.conditionHourly,
    required this.temperatureHourly,
  });


  factory hourlyWeather.fromJson(Map<String, dynamic> json){
    return hourlyWeather(
     // name: json['city']['name'],
      time: json['dt_txt'],
      conditionHourly: json['weather'][0]['main'],
      temperatureHourly: json['main']['temp'].toDouble(),
    );
  }

}