import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 5, 1, 48),
                Color.fromARGB(255, 82, 3, 69),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.6, 0.9])),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            "settings",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
