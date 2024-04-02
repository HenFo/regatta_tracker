import 'package:flutter/material.dart';
import 'package:regatta_tracker2/pages/create_regatta.dart';
import 'package:regatta_tracker2/pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<SavedCard> savedRegattas =
        List.generate(5, (index) => const SavedCard());
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: LandingPage(savedRegattas: savedRegattas)
        home: const BuildRegattaPage(),
        );

  }
}


