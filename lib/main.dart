import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/pages/create_regatta.dart';
import 'package:regatta_tracker2/pages/landing_page.dart';

import 'misc/mock_database.dart';
import 'pages/select_course.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Database database = Database.fromJson({
    "regatten": <String, RegattaDbEntry>{
      "Test2024-04-1919:31:03.6616272024-04-1919:31:03.661630": {
        "name": "Test",
        "owner": "ICH",
        "startDatum": "2024-04-19T19:31:03.661627",
        "endDatum": "2024-04-19T19:31:03.661630",
        "standort": "",
        "teilnehmer": <String, bool>{}
      }
    },
    "runden": <String, RundeDbEntry>{},
    "kurse": <String, KursDbEntry>{
      "Test2024-04-1919:31:03.6616272024-04-1919:31:03.661630": {
        "0": {
          "type": "UpAndDownKurs",
          "luv": {
            "type": 1,
            "position": {"lat": 53.50797807327919, "lng": 12.674407431019182},
            "nummer": 1,
            "linksrundung": true
          },
          "lee": {
            "type": 2,
            "position": {"lat": 53.50409851817683, "lng": 12.658770640136737},
            "nummer": 3,
            "linksrundung": true
          },
          "ablauf": {
            "type": 0,
            "position": {"lat": 53.50855347944245, "lng": 12.66941364550783},
            "nummer": 2,
            "linksrundung": true
          },
          "pinend": {
            "type": 4,
            "position": {"lat": 53.506920048011324, "lng": 12.664170170720904},
            "istZiel": true
          },
          "schiff": {
            "type": 3,
            "position": {"lat": 53.503671559802626, "lng": 12.667228864346606},
            "istZiel": true
          }
        }
      }
    },
    "user": <String, UserDbEntry>{},
    "tracks": <String, TrackDbEntry>{},
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LandingPage(database: database)
        // home: const BuildRegattaPage()
        // home: const SelectCourseTypePage()
        );
  }
}
