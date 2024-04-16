import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/pages/create_regatta.dart';
import 'package:regatta_tracker2/pages/landing_page.dart';

import 'misc/type_definitions.dart';
import 'pages/select_course.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Map<String, Map<String, dynamic>> database = {
    "regatten": <String, RegattaDbEntry>{
      "Training": {
        "name": "Training",
        "standort": "Aasee",
        "startDatum": "2024-10-01",
        "endDatum": "2024-10-02",
        "teilnehmer": <String, bool>{}
      },
      "Training2": {
        "name": "Training",
        "standort": "Aasee",
        "startDatum": "2024-10-01",
        "endDatum": "2024-10-02",
        "teilnehmer": <String, bool>{}
      },
      "Training3": {
        "name": "Training",
        "standort": "Aasee",
        "startDatum": "2024-10-01",
        "endDatum": "2024-10-02",
        "teilnehmer": <String, bool>{}
      },
      "Training4": {
        "name": "Training",
        "standort": "Aasee",
        "startDatum": "2024-10-01",
        "endDatum": "2024-10-02",
        "teilnehmer": <String, bool>{}
      }
    },
    "runden": <String, RundeDbEntry>{},
    "kurse": <String, KursDbEntry>{},
    "user": <String, UserDbEntry>{},
    "tracks": <String, TrackDbEntry>{},
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: LandingPage(
        //     meineRegatten: database["regatten"] as Map<String, RegattaDbEntry>)
        // home: const BuildRegattaPage()
        home: const SelectCourseTypePage()
        );
  }
}


