import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:vector_math/vector_math.dart';

class VectorHelper {
  static final ProjectionTuple transform =
      ProjectionTuple(fromProj: Projection.WGS84, toProj: Projection.GOOGLE);

  static double calculateLineAngle(LatLng p1, LatLng p2) {
    var line = vectorFromCoordinates(p1, p2);
    var yAxis = Vector2(0, 1);

    return line.angleTo(yAxis);
  }

  static Vector2 vectorFromCoordinates(LatLng p1, LatLng p2) {
    return _vectorFromLatLng(p1) - _vectorFromLatLng(p2);
  }

  static Vector2 _vectorFromLatLng(LatLng p) {
    var cartPoint = transform.forward(Point(x: p.longitude, y: p.latitude));
    return Vector2(cartPoint.x, cartPoint.y);
  }

  static Vector2 getOrthogonalWithTarget(LatLng p1, LatLng p2, LatLng target) {
    var line = vectorFromCoordinates(p1, p2);
    var targetVec = vectorFromCoordinates(p1, target);
    var angle = line.angleToSigned(targetVec);
    if (angle > 0) {
      return Vector2(line.y, -line.x);
    }
    return Vector2(-line.y, line.x);
  }

  static Vector2 getOrthogonal(Vector2 vec) {
    return Vector2(-vec.y, vec.x);
  }

  static Vector2 getOrthogonalToPoints(LatLng p1, LatLng p2) {
    return getOrthogonal(vectorFromCoordinates(p1, p2));
  }
}
