import 'package:flutter/material.dart';
import 'package:flutter_synthese/global/global.parameter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application de Synthèse',
      initialRoute: '/',
      routes: GlobalParameters.routes,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 22, color: Colors.deepOrange),
        ),
      ),
    );
  }
}
