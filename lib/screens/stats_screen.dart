import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques"),
      ),
      body: const Center(
        child: Text(
          "Ici vous pourrez voir vos statistiques de révision.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
