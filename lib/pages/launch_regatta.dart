import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';
import 'package:regatta_tracker2/misc/map_drawer.dart';
import 'package:regatta_tracker2/misc/mock_database.dart';
import 'package:regatta_tracker2/misc/tile_providers.dart';
import 'package:regatta_tracker2/widgets/animated_bottom_drawer.dart';
import 'package:regatta_tracker2/widgets/map_widgets.dart';

class RegattaPage extends StatelessWidget {
  final String regattaID;
  final Database database;

  late final Regatta regatta;
  late final Kurs kurs;

  RegattaPage({super.key, required this.regattaID, required this.database}) {
    regatta = Regatta.fromJson(database.regatten[regattaID]!);
    kurs = Kurs.fromJson(database.kurse[regattaID]!["0"]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(regatta.name),
      ),
      body: Stack(
        children: [
          RegattaMapViewer(kurs: kurs),
          RegattaController(
            dragHandleHeight: 30,
            child: ListView.builder(
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    ColoredBox(color: Colors.yellow, child: Text(i.toString())),
              ),
              itemCount: 30,
            ),
          )
        ],
      ),
      extendBody: true,
    );
  }
}

class RegattaMapViewer extends StatelessWidget with MapControllHelper {
  final Kurs kurs;
  final MapController _mapController = MapController();

  RegattaMapViewer({super.key, required this.kurs});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onMapReady: () {
            Future.delayed(const Duration(milliseconds: 500), () {
              fitToCourse(_mapController, kurs);
            });
          },
          initialCenter: const LatLng(0, 0),
          initialZoom: 1,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
          interactionOptions: const InteractionOptions(
              rotationThreshold: 10, enableMultiFingerGestureRace: true),
        ),
        children: [
          openStreetMapTileLayer,
          // openSeaMapMarkersTileLayer,
          PolylineLayer(polylines: MapDrawer.linesFromBojen(kurs)),
          MarkerLayer(
            markers: MapDrawer.drawKursMarker(kurs),
            rotate: true,
          ),
          // CurrentLocationLayer(),
        ],
      ),
      MapControllButtons(mapController: _mapController, kurs: kurs)
    ]);
  }
}
