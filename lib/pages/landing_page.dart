import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';
import 'package:regatta_tracker2/misc/type_definitions.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    super.key,
    required this.meineRegatten,
  });

  final Map<String, RegattaDbEntry> meineRegatten;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
              crossAxisCount: 2, children: _getSaveCards(meineRegatten)),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
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
                Text(regatta.standort),
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
