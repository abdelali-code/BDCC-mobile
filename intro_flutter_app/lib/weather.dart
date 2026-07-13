import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// Reprend l'exemple "Weather Page : weather.dart" du support de cours :
/// StatefulWidget qui appelle une API REST dans initState() via le
/// package http, puis affiche les résultats dans une ListView.builder.
class Weather extends StatefulWidget {
  final String city;
  const Weather(this.city, {super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  List<dynamic>? weatherData;
  String? error;

  // Clé de démonstration fournie par le support de cours (utilisée avec le
  // endpoint "samples" d'OpenWeatherMap, qui renvoie des données d'exemple
  // fixes quelle que soit la ville). Pour de vraies données météo, créez
  // votre propre clé gratuite sur https://openweathermap.org/appid et
  // utilisez l'endpoint standard "api.openweathermap.org".
  static const String _apiKey = 'b6907d289e10d714a6e88b30761fae22';

  void getData(String url) {
    http
        .get(Uri.parse(url), headers: {'accept': 'application/json'})
        .then((resp) {
      final body = json.decode(resp.body);
      if (body['list'] == null) {
        setState(() => error = body['message']?.toString() ?? 'Erreur inconnue');
        return;
      }
      setState(() => weatherData = body['list']);
    }).catchError((err) {
      setState(() => error = err.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    final url =
        'https://samples.openweathermap.org/data/2.5/forecast?q=${widget.city}&appid=$_apiKey';
    getData(url);
  }

  IconData _iconFor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city),
        backgroundColor: Colors.orange,
      ),
      body: error != null
          ? Center(child: Text('Erreur : $error'))
          : weatherData == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: weatherData!.length,
                  itemBuilder: (context, index) {
                    final item = weatherData![index];
                    final condition = item['weather'][0]['main'] as String;
                    final date = DateTime.fromMillisecondsSinceEpoch(
                      (item['dt'] as int) * 1000,
                    );
                    return Card(
                      color: Colors.deepOrange,
                      margin:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    _iconFor(condition),
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('E dd/MM/yyyy').format(date),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat('HH:mm').format(date)} | $condition',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${item['main']['temp'].round()} °C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
