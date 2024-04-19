import 'package:latlong2/latlong.dart';

final class Regatta {
  final String name;
  final String standort;
  final Map<String, bool> teilnehmer;
  final String owner;
  late DateTime startDatum;
  late DateTime endDatum;

  String get id =>
      (name + startDatum.toString() + endDatum.toString() + standort)
          .replaceAll(" ", "");

  Regatta(this.name, this.owner,
      {DateTime? startDatum,
      DateTime? endDatum,
      this.standort = "",
      this.teilnehmer = const {}}) {
    this.startDatum = startDatum ?? DateTime.now();
    this.endDatum = endDatum ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "owner": owner,
      "startDatum": startDatum.toIso8601String(),
      "endDatum": endDatum.toIso8601String(),
      "standort": standort,
      "teilnehmer": teilnehmer,
    };
  }

  Regatta.fromJson(Map<String, dynamic> map)
      : owner = map["owner"] as String,
        name = map["name"] as String,
        startDatum = DateTime.parse(map["startDatum"]),
        endDatum = DateTime.parse(map["endDatum"]),
        standort = map["standort"] as String,
        teilnehmer = map["teilnehmer"] as Map<String, bool>;
}

final class Runde {
  final String kursID;
  final DateTime startZeit;
  final Duration vorstartphase;

  Runde(this.kursID, this.startZeit, this.vorstartphase);

  Map<String, dynamic> toJson() {
    return {
      "kursID": kursID,
      "startZeit": startZeit.toIso8601String(),
      "vorstartphase": vorstartphase.inMinutes,
    };
  }

  Runde.fromJson(Map<String, dynamic> map)
      : kursID = map["kursID"],
        startZeit = DateTime.parse(map["startZeit"]),
        vorstartphase = Duration(minutes: map["vorstartphase"]);
}

final class User {
  final String name;
  final Map<String, bool> regatten;

  User(this.name, this.regatten);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "regatten": regatten,
    };
  }

  User.fromJson(Map<String, dynamic> map)
      : regatten = map["regatten"],
        name = map["name"];
}

final class Track {
  final List<TrackEntry> trackEntries;

  Track(this.trackEntries);

  String toCSV() {
    String header = "timestamp,latitude,longitude,heading,speed\n";
    var body = trackEntries.map((e) => e.toCSV()).join("\n");
    return header + body;
  }

  factory Track.fromCSV(String csv) {
    final lines = csv.split("\n");
    final body = lines.skip(1);
    final entries = body.map(TrackEntry.fromCSV).toList();
    return Track(entries);
  }
}

final class TrackEntry {
  final LatLng position;
  final double heading;
  final double speed;
  final DateTime timestamp;

  TrackEntry(this.timestamp, this.position, this.heading, this.speed);

  String toCSV() {
    return "$timestamp,${position.latitude},${position.longitude},$heading,$speed";
  }

  factory TrackEntry.fromCSV(String csv) {
    final parts = csv.split(",");
    return TrackEntry(
      DateTime.parse(parts[0]),
      LatLng(double.parse(parts[1]), double.parse(parts[2])),
      double.parse(parts[3]),
      double.parse(parts[4]),
    );
  }
}
