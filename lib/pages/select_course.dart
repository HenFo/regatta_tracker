import 'dart:async';

import 'package:flutter/material.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/pages/create_regatta.dart';

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
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            KursCard<UpAndDownKurs>(),
            KursCard<UpAndDownWithGateKurs>(),
          ],
        ));
  }
}

class KursCard<T extends Kurs> extends StatelessWidget {
  final Image image;
  KursCard({super.key}) : image = Kurs.getKursImage<T>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Kurs k = Kurs.create(T);
        final Completer completer = Completer();
        String name = await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BuildRegattaPage(kurs: k)),
            result: completer.future);
        completer.complete((name, k));
      },
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(padding: const EdgeInsets.all(8.0), child: image),
      ),
    );
  }
}
