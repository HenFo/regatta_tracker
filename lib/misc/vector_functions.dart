import 'package:latlong2/latlong.dart';
import 'package:vector_math/vector_math.dart';

class VectorHelper {
  static double calculate_line_angle(LatLng p1, LatLng p2) {
    var line = Vector2(p1.longitude, p1.latitude) - Vector2(p2.longitude, p2.latitude);
    var y_axis = Vector2(0, 1);

    return line.angleTo(y_axis);
  }
}