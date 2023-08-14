import 'dart:ffi';

import 'package:flutter/material.dart';
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
  final Float temp;
  final Condition condition;
  final Float feelsLike;
  final Int rainChance;

  const WeatherHour({
    required this.temp,
    required this.condition,
    required this.feelsLike,
    required this.rainChance,
  });
}
