import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
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
  Kurs kurs = UpAndDownWithGateKurs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(53.509166, 12.668727),
          initialZoom: 14,
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
          // openStreetMapTileLayer,
          // openSeaMapMarkersTileLayer,
          PolylineLayer(polylines: MapDrawer.linesFromBojen(kurs)),
          MarkerLayer(markers: MapDrawer.markerFromBojen(kurs, onDoubleTapCallback: _removeBoje)),
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
        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              // spacing: 8.0,
              runSpacing: 4.0,
              children: [
                for (BojenTyp type in kurs.allowedTypes)
                  _getButton(context, type, latlng)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getButton(BuildContext context, BojenTyp type, LatLng latlng) {
    return ElevatedButton(
      onPressed: () {
        _addBoje(type, latlng);
        Navigator.pop(context);
      },
      child: Row(
        children: [
          SizedBox(width:20, height: 20, child: Boje.baseIcon(type)),
          const SizedBox(width: 4,),
          Expanded(child: Text(type.name)),
        ],
      ),
    );
  }

  void _addBoje(BojenTyp type, LatLng latlng) {
    setState(() {
      kurs.addBoje(Boje.fromType(type, latlng));
      print(latlng);
    });
  }

  void _removeBoje(Boje boje) {
    setState(() {
      kurs.removeBoje(boje);
    });
  }
}
