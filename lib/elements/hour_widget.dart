import 'package:flutter/material.dart';
import 'package:weather/weather_api/weather.dart';

class HourWidget extends StatelessWidget {
  final WeatherHour hourInfo;
  final int index;
  const HourWidget({super.key, required this.hourInfo, required this.index});
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxHeight: 100),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 100,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '${index.toString().padLeft(2, '0')}:00',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Temp: ${hourInfo.temp.toString()}'),
                    Text('Sen. Term.: ${hourInfo.feelsLike.toString()}'),
                    Text('% Chuva: ${hourInfo.rainChance.toString()}')
                  ]),
            ),
            Expanded(child: Image.network(hourInfo.condition.icon.toString())),
          ],
        ),
      );
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    final firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    final firstEnd = Offset(size.width / 2.25, (size.height / 3) * 2);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    final secondStart =
        Offset(size.width - (size.width / 3.24), size.height / 3);
    //third point of quadratic bezier curve
    final secondEnd = Offset(size.width, 0);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
