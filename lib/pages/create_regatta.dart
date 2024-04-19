import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/misc/map_drawer.dart';
import 'package:regatta_tracker2/misc/tile_providers.dart';
import 'package:regatta_tracker2/widgets/map_widgets.dart';

class BuildRegattaPage extends StatefulWidget {
  final Kurs kurs;

  const BuildRegattaPage({
    super.key,
    required this.kurs,
  });

  @override
  State<BuildRegattaPage> createState() => _BuildRegattaPageState();
}

class _BuildRegattaPageState extends State<BuildRegattaPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // requestLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
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
            openStreetMapTileLayer,
            // openSeaMapMarkersTileLayer,
            PolylineLayer(polylines: MapDrawer.linesFromBojen(widget.kurs)),
            MarkerLayer(
              markers: MapDrawer.drawKursMarker(widget.kurs,
                  onDoubleTapCallback: _removeBoje),
              rotate: true,
            ),
            // CurrentLocationLayer(),
          ],
        ),
        MapControllButtons(mapController: _mapController, kurs: widget.kurs)
      ]),
      floatingActionButton: ExpandableFab(
        // pos: ExpandableFabPos.right,
        type: ExpandableFabType.fan,
        distance: 160,
        openButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.add), shape: const CircleBorder()),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close), shape: const CircleBorder()),
        children: [
          for (var type in widget.kurs.allowedTypes) _getAtPositionButton(type)
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      bottomNavigationBar: _bottomAppBar(context),
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  alignment: Alignment.center,
                  minimumSize: Size.infinite,
                  elevation: 0,
                  shape: const BeveledRectangleBorder(),
                  foregroundColor: Colors.white),
              child: const Text("Abbrechen"),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: widget.kurs.compelte
                  ? () => _onSaveButtonPressed(context)
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  alignment: Alignment.center,
                  minimumSize: Size.infinite,
                  elevation: 0,
                  shape: const BeveledRectangleBorder(),
                  foregroundColor: Colors.white),
              child: const Text("Erstellen"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    // if (widget.kurs.compelte) {
    Navigator.pop(context, "Test");
    // } else {
    //   _showCourseIncopleteDialog(context);
    // }
  }

  // Future<dynamic> _showCourseIncopleteDialog(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Error'),
  //       content: const Text("Der Kurs ist noch nicht vollständig"),
  //       actions: [
  //         TextButton(
  //           child: const Text('OK'),
  //           onPressed: () => Navigator.pop(context),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Future<dynamic> _bottomSheet(BuildContext context, LatLng latlng) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              // spacing: 8.0,
              runSpacing: 4.0,
              children: [
                for (BojenTyp type in widget.kurs.allowedTypes)
                  _getDrawerButton(context, type, latlng)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getDrawerButton(BuildContext context, BojenTyp type, LatLng latlng) {
    return ElevatedButton(
      onPressed: () {
        _addBoje(type, latlng);
        Navigator.pop(context);
      },
      child: Row(
        children: [
          SizedBox(width: 20, height: 20, child: Boje.baseIcon(type)),
          const SizedBox(
            width: 4,
          ),
          Expanded(child: Text(type.name)),
        ],
      ),
    );
  }

  Widget _getAtPositionButton(BojenTyp type) {
    String? label = BojenTyp.ablauf.contains(type)
        ? type.name.substring(0, 3).toUpperCase()
        : null;
    return IconButton.filledTonal(
      onPressed: () {
        // TODO getPosition
        var position = const LatLng(53.509166, 12.668727);
        _addBoje(type, position);
      },
      icon: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 30, height: 30, child: Boje.baseIcon(type)),
        if (label != null)
          Container(
              color: const Color.fromARGB(180, 255, 255, 255),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(label))
      ]),
    );
  }

  void _addBoje(BojenTyp type, LatLng latlng) {
    setState(() {
      widget.kurs.addBoje(Boje.fromType(type, latlng));
      print(latlng);
    });
  }

  void _removeBoje(Boje boje) {
    setState(() {
      widget.kurs.removeBoje(boje);
    });
  }
}
