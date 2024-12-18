class Weather {
  String cityName;
  double temperature;
  String condition;
  double humidity;
  double windSpeed;

  Weather({
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });


  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      cityName: json['name'],
      condition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }

}