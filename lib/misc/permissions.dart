// import 'package:location/location.dart' as location;
// import 'package:permission_handler/permission_handler.dart';

// Future<void> requestLocationPermission() async {
//   // Check if location services are enabled
//   bool _serviceEnabled;
//   PermissionStatus _permissionStatus;

//   _serviceEnabled = await Permission.location.serviceStatus.isEnabled;
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.Location().requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }

//   // Check location permission
//   _permissionStatus = await Permission.location.request();
//   if (_permissionStatus.isDenied) {
//     return;
//   }

//   // Check background location permission
//     _permissionStatus = await Permission.locationAlways.request();
//   if (_permissionStatus.isDenied) {
//     return;
//   }
// }
