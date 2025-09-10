import 'package:flutter/material.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thème"),
      ),
      body: const Center(
        child: Text(
          "Ici vous pourrez choisir le thème de l'application.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
