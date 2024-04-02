import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    super.key,
    required this.savedRegattas,
  });

  final List<SavedCard> savedRegattas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(crossAxisCount: 2, children: savedRegattas),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ));
  }
}

class SavedCard extends StatelessWidget {
  const SavedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: Placeholder()),
            SizedBox(height: 10),
            Center(
              child: Text('Saved Card'),
            ),
          ],
        ),
      ),
    );
  }
}