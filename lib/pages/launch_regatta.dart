import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';
import 'package:regatta_tracker2/misc/map_drawer.dart';
import 'package:regatta_tracker2/misc/mock_database.dart';
import 'package:regatta_tracker2/misc/tile_providers.dart';
import 'package:regatta_tracker2/widgets/map_widgets.dart';

class RegattaViewer extends StatelessWidget with MapControllHelper {
  final String regattaID;
  final Database db;

  late final Regatta regatta;
  late final Kurs kurs;

  final MapController _mapController = MapController();

  RegattaViewer({super.key, required this.regattaID, required this.db}) {
    regatta = Regatta.fromJson(db.regatten[regattaID]!);
    kurs = Kurs.fromJson(db.kurse[regattaID]!["0"]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(regatta.name),
      ),
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onMapReady: () {
              Future.delayed(const Duration(milliseconds: 400), () {
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
      ]),
    );
  }
}
