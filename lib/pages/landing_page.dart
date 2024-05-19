import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';
import 'package:regatta_tracker2/misc/database.dart';
import 'package:regatta_tracker2/pages/launch_regatta.dart';
import 'package:regatta_tracker2/pages/select_course.dart';

typedef CardTapedCallback = void Function(String regattaId);

class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Regatta> myRegattas = [];

  @override
  void initState() {
    auth.FirebaseAuth.instance.authStateChanges().listen((auth.User? user) {
      if (user == null) {
        return;
      }
      String userID = user.uid;
      FirebaseDatabase.instance
          .ref("user/$userID")
          .onChildAdded
          .listen((event) async {
        print("childevent");
        List<RegattaDbEntry> newEntries =
            await Database.getRegattenOfUser(FirebaseDatabase.instance, userID);
        var newRegatten =
            newEntries.map((e) => Regatta.fromJson(e)).toList(growable: false);

        setState(() {
          myRegattas = newRegatten;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
              crossAxisCount: 2,
              children: _buildSaveCardsFromRegattaEntries(myRegattas)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectCourseTypePage()));
            var (name as String, k as Kurs) = result;
            _saveToDatabase(name, k);
          },
          child: const Icon(Icons.add),
        ));
  }

  void _saveToDatabase(String name, Kurs k) {
    String uid = auth.FirebaseAuth.instance.currentUser!.uid;
    Regatta r = Regatta(name, uid);
    final db = FirebaseDatabase.instance;
    final rRef = Database.addRegatta(db, r);
    Database.addKurs(db, rRef.key!, k);
  }

  List<SavedCard> _buildSaveCardsFromRegattaEntries(
      List<Regatta> regattenAsJson) {
    return regattenAsJson
        .map((regatta) =>
            SavedCard(regatta: regatta, callback: _onCardPressedCallback))
        .toList(growable: false)
      ..sort((a, b) => -a.regatta.startDatum.compareTo(b.regatta.startDatum));
  }

  void _onCardPressedCallback(String regattaId) {
    print("card $regattaId tapped");
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             RegattaPage(regattaID: regattaId, database: widget.database)));
  }
}

class SavedCard extends StatelessWidget {
  final Regatta regatta;
  final CardTapedCallback callback;
  const SavedCard({super.key, required this.regatta, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(regatta.id),
      child: Card(
        color: Colors.amber,
        // color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Expanded(child: Placeholder()),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(regatta.name),
                  Text(regatta.standort),
                  Text(
                      "${regatta.startDatum.day}.${regatta.startDatum.month}.${regatta.startDatum.year} - ${regatta.endDatum.day}.${regatta.endDatum.month}.${regatta.endDatum.year}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
