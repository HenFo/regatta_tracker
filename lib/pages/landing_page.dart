import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';
import 'package:regatta_tracker2/misc/mock_database.dart';
import 'package:regatta_tracker2/pages/launch_regatta.dart';
import 'package:regatta_tracker2/pages/select_course.dart';

typedef CardTapedCallback = void Function(String regattaId);
class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
    required this.database,
  });

  final Database database;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
              crossAxisCount: 2,
              children: _buildSaveCardsFromRegattaEntries(widget.database.regatten)),
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
    // TODO owner setzen
    Regatta r = Regatta(name, "ICH");
    setState(() {
      widget.database.regatten[r.id] = r.toJson();
    });
    widget.database.kurse[r.id] = {"0": k.toJson()};
  }

  List<SavedCard> _buildSaveCardsFromRegattaEntries(RegattaDbEntry regattenAsJson) {
    return regattenAsJson.values
        .map((regattaJson) => Regatta.fromJson(regattaJson))
        .map((regatta) => SavedCard(regatta: regatta, callback: _onCardPressedCallback))
        .toList(growable: false)
      ..sort((a, b) => -a.regatta.startDatum.compareTo(b.regatta.startDatum));
  }

  void _onCardPressedCallback(String regattaId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegattaViewer(regattaID: regattaId, db:widget.database)));
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
