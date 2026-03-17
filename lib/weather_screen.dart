import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weater_app/components/additional_info_item.dart';

import 'components/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // double temp = 0;
  // Instead of handlings states on our own we can use FutureBuilderWidget provided by Flutter
  late Future<Map<String, dynamic>> weatherFuture;
  @override
  void initState() {
    super.initState();
    weatherFuture = getWeatherData();
  }

  final _kelvinConst = 273.15;
  Future<Map<String, dynamic>> getWeatherData() async {
    final apikey = dotenv.env['API_KEY'];

    try {
      final url = Uri.https('api.openweathermap.org', '/data/2.5/forecast', {
        'q': 'Delhi',
        'appid': apikey,
      });
      final res = await http.get(url);
      final data = jsonDecode(res.body);
      // print(data);
      if (data['cod'] != "200") {
        throw "An unexpected error occured";
      }

      // setState(() {
      //   temp = data['main']['temp'];
      //   print(temp);
      // });

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherFuture = getWeatherData();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final res = snapshot.data!;
          final data = res['list'];
          // print(data);
          final temp = data[0]['main']['temp'] - _kelvinConst;
          final skyType = data[0]['weather'][0]['main'];
          final humidity = data[0]['main']['humidity'];
          final pressure = data[0]['main']['pressure'];
          final windSpeed = data[0]['wind']['speed'];
          // print(skyType);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Column(
                            children: [
                              Text(
                                "${temp.toStringAsFixed(2)} °C",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),

                              skyType == "Clouds" || skyType == "Rain"
                                  ? Icon(Icons.cloud, size: 64)
                                  : Icon(Icons.sunny, size: 64),

                              Text(
                                "$skyType",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Weather Forecast",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 1; i < 5; i++)
                              HourlyForecastCard(
                                time: DateFormat.j()
                                    .format(
                                      DateTime.parse(data[i + 1]['dt_txt']),
                                    )
                                    .toString(),
                                temperature:
                                    "${(data[i + 1]['main']['temp'] - _kelvinConst).toStringAsFixed(2)} °C",
                                icon:
                                    data[i + 1]['weather'][0]['main'] ==
                                            "Clouds" ||
                                        data[i + 1]['weather'][0]['main'] ==
                                            "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: "Humidity",
                            measure: "$humidity",
                          ),

                          AdditionalInfoItem(
                            icon: Icons.air,
                            label: "Wind Speed",
                            measure: "$windSpeed",
                          ),
                          AdditionalInfoItem(
                            icon: Icons.wind_power_rounded,
                            label: "Pressure",
                            measure: "$pressure.",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// FuterBuilder:

// FutureBuilder is a Flutter widget used to build UI based on the result
// of an asynchronous operation (Future), such as an API call.
//
// It automatically handles different states of the Future:
// - Loading (while waiting for data)
// - Success (when data is received)
// - Error (if something goes wrong)

// ListView.builder():
// It uses a builder function with a snapshot that provides the current
// state and data of the Future, allowing dynamic UI updates without
// manually managing state using setState().

// ListView.builder is used to create a scrollable list efficiently.
// It builds list items lazily (only when they are visible on screen),
// which improves performance for large or dynamic data sets.
// The itemBuilder function provides each item using its index.
