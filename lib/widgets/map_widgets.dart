import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';

class MapControllButtons extends StatefulWidget {
  final MapController mapController;
  final Kurs kurs;
  const MapControllButtons(
      {super.key, required this.mapController, required this.kurs});

  @override
  State<MapControllButtons> createState() => _MapControllButtonsState();
}

class _MapControllButtonsState extends State<MapControllButtons> {
  bool locationOn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<MapEvent>(
                stream: widget.mapController.mapEventStream,
                builder: (context, snapshot) {
                  return Transform.rotate(
                      angle: snapshot.data?.camera.rotationRad ?? 0,
                      child: IconButton.filled(
                        onPressed: _toggleOrientation,
                        icon: const Icon(Icons.north),
                      ));
                }),
            IconButton.filled(
              onPressed: _fitToCourse,
              icon: const Icon(Icons.fullscreen),
            ),
            IconButton.filled(
              onPressed: () {
                // TODO aktuelle Position anzeigen
                if (locationOn) {
                  setState(() {
                    locationOn = false;
                  });
                } else {
                  setState(() {
                    locationOn = true;
                  });
                }
              },
              icon: Icon(locationOn
                  ? Icons.location_disabled
                  : Icons.location_searching),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.question_mark),
            ),
          ],
        ),
      ),
    );
  }

  void _fitToCourse() {
    var positions = widget.kurs.bojen.map((e) => e.position).toList();
    var camFit = CameraFit.coordinates(
        coordinates: positions, padding: const EdgeInsets.all(50));
    _rotateToCourseDirection();
    widget.mapController.fitCamera(camFit);
  }

  void _toggleOrientation() {
    if (widget.mapController.camera.rotation == 0) {
      _rotateToCourseDirection();
    } else {
      widget.mapController.rotate(0);
    }
  }

  void _rotateToCourseDirection() {
    var courseAngle = widget.kurs.courseAngleInRadians;
    widget.mapController.rotate(360 - courseAngle * 180 / pi);
  }
}
