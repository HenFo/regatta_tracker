import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class Boje {
  BojenTyp type;
  LatLng position;

  Boje({required this.type, required this.position});

  factory Boje.fromType(BojenTyp type, LatLng position, {int nummer = 0, bool linksrundung = true, bool istZiel = true}) {
    if (BojenTyp.startZiel.contains(type)) {
      return StartZielTonne(type: type, position: position, istZiel: istZiel);
    }
    if (BojenTyp.ablauf.contains(type)) {
      return AblaufTonne(type: type, position: position, nummer: nummer, linksrundung: linksrundung);
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

  Icon get icon {
    switch (type) {
      case BojenTyp.ablaufTonne:
        return const Icon(Icons.directions_boat);
      case BojenTyp.luvTonne:
        return const Icon(Icons.directions_boat);
      case BojenTyp.leeTonne:
        return const Icon(Icons.directions_boat);
      case BojenTyp.startschiff:
        return const Icon(Icons.directions_boat);
      case BojenTyp.pinEnd:
        return const Icon(Icons.directions_boat);
      case BojenTyp.zielTonne:
        return const Icon(Icons.directions_boat);
    }
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
  AblaufTonne({required super.type, required super.position, this.nummer = 0, this.linksrundung = true});

  AblaufTonne.fromJson(Map<String, dynamic> json) : this(
    type : BojenTyp.values[json['type']],
    position : LatLng(json['position']['lat'], json['position']['lng']),
    nummer : json['nummer'],
    linksrundung: json['linksrundung'],
  );

}

class StartZielTonne extends Boje {
  bool istZiel;
  StartZielTonne({required super.type, required super.position, this.istZiel = true});
  
  StartZielTonne.fromJson(Map<String, dynamic> json) : this(
    type : BojenTyp.values[json['type']],
    position : LatLng(json['position']['lat'], json['position']['lng']),
    istZiel : json['istZiel'],
  );
}


class Boje1 {
  BojenTyp type;
  LatLng position;
  int? nummer;
  bool linksrundung;
  bool istZiel;
  late Icon icon;

  Boje1(this.type, this.position, this.nummer, this.linksrundung, this.istZiel) {
    icon = _getIcon(type);
  }

  Boje1.ablaufTonne(LatLng position,
      {int? nummer, bool linksrundung = true, bool istZiel = false})
      : this(BojenTyp.ablaufTonne, position, nummer, linksrundung, istZiel);
  Boje1.luvTonne(LatLng position,
      {int? nummer, bool linksrundung = true, bool istZiel = false})
      : this(BojenTyp.luvTonne, position, nummer, linksrundung, istZiel);
  Boje1.leeTonne(LatLng position,
      {int? nummer, bool linksrundung = true, bool istZiel = false})
      : this(BojenTyp.leeTonne, position, nummer, linksrundung, istZiel);
  Boje1.startschiff(LatLng position,
      {int? nummer, bool linksrundung = false, bool istZiel = true})
      : this(BojenTyp.startschiff, position, nummer, linksrundung, istZiel);
  Boje1.pinEnd(LatLng position,
      {int? nummer, bool linksrundung = false, bool istZiel = true})
      : this(BojenTyp.pinEnd, position, nummer, linksrundung, istZiel);
  Boje1.zielBoje(LatLng position,
      {int? nummer, bool linksrundung = false, bool istZiel = true})
      : this(BojenTyp.zielTonne, position, nummer, linksrundung, istZiel);

  Boje1.fromJson(Map<String, dynamic> json)
      : this(
            BojenTyp.values[json['type']],
            LatLng(json['position']['lat'], json['position']['lng']),
            json['nummer'],
            json['linksrundung'],
            json['istZiel']);

  Icon _getIcon(BojenTyp type) {
    switch (type) {
      case BojenTyp.ablaufTonne:
        return const Icon(Icons.directions_boat);
      case BojenTyp.luvTonne:
        return const Icon(Icons.directions_boat);
      case BojenTyp.leeTonne:
        return const Icon(Icons.directions_boat);
      case BojenTyp.startschiff:
        return const Icon(Icons.directions_boat);
      case BojenTyp.pinEnd:
        return const Icon(Icons.directions_boat);
      case BojenTyp.zielTonne:
        return const Icon(Icons.directions_boat);
    }
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'position': {
        'lat': position.latitude,
        'lng': position.longitude,
      },
      'nummer': nummer,
      'linksrundung': linksrundung,
      'istZiel': istZiel,
    };
  }
}

enum BojenTyp {
  ablaufTonne,
  luvTonne,
  leeTonne,
  startschiff,
  pinEnd,
  zielTonne;

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
