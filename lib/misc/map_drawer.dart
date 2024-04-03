import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';

class MapDrawer {
  static Marker markerFromBoje(Boje boje) {
    if (boje.type == BojenTyp.pinEnd) {
      return Marker(
          width: 30,
          height: 30,
          point: boje.position,
          child: boje.icon,
          alignment: const Alignment(0, -0.5));
    }
    return Marker(
        width: 30, height: 30, point: boje.position, child: boje.icon);
  }

  static List<Marker> markerFromBojen(List<Boje> bojen) {
    return bojen.map(markerFromBoje).toList(growable: false);
  }

  static List<Polyline> linesFromBojen(List<Boje> bojen) {
    List<Polyline> lines = [];
    
    Polyline? startingLine = MapDrawer.startFinishLineFromBojen(bojen);
    if (startingLine != null) lines.add(startingLine);
    Polyline? finishLine = MapDrawer.finishLineFromBojen(bojen);
    if (finishLine != null) lines.add(finishLine);

    return lines;
  }

  static Polyline? startFinishLineFromBojen(List<Boje> bojen) {
    List<StartZielTonne> startline = bojen
        .where((element) =>
            BojenTyp.startZiel.contains(element.type) &&
            element.type != BojenTyp.zielTonne)
        .toList(growable: false)
        .cast<StartZielTonne>();

    if (startline.length == 2) {
      var [p1, p2] = startline;
      if (p1.istZiel && p2.istZiel) {
        return Polyline(
            points: [p1.position, p2.position],
            strokeWidth: 2,
            color: Colors.white);
      }
      return Polyline(points: [p1.position, p2.position], isDotted: true);
    }
    return null;
  }
  
  static Polyline? finishLineFromBojen(List<Boje> bojen) {
    List<StartZielTonne> finishLine = bojen
        .where((element) =>
            element.type == BojenTyp.zielTonne)
        .toList(growable: false)
        .cast<StartZielTonne>();

    if (finishLine.length == 2) {
      var [p1, p2] = finishLine;
      if (p1.istZiel && p2.istZiel) {
        return Polyline(
            points: [p1.position, p2.position],
            strokeWidth: 2,
            color: Colors.red);
      }
      return Polyline(points: [p1.position, p2.position], isDotted: true);
    }
    return null;
  }
}
