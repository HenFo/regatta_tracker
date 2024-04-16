import 'package:flutter/widgets.dart';
import 'package:regatta_tracker2/HelperClasses/bojen.dart';
import 'package:regatta_tracker2/misc/vector_functions.dart';
import 'package:vector_math/vector_math.dart';

sealed class Kurs {
  Kurs();

  Vector2 direction = Vector2(0, 1);

  abstract final bool startEqualFinish;
  List<BojenTyp> get allowedTypes;
  List<Boje> get bojen;
  List<StartZielTonne>? get startingLine;
  List<StartZielTonne>? get finishLine;
  bool get compelte;

  static Image getKursImage<T extends Kurs>() {
    return switch (T) {
      const (UpAndDownWithGateKurs) =>
        Image.asset("assets/kurse/images/UpDownGate.png"),
      const (UpAndDownKurs) => 
        Image.asset("assets/kurse/images/UpDown.png"),
      _ => throw UnimplementedError(),
    };
  }

  double get courseAngleInRadians => direction.angleToSigned(Vector2(0, 1));

  void addBoje(Boje boje);
  void removeBoje(Boje boje);
  Map<String, dynamic> toJson();

  factory Kurs.fromJson(Map<String, dynamic> map) {
    if (map case {"type": String type}) {
      return switch (type) {
        "UpAndDownKurs" => UpAndDownKurs.fromJson(map),
        "UpAndDownWithGateKurs" => UpAndDownWithGateKurs.fromJson(map),
        _ => throw Exception("invalid json map")
      };
    }
    throw Exception("Kurs type missing");
  }
}

class UpAndDownKurs extends Kurs {
  AblaufTonne? luv;
  AblaufTonne? lee;
  AblaufTonne? ablauf;

  StartZielTonne? pinend;
  StartZielTonne? schiff;

  @override
  final bool startEqualFinish = true;

  UpAndDownKurs({this.luv, this.lee, this.ablauf, this.pinend, this.schiff}) {
    _calcDirection();
  }

  factory UpAndDownKurs.fromJson(Map<String, dynamic> map) {
    if (map
        case {
          "type": "UpAndDownKurs",
          "luv": Map<String, dynamic> luv,
          "lee": Map<String, dynamic> lee,
          "ablauf": Map<String, dynamic>? ablauf,
          "pinend": Map<String, dynamic> pinend,
          "schiff": Map<String, dynamic> schiff
        }) {
      return UpAndDownKurs(
          luv: AblaufTonne.fromJson(luv),
          lee: AblaufTonne.fromJson(lee),
          ablauf: ablauf == null ? null : AblaufTonne.fromJson(ablauf),
          schiff: StartZielTonne.fromJson(schiff),
          pinend: StartZielTonne.fromJson(pinend));
    }
    throw Exception("invalid json map");
  }

  set _setLuv(AblaufTonne boje) {
    luv = boje;
    luv!.nummer = 1;
  }

  set _setLee(AblaufTonne boje) {
    lee = boje;
    lee!.nummer = ablauf == null ? 2 : 3;
  }

  set _setAblauf(AblaufTonne boje) {
    ablauf = boje;
    ablauf!.nummer = 2;
    lee?.nummer = 3;
  }

  set _setPinend(StartZielTonne boje) {
    pinend = boje;
    pinend!.istZiel = true;
  }

  set _setSchiff(StartZielTonne boje) {
    schiff = boje;
    schiff!.istZiel = true;
  }

  @override
  void addBoje(Boje boje) {
    switch (boje.type) {
      case BojenTyp.luvTonne:
        _setLuv = boje as AblaufTonne;
        break;
      case BojenTyp.leeTonne:
        _setLee = boje as AblaufTonne;
        break;
      case BojenTyp.ablaufTonne:
        _setAblauf = boje as AblaufTonne;
        break;
      case BojenTyp.pinEnd:
        _setPinend = boje as StartZielTonne;
        break;
      case BojenTyp.startschiff:
        _setSchiff = boje as StartZielTonne;
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
      return VectorHelper.getOrthogonalToPoints(
          schiff!.position, pinend!.position);
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

  @override
  void removeBoje(Boje boje) {
    switch (boje.type) {
      case BojenTyp.luvTonne:
        luv = null;
        break;
      case BojenTyp.leeTonne:
        lee = null;
        break;
      case BojenTyp.ablaufTonne:
        ablauf = null;
        lee?.nummer = 2;
        break;
      case BojenTyp.pinEnd:
        pinend = null;
        break;
      case BojenTyp.startschiff:
        schiff = null;
        break;
      default:
        print("Boje nicht verfügbar");
        return;
    }
  }

  @override
  bool get compelte =>
      [luv, lee, pinend, schiff].every((element) => element != null);

  @override
  Map<String, dynamic> toJson() {
    if (compelte) {
      return {
        "type": "UpAndDownKurs",
        "luv": luv!.toJson(),
        "lee": lee!.toJson(),
        "ablauf": ablauf!.toJson(),
        "pinend": pinend!.toJson(),
        "schiff": schiff!.toJson()
      };
    }
    throw Exception("Kurs is not complete");
  }

  @override
  Image get kursImage => Image.asset("assets/kurse/images/UpDown.png");
}

class UpAndDownWithGateKurs extends UpAndDownKurs {
  AblaufTonne? lee2;

  UpAndDownWithGateKurs(
      {super.luv,
      super.lee,
      this.lee2,
      super.ablauf,
      super.pinend,
      super.schiff}) {
    _calcDirection();
  }

  factory UpAndDownWithGateKurs.fromJson(Map<String, dynamic> map) {
    if (map
        case {
          "type": "UpAndDownWithGateKurs",
          "luv": Map<String, dynamic> luv,
          "lee": Map<String, dynamic> lee,
          "lee2": Map<String, dynamic> lee2,
          "ablauf": Map<String, dynamic>? ablauf,
          "pinend": Map<String, dynamic> pinend,
          "schiff": Map<String, dynamic> schiff
        }) {
      return UpAndDownWithGateKurs(
          luv: AblaufTonne.fromJson(luv),
          lee: AblaufTonne.fromJson(lee),
          lee2: AblaufTonne.fromJson(lee2),
          ablauf: ablauf == null ? null : AblaufTonne.fromJson(ablauf),
          schiff: StartZielTonne.fromJson(schiff),
          pinend: StartZielTonne.fromJson(pinend));
    }
    throw Exception("invalid json map");
  }

  @override
  Map<String, dynamic> toJson() {
    if (compelte) {
      Map<String, dynamic> json = super.toJson();
      json["type"] = "UpAndDownWithGateKurs";
      json["lee2"] = lee2!.toJson();
      return json;
    }
    throw Exception("Kurs is not complete");
  }

  @override
  List<Boje> get bojen =>
      [luv, lee, lee2, ablauf, pinend, schiff].nonNulls.toList(growable: false);

  @override
  bool get compelte =>
      [luv, lee, lee2, pinend, schiff].every((element) => element != null);

  @override
  set _setLee(AblaufTonne boje) {
    if (lee != null) {
      lee2 = boje;
      lee2!.nummer = ablauf == null ? 2 : 3;
    } else {
      lee = boje;
      lee!.nummer = ablauf == null ? 2 : 3;
    }
  }

  @override
  set _setAblauf(AblaufTonne boje) {
    super._setAblauf = boje;
    lee2?.nummer = 3;
  }

  @override
  void removeBoje(Boje boje) {
    switch (boje.type) {
      case BojenTyp.leeTonne:
        if (boje == lee) {
          lee = null;
        } else if (boje == lee2) {
          lee2 = null;
        }
        break;
      case BojenTyp.ablaufTonne:
        ablauf = null;
        lee?.nummer = 2;
        lee2?.nummer = 2;
        break;
      default:
        super.removeBoje(boje);
    }
  }

  @override
  Image get kursImage => Image.asset("assets/kurse/images/UpDownGate.png");
}
