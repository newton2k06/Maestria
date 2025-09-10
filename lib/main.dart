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
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          cardColor: Colors.white,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: const Color(0xFF212121),
              displayColor: const Color(0xFF212121),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.grey[900],
          cardColor: Colors.grey[850],
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
        ),
        themeMode: ThemeMode.system, // suit le thème du téléphone
        home: const HomeScreen(),
      ),
    );
  }
}
