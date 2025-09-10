import 'package:flutter/material.dart';
import 'package:maestria/screens/settings_screen.dart';
import 'package:maestria/screens/stats_screen.dart';
import 'package:maestria/screens/theme_screen.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  Widget buildSettingField(String label, int value, Function(int) onChanged) {
    final controller = TextEditingController(text: value.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (val) {
              final v = int.tryParse(val);
              if (v != null) onChanged(v);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maestria"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              } else if (value == 'theme') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThemeScreen()),
                );
              } else if (value == 'stats') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Paramètres'),
                ),
                const PopupMenuItem(
                  value: 'theme',
                  child: Text('Thème'),
                ),
                const PopupMenuItem(
                  value: 'stats',
                  child: Text('Statistiques'),
                ),
              ];
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Paramètres rapides
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    buildSettingField("Durée travail (min)", timer.workDuration, timer.setWorkDuration),
                    const SizedBox(height: 8),
                    buildSettingField("Pause courte (min)", timer.shortBreak, timer.setShortBreak),
                    const SizedBox(height: 8),
                    buildSettingField("Pause longue (min)", timer.longBreak, timer.setLongBreak),
                    const SizedBox(height: 8),
                    buildSettingField("Cycles avant pause longue", timer.cyclesBeforeLongBreak, timer.setCyclesBeforeLongBreak),
                  ],
                ),
              ),
            ),

            // Timer display
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      timer.currentSession == SessionType.work
                          ? "Travail"
                          : timer.currentSession == SessionType.shortBreak
                          ? "Pause courte"
                          : "Pause longue",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: timer.currentSession == SessionType.work
                            ? Colors.indigo
                            : timer.currentSession == SessionType.shortBreak
                            ? Colors.green
                            : Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatTime(timer.remainingSeconds),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('Cycles complétés: ${timer.completedCycles}'),
                    const SizedBox(height: 20),
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
                        OutlinedButton(
                          onPressed: timer.resetTimer,
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Feedback buttons
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text("Feedback après la session", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () => timer.addFeedback("Facile"),
                          child: const Text("Facile"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () => timer.addFeedback("Moyen"),
                          child: const Text("Moyen"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => timer.addFeedback("Difficile"),
                          child: const Text("Difficile"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Historique", style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Supprimer l'historique ?"),
                                content: const Text("Cette action est irréversible."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Annuler"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      timer.clearHistory();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text("Supprimer"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timer.history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          title: Text(timer.history[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
