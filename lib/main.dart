import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/timer_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MaestriaApp());
}

class MaestriaApp extends StatelessWidget {
  const MaestriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maestria',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
