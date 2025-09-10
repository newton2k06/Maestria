import 'dart:async';
import 'package:flutter/material.dart';

enum SessionType { work, shortBreak, longBreak }

class TimerProvider extends ChangeNotifier {
  int workDuration = 25; // minutes
  int shortBreak = 5;
  int longBreak = 15;
  int cyclesBeforeLongBreak = 4;

  SessionType currentSession = SessionType.work;
  int remainingSeconds = 25 * 60;
  int completedCycles = 0;

  Timer? _timer;
  bool isRunning = false;

  List<String> history = [];

  void startTimer() {
    if (_timer != null && _timer!.isActive) return;

    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        _endSession();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    isRunning = false;
    _setInitialTime();
    notifyListeners();
  }

  void _setInitialTime() {
    switch (currentSession) {
      case SessionType.work:
        remainingSeconds = workDuration * 60;
        break;
      case SessionType.shortBreak:
        remainingSeconds = shortBreak * 60;
        break;
      case SessionType.longBreak:
        remainingSeconds = longBreak * 60;
        break;
    }
  }

  void _endSession() {
    pauseTimer();
    if (currentSession == SessionType.work) {
      completedCycles++;
      if (completedCycles % cyclesBeforeLongBreak == 0) {
        currentSession = SessionType.longBreak;
      } else {
        currentSession = SessionType.shortBreak;
      }
    } else {
      currentSession = SessionType.work;
    }
    _setInitialTime();
    notifyListeners();
  }

  void addFeedback(String feedback) {
    history.add("${currentSession.name} → $feedback");
    notifyListeners();
  }
  // Ajout de setters pour modifier les paramètres
  void setWorkDuration(int minutes) {
    workDuration = minutes.clamp(1, 180);
    if (currentSession == SessionType.work && !isRunning) {
      remainingSeconds = workDuration * 60;
      notifyListeners();
    }
  }

  void setShortBreak(int minutes) {
    shortBreak = minutes.clamp(1, 120);
    if (currentSession == SessionType.shortBreak && !isRunning) {
      remainingSeconds = shortBreak * 60;
      notifyListeners();
    }
  }

  void setLongBreak(int minutes) {
    longBreak = minutes.clamp(1, 240);
    if (currentSession == SessionType.longBreak && !isRunning) {
      remainingSeconds = longBreak * 60;
      notifyListeners();
    }
  }

  void setCyclesBeforeLongBreak(int cycles) {
    cyclesBeforeLongBreak = cycles.clamp(1, 10);
    notifyListeners();
  }
  void clearHistory() {
    history.clear();
    notifyListeners();
  }

}
