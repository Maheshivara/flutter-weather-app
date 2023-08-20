import 'package:flutter/material.dart';
import 'package:weather/weather_api/weather.dart';

class LocationWidget extends StatelessWidget {
  final List<Location> cities;
  final Function(String) fetchWeather;
  final Function() dispose;
  const LocationWidget({
    super.key,
    required this.cities,
    required this.fetchWeather,
    required this.dispose,
  });
  @override
  Widget build(BuildContext context) {
    final List<Widget> citiesButton = [];
    for (final city in cities) {
      citiesButton.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              fetchWeather('${city.name}-${city.region}-${city.country}');
              dispose();
            },
            child: Text(
              '${city.name}/ ${city.region}/ ${city.country}',
              softWrap: true,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return citiesButton[index];
      },
    );
  }
}
