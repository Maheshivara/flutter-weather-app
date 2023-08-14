import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> fetchWeather(final String location) {
  const apiKey = '312ed354359a4bbcbe6140830231804 ';
  final weather = http.get(Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=1&aqi=no&alerts=no'));
  return weather;
}

class Condition {
  final String text;
  final Uri icon;

  const Condition({
    required this.text,
    required this.icon,
  });
}

class WeatherHour {
  final double temp;
  final Condition condition;
  final double feelsLike;
  final int rainChance;

  const WeatherHour({
    required this.temp,
    required this.condition,
    required this.feelsLike,
    required this.rainChance,
  });
}

class WeatherDay {
  final String name;
  final String region;
  final String tzId;
  final List<WeatherHour> hours;
  const WeatherDay(
      {required this.name,
      required this.region,
      required this.tzId,
      required this.hours});
}

Future<WeatherDay> getWeather(final String location) async {
  final response = await fetchWeather(location);
  if (response.statusCode == 200) {
    final Map<String, dynamic> myMap = jsonDecode(response.body);
    final List<dynamic> hoursJson = myMap['forecast']['forecastday'][0]['hour'];

    final List<WeatherHour> hours = [];
    for (final hour in hoursJson) {
      hours.add(WeatherHour(
          temp: hour['temp_c'],
          condition: Condition(
              text: hour['condition']['text'],
              icon: Uri.parse('https:${hour['condition']['icon']}')),
          feelsLike: hour['feelslike_c'],
          rainChance: hour['chance_of_rain']));
    }

    final String name = myMap['location']['name'];
    final String region = myMap['location']['region'];
    final String tzId = myMap['location']['tz_id'];
    final WeatherDay weather =
        WeatherDay(name: name, region: region, tzId: tzId, hours: hours);
    return weather;
  } else {
    throw Exception('Falha ao consultar a API');
  }
}
