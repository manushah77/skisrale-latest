class WeatherModel {
  WeatherModel(
      this.weather_status, this.des, this.temp, this.humidity, this.pressure,this.sunset,this.sunrise);

  String weather_status = "";
  String? des;
  num temp = 0;
  num pressure = 0;
  num humidity = 0;
  int? sunrise;
  int? sunset;

  factory WeatherModel.fromJson(Map json) {
    return WeatherModel(
      json['weather'][0]['main'] ?? "Unknown",
      json['weather'][0]['description'] ?? "",
      json['main']['temp'] ?? "Unknown",
      json['main']['humidity'] ?? "Unknown",
      json['main']['pressure'] ?? "Unknown",
      json['sys']['sunrise'] ?? "Unknown",
      json['sys']['sunset'] ?? "Unknown",
    );
  }
}
