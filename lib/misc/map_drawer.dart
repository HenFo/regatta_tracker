import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';

typedef BojeCallbackFunction = void Function(Boje);

class MapDrawer {
  static Marker markerFromBoje(Boje boje,
      {BojeCallbackFunction? onDoubleTapCallback}) {
    var iconWithGesture = GestureDetector(
      child: boje.icon,
      onDoubleTap: () =>
          onDoubleTapCallback != null ? onDoubleTapCallback(boje) : () => {},
    );

    if (boje.type == BojenTyp.pinEnd) {
      return Marker(
          width: 30,
          height: 30,
          point: boje.position,
          child: iconWithGesture,
          alignment: const Alignment(0, -0.5));
    }
    return Marker(
        width: 30, height: 30, point: boje.position, child: iconWithGesture);
  }

  static List<Marker> markerFromBojen(Kurs kurs,
      {BojeCallbackFunction? onDoubleTapCallback}) {
    return kurs.bojen
        .map((b) => markerFromBoje(b, onDoubleTapCallback: onDoubleTapCallback))
        .toList(growable: false);
  }

  static List<Polyline> linesFromBojen(Kurs kurs) {
    List<Polyline> lines = [];

    if (kurs.startingLine != null) {
      lines.add(startFinishLineFromBojen(kurs.startingLine!));
    }
    if (!kurs.startEqualFinish && kurs.finishLine != null) {
      lines.add(finishLineFromBojen(kurs.finishLine!));
    }

    return lines;
  }

  static Polyline startFinishLineFromBojen(List<StartZielTonne> bojen) {
    assert(bojen.length == 2);
    var [p1, p2] = bojen;
    if (p1.istZiel && p2.istZiel) {
      return Polyline(
          points: [p1.position, p2.position],
          strokeWidth: 2,
          color: Colors.white);
    }
    return Polyline(points: [p1.position, p2.position], isDotted: true);
  }

  static Polyline finishLineFromBojen(List<StartZielTonne> bojen) {
    assert(bojen.length == 2);
    assert(bojen.every((element) => element.istZiel));

    var [p1, p2] = bojen;
    if (p1.istZiel && p2.istZiel) {
      return Polyline(
          points: [p1.position, p2.position],
          strokeWidth: 2,
          color: Colors.red);
    }
    return Polyline(points: [p1.position, p2.position], isDotted: true);
  }
}
