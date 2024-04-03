import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

abstract class Boje {
  BojenTyp type;
  LatLng position;
  Widget get icon;

  Boje({required this.type, required this.position});

  static Widget baseIcon(BojenTyp type) {
    if (BojenTyp.startZiel.contains(type)) {
      return StartZielTonne.baseIcon(type);
    }
    return AblaufTonne.baseIcon(type);
  }

  factory Boje.fromType(BojenTyp type, LatLng position,
      {int nummer = 0, bool linksrundung = true, bool istZiel = true}) {
    if (BojenTyp.startZiel.contains(type)) {
      return StartZielTonne(type: type, position: position, istZiel: istZiel);
    }
    if (BojenTyp.ablauf.contains(type)) {
      return AblaufTonne(
          type: type,
          position: position,
          nummer: nummer,
          linksrundung: linksrundung);
    }
    throw Exception("Unknown type $type");
  }

  factory Boje.fromJson(Map<String, dynamic> json) {
    var type = BojenTyp.values[json['type']];
    if (BojenTyp.startZiel.contains(type)) {
      return StartZielTonne.fromJson(json);
    }
    if (BojenTyp.ablauf.contains(type)) {
      return AblaufTonne.fromJson(json);
    }
    throw Exception("Unknown type $type");
  }

  Map<String, dynamic> toJson() {
    if (BojenTyp.startZiel.contains(type)) {
      return (this as StartZielTonne).toJson();
    }
    if (BojenTyp.ablauf.contains(type)) {
      return (this as AblaufTonne).toJson();
    }
    throw Exception("Unknown type $type");
  }
}

class AblaufTonne extends Boje {
  int nummer;
  bool linksrundung;
  AblaufTonne(
      {required super.type,
      required super.position,
      this.nummer = 0,
      this.linksrundung = true});

  AblaufTonne.fromJson(Map<String, dynamic> json)
      : this(
          type: BojenTyp.values[json['type']],
          position: LatLng(json['position']['lat'], json['position']['lng']),
          nummer: json['nummer'],
          linksrundung: json['linksrundung'],
        );

  @override
  Widget get icon => _iconWithNummer(AblaufTonne.baseIcon(type));

  Widget _iconWithNummer(Widget icon) {
    return Stack(
      alignment: const AlignmentDirectional(0,0.75),
      children: [
        icon,
        Text(nummer.toString()),
      ],
    );
  }

  static Widget baseIcon(BojenTyp type) {
    switch (type) {
      case BojenTyp.ablaufTonne:
        return SvgPicture.asset(
          "assets/SVGs/ablauf.svg",
          semanticsLabel: "Ablauftonne",
        );
      case BojenTyp.luvTonne:
        return SvgPicture.asset(
          "assets/SVGs/ablauf.svg",
          semanticsLabel: "Luv Tonne",
        );
      case BojenTyp.leeTonne:
        return SvgPicture.asset(
          "assets/SVGs/ablauf.svg",
          semanticsLabel: "Lee Tonne",
        );
      default:
        throw Exception("$type not allowed in this class");
    }
  }
}

class StartZielTonne extends Boje {
  bool istZiel;
  StartZielTonne(
      {required super.type, required super.position, this.istZiel = true});

  StartZielTonne.fromJson(Map<String, dynamic> json)
      : this(
          type: BojenTyp.values[json['type']],
          position: LatLng(json['position']['lat'], json['position']['lng']),
          istZiel: json['istZiel'],
        );

  @override
  Widget get icon => StartZielTonne.baseIcon(type);

  static Widget baseIcon(BojenTyp type) {
    switch (type) {
      case BojenTyp.startschiff:
        return SvgPicture.asset(
          "assets/SVGs/startschiff.svg",
          semanticsLabel: "Startschiff",
        );
      case BojenTyp.pinEnd:
        return SvgPicture.asset(
          "assets/SVGs/pin-end.svg",
          semanticsLabel: "Pin End",
        );
      case BojenTyp.zielTonne:
        return SvgPicture.asset(
          "assets/SVGs/goal.svg",
          semanticsLabel: "Zieltonne",
        );
      default:
        throw Exception("$type not allowed in this class");
    }
  }
}

enum BojenTyp {
  ablaufTonne(name: "Ablauftonne"),
  luvTonne(name: "Luv-Tonne"),
  leeTonne(name: "Lee-Tonne"),
  startschiff(name: "Startschiff"),
  pinEnd(name: "Pin-End"),
  zielTonne(name: "Ziel");

  const BojenTyp({required this.name});

  final String name;

  static List<BojenTyp> get ablauf {
    return [
      ablaufTonne,
      luvTonne,
      leeTonne,
    ];
  }

  static List<BojenTyp> get startZiel {
    return [
      zielTonne,
      pinEnd,
      startschiff,
    ];
  }
}
