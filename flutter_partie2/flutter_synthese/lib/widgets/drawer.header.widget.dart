import 'package:flutter/material.dart';

class MyDrawerHeaderWidget extends StatelessWidget {
  const MyDrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange,
            Colors.white,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: const AssetImage('images/logo.png'),
            backgroundColor: Colors.white,
            onBackgroundImageError: (_, __) {},
          ),
          CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('images/logo.png'),
            backgroundColor: Colors.white,
            onBackgroundImageError: (_, __) {},
          ),
        ],
      ),
    );
  }
}
