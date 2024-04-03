import 'package:latlong2/latlong.dart';
import 'package:vector_math/vector_math.dart';

class VectorHelper {
  static double calculateLineAngle(LatLng p1, LatLng p2) {
    var line = vectorFromCoordinates(p1, p2);
    var yAxis = Vector2(0, 1);

    return line.angleTo(yAxis);
  }

  static Vector2 vectorFromCoordinates(LatLng p1, LatLng p2) {
    return Vector2(p1.longitude, p1.latitude) - Vector2(p2.longitude, p2.latitude);
  }

  static Vector2 getOrthogonalWithTarget(LatLng p1, LatLng p2, LatLng target) {
    // determine if target lies on the left or right side of the line
    // var d = (target.longitude - p1.longitude) * (p2.latitude - p1.latitude) - (target.latitude - p1.latitude) * (p2.longitude - p1.longitude);
    var line = vectorFromCoordinates(p1, p2);
    var targetVec = Vector2(target.longitude, target.latitude);
    var angle = line.angleToSigned(targetVec);
    if (angle > 0) {
      return Vector2(-line.y, line.x);
    }
    return Vector2(line.y, -line.x);
  }

  static Vector2 getOrthogonal(Vector2 vec) {
    return Vector2(-vec.y, vec.x);
  }
}