import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';
import 'package:regatta_tracker2/misc/mock_database.dart';
import 'package:regatta_tracker2/pages/select_course.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    super.key,
    required this.database,
  });

  final Database database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
              crossAxisCount: 2, children: _getSaveCards(database.regatten)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectCourseTypePage()));
            var (name as String, k as Kurs) = result;
            Regatta r = Regatta(name);
            print(name);
            print(k.compelte);
          },
          child: const Icon(Icons.add),
        ));
  }

  List<SavedCard> _getSaveCards(RegattaDbEntry regattenAsJson) {
    return regattenAsJson.values
        .map((regatta) => SavedCard(regatta: Regatta.fromJson(regatta)))
        .toList(growable: false);
  }
}

class SavedCard extends StatelessWidget {
  final Regatta regatta;
  const SavedCard({super.key, required this.regatta});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
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
                Text(regatta.standort ?? ""),
                Text(
                    "${regatta.startDatum.day}.${regatta.startDatum.month}.${regatta.startDatum.year} - ${regatta.endDatum.day}.${regatta.endDatum.month}.${regatta.endDatum.year}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
