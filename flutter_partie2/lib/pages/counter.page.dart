import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print('Widget render .............');
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter Value => $counter',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              setState(() {
                --counter;
              });
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              setState(() {
                ++counter;
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
