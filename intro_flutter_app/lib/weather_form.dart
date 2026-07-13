import 'package:flutter/material.dart';
import 'weather.dart';

/// Reprend l'exemple "Weather Page : weather-form.dart" du support de cours :
/// un TextField relié à onChanged/onSubmitted pour saisir une ville,
/// puis navigation vers l'écran Weather qui affiche les prévisions.
class WeatherForm extends StatefulWidget {
  const WeatherForm({super.key});

  @override
  State<WeatherForm> createState() => _WeatherFormState();
}

class _WeatherFormState extends State<WeatherForm> {
  String city = '';
  final TextEditingController cityEditingController = TextEditingController();

  void _search() {
    if (city.trim().isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Weather(city)),
    );
    cityEditingController.clear();
  }

  @override
  void dispose() {
    cityEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(hintText: 'Tapez une ville..'),
              controller: cityEditingController,
              onChanged: (str) => setState(() => city = str),
              onSubmitted: (str) => _search(),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: _search,
              child: const Text('Get Weather'),
            ),
          ),
        ],
      ),
    );
  }
}
