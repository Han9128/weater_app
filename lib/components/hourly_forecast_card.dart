import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HourlyForecastCard extends StatefulWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  State<HourlyForecastCard> createState() => _HourlyForecastCardState();
}

class _HourlyForecastCardState extends State<HourlyForecastCard> {
  // @override
  // void initState() {
  //   super.initState();
  //   // getWeatherData();
  // }

  // Future getWeatherData() async {
  //   final apikey = dotenv.env['API_KEY'];

  //   try {
  //     final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
  //       'q': 'Delhi',
  //       'appid': apikey,
  //     });
  //     print(apikey);
  //     final res = await http.get(url);
  //     print(res.body);
  //     // final data = jsonDecode(res.body);
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                children: [
                  Text(
                    widget.time,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),

                  Icon(widget.icon, size: 32),

                  Text(
                    widget.temperature,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
