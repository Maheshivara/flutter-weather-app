import 'package:flutter/material.dart';
import 'package:weather/elements/hour_widget.dart';
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
  String _msg = 'Please Search For a City';
  List<HourWidget> _hoursWidgets = [];
  final TextEditingController _inputController = TextEditingController();

  void _fetchWeather() async {
    _hoursWidgets = [];
    if (_inputController.text.isNotEmpty) {
      _location = _inputController.text;
    } else {
      setState(() {
        _msg = 'Please Search For a City';
      });
      return;
    }

    try {
      final response = await getWeather(_location);
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
    return Scaffold(
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
            const Text(
              "Cidade para consultar:",
              textAlign: TextAlign.center,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              textAlign: TextAlign.center,
              controller: _inputController,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _locationInfo,
                softWrap: true,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        tooltip: 'Consultar',
        child: const Icon(Icons.search),
      ),
    );
  }
}
