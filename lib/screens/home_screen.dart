import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maestria"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timer.currentSession == SessionType.work
                  ? "Travail"
                  : timer.currentSession == SessionType.shortBreak
                  ? "Pause courte"
                  : "Pause longue",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(timer.remainingSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: timer.isRunning ? null : timer.startTimer,
                  child: const Text("Start"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: timer.isRunning ? timer.pauseTimer : null,
                  child: const Text("Pause"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: timer.resetTimer,
                  child: const Text("Reset"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Feedback"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            timer.addFeedback("Facile");
                            Navigator.pop(context);
                          },
                          child: const Text("Facile"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            timer.addFeedback("Moyen");
                            Navigator.pop(context);
                          },
                          child: const Text("Moyen"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            timer.addFeedback("Difficile");
                            Navigator.pop(context);
                          },
                          child: const Text("Difficile"),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text("Donner un feedback"),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: timer.history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(timer.history[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
