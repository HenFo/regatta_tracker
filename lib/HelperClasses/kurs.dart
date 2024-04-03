import 'package:regatta_tracker2/HelperClasses/bojen.dart';
import 'package:regatta_tracker2/misc/vector_functions.dart';
import 'package:vector_math/vector_math.dart';

abstract class Kurs {

  Vector2 direction = Vector2(0, 1);

  bool get startEqualFinish;
  List<BojenTyp> get allowedTypes;
  List<Boje> get bojen;
  List<StartZielTonne>? get startingLine;
  List<StartZielTonne>? get finishLine;

  void addBoje(Boje boje);
}

class UpAndDownKurs extends Kurs {
  AblaufTonne? luv;
  AblaufTonne? lee;
  AblaufTonne? ablauf;

  StartZielTonne? pinend;
  StartZielTonne? schiff;

  @override
  bool get startEqualFinish => true;

  UpAndDownKurs();

  @override
  void addBoje(Boje boje) {
    switch (boje.type) {
      case BojenTyp.luvTonne:
        luv = boje as AblaufTonne;
        break;
      case BojenTyp.leeTonne:
        lee = boje as AblaufTonne;
        break;
      case BojenTyp.ablaufTonne:
        ablauf = boje as AblaufTonne;
        break;
      case BojenTyp.pinEnd:
        pinend = boje as StartZielTonne;
        break;
      case BojenTyp.startschiff:
        schiff = boje as StartZielTonne;
        break;
      default:
        print("Boje nicht verfügbar");
        return;
    }
    super.direction = _calcDirection();
  }

  @override
  List<Boje> get bojen =>
      [luv, lee, ablauf, pinend, schiff].nonNulls.toList(growable: false);

  Vector2 _calcDirection() {
    if (schiff != null && pinend != null) {
      if (luv != null) {
        return VectorHelper.getOrthogonalWithTarget(
            schiff!.position, pinend!.position, luv!.position);
      }
      if (lee != null) {
        var dir = VectorHelper.getOrthogonalWithTarget(
            schiff!.position, pinend!.position, lee!.position);
        return Vector2(-dir.x, -dir.y);
      }
    }
    return Vector2(0, 1);
  }

  @override
  List<StartZielTonne>? get finishLine => startingLine;

  @override
  List<StartZielTonne>? get startingLine =>
      schiff != null && pinend != null ? [schiff!, pinend!] : null;

  @override
  List<BojenTyp> get allowedTypes => [
        BojenTyp.luvTonne,
        BojenTyp.leeTonne,
        BojenTyp.ablaufTonne,
        BojenTyp.pinEnd,
        BojenTyp.startschiff
      ];
}
