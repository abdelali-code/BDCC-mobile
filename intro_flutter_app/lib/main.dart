import 'package:flutter/material.dart';
import 'quiz.dart';
import 'weather_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Introduction Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

/// Reprend l'exemple "First App : Drawer" du support de cours :
/// un écran d'accueil avec un menu latéral (Drawer) qui navigue
/// vers l'écran Quiz ou l'écran Weather.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First App'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'Hello',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.orange),
                ),
              ),
            ),
            ListTile(
              title: const Text('Quiz', style: TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Quiz()),
                );
              },
            ),
            ListTile(
              title: const Text('Weather', style: TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherForm()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
