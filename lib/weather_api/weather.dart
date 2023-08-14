import 'package:http/http.dart' as http;

Future<http.Response> fetchWeather(final String location) {
  const apiKey = '312ed354359a4bbcbe6140830231804 ';
  final weather = http.get(Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=1&aqi=no&alerts=no'));
  return weather;
}