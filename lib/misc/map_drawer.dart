import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';

class MapDrawer {
  static Marker markerFromBoje(Boje boje) {
    return Marker(
        width: 30, height: 30, point: boje.position, child: boje.icon);
  }
  
  static List<Marker> markerFromBojen(List<Boje> boje) {
    return boje.map(markerFromBoje).toList(growable: false);
  }

  static List<Polyline> linesFromBojen(List<Boje> bojen) {
    List<Polyline> lines = [];
    // draw start line
    Polyline? startingLine = MapDrawer.startFinishLineFromBojen(bojen);
    if (startingLine != null) lines.add(startingLine);

    return lines;
  }

  static Polyline? startFinishLineFromBojen(List<Boje> bojen) {
    List<StartZielTonne> startline = bojen.where((element) => BojenTyp.startZiel.contains(element.type)).toList(growable: false).cast<StartZielTonne>();

    if (startline.length == 2) {
      var [p1, p2] = startline;
      if (p1.istZiel && p2.istZiel) {
        return Polyline(points: [p1.position, p2.position], strokeWidth: 10, color: Colors.white);
      }
      return Polyline(points: [p1.position, p2.position], isDotted: true);
    }
    return null;
  }
}
