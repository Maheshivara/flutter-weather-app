import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:weather/elements/hour_widget.dart';
import 'package:weather/elements/location_widget.dart';
import 'package:weather/weather_api/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 164, 214, 163)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather Preview'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _location = '';
  String _locationInfo = '';
  String _msg = 'Por favor procure por uma cidade';
  List<HourWidget> _hoursWidgets = [];
  final TextEditingController _inputController = TextEditingController();

  void _fetchLocation() async {
    final input = removeDiacritics(_inputController.text);
    if (input.isEmpty) {
      setState(() {
        _locationInfo = '';
        _hoursWidgets = [];
        _msg = 'Por favor procure por uma cidade';
      });
      return;
    }
    if (input.length < 3) {
      setState(() {
        _locationInfo = '';
        _hoursWidgets = [];
        _msg = 'Necessário ao menos 3 caracteres';
      });
      return;
    }
    _location = input;
    try {
      final cities = await getLocations(_location);
      if (cities.isEmpty) {
        setState(() {
          _locationInfo = '';
          _hoursWidgets = [];
          _msg = 'Não foram encontradas cidades com o nome $_location';
        });
      } else {
        _showDialog(cities);
      }
    } catch (error) {
      setState(() {
        _locationInfo = '';
        _hoursWidgets = [];
        _msg = error.toString();
      });
    }
  }

  void _showDialog(List<Location> cities) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: LocationWidget(
                    cities: cities,
                    fetchWeather: _fetchWeather,
                    dispose: () => Navigator.pop(context)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchWeather(final String location) async {
    _hoursWidgets = [];
    try {
      final response = await getWeather((location));
      setState(() {
        _locationInfo = '${response.name}/ ${response.region}';
        response.hours.asMap().forEach((key, hour) {
          _hoursWidgets.add(HourWidget(hourInfo: hour, index: key));
        });
      });
    } catch (error) {
      setState(() {
        _locationInfo = '';
        _hoursWidgets = [];
        _msg = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: 'Nome da Cidade:',
                        ),
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.center,
                        controller: _inputController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _fetchLocation,
                      child: const Icon(Icons.search))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  _locationInfo,
                  softWrap: true,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _hoursWidgets.isEmpty ? 1 : _hoursWidgets.length,
                    itemBuilder: (context, index) {
                      if (_hoursWidgets.isEmpty) {
                        return Center(
                          child: Text(_msg),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: _hoursWidgets[index],
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
