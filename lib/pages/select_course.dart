import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';

class SelectCourseTypePage extends StatelessWidget {
  const SelectCourseTypePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kursart"),
      ),
      body: GridView.count(crossAxisCount: 2, children: [
        KursCard(image: Kurs.getKursImage<UpAndDownKurs>()),
        KursCard(image: Kurs.getKursImage<UpAndDownWithGateKurs>()),
      ],)
    );
  }
}

class KursCard extends StatelessWidget {
  final Image image;
  const KursCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: image
      ),
    );;
  }
}