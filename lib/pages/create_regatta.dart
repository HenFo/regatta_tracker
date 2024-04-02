import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';
import 'package:regatta_tracker2/misc/map_drawer.dart';
import 'package:regatta_tracker2/misc/tile_providers.dart';

class BuildRegattaPage extends StatefulWidget {
  const BuildRegattaPage({
    super.key,
  });

  @override
  State<BuildRegattaPage> createState() => _BuildRegattaPageState();
}

class _BuildRegattaPageState extends State<BuildRegattaPage> {
  List<Boje> bojen = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(51.5, 7.8),
          initialZoom: 5,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
          interactionOptions: const InteractionOptions(
              rotationThreshold: 10, enableMultiFingerGestureRace: true),
          onLongPress: (pos, latlng) => _bottomSheet(context, latlng),
        ),
        children: [
          openStreetMapTileLayer,
          openSeaMapMarkersTileLayer,
          PolylineLayer(polylines: MapDrawer.linesFromBojen(bojen)),
          MarkerLayer(markers: MapDrawer.markerFromBojen(bojen)),
        ],
      ),
    );
  }

  Future<dynamic> _bottomSheet(BuildContext context, LatLng latlng) {
    return showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _addBoje(BojenTyp.startschiff, latlng);
                      Navigator.pop(context);
                    },
                    child: const Text('Startschiff'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addBoje(BojenTyp.pinEnd, latlng);
                      Navigator.pop(context);
                    },
                    child: const Text('Pin-End'),
                  ),
                ],
              ),
            );
          },
        );
  }

  void _addBoje(BojenTyp type, LatLng latlng) {
    setState(() {
      bojen.add(Boje.fromType(BojenTyp.startschiff, latlng));
    });
  }
}
