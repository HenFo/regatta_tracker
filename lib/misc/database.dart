import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_tracker2/HelperClasses/kurs.dart';
import 'package:regatta_tracker2/HelperClasses/regatta.dart';

typedef RegattaDbEntry = Map<String, dynamic>;
typedef RundeDbEntry = Map<int, Map<String, dynamic>>;
typedef KursDbEntry = Map<String, Map<String, dynamic>>;
typedef UserDbEntry = Map<String, Map<String, bool>>;
typedef TrackDbEntry = Map<String, Map<int, Map<String, dynamic>>>;


class Database {
  final Map<String, RegattaDbEntry> regatten;
  final Map<String, RundeDbEntry> runden;
  final Map<String, KursDbEntry> kurse;
  final Map<String, UserDbEntry> user;
  final Map<String, TrackDbEntry> tracks;

  Database(
      {this.regatten = const {},
      this.runden = const {},
      this.kurse = const {},
      this.user = const {},
      this.tracks = const {}});

  Database.fromJson(Map json)
      : regatten = json['regatten'] as Map<String, RegattaDbEntry>,
        runden = json['runden'] as Map<String, RundeDbEntry>,
        kurse = json['kurse'] as Map<String, KursDbEntry>,
        user = json['user'] as Map<String, UserDbEntry>,
        tracks = json['tracks'] as Map<String, TrackDbEntry>;

  static Future<List<RegattaDbEntry>> getRegattenOfUser(
      FirebaseDatabase db, String userId) async {
    try {
      final userRef = db.ref('user/$userId/hasAccess');
      final userSnapshot = await userRef.get();
      final regattaIDs =
          (userSnapshot.value as Map).keys;
      final List<RegattaDbEntry> regattas = await Future.wait(regattaIDs.map(
          (id) async => await db
              .ref("regatten/$id")
              .once()
              .then((event) => RegattaDbEntry.from(event.snapshot.value! as Map))));

      return regattas;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  static DatabaseReference addRegatta(
      FirebaseDatabase db, Regatta regatta) {
    final ref = db.ref("regatten");
    final regattaRef = ref.push();
    final rid = regattaRef.key!;
    regatta.id = rid;
    regattaRef.set(regatta.toJson());
    setAsOwner(db, regatta.owner, rid);
    return regattaRef;
  }

  static Future<DatabaseReference> setAsOwner(
      FirebaseDatabase db, String userId, String regattaId) async {
    var userRef = db.ref("user/$userId/hasAccess");
    await userRef.update({"$regattaId/erstellt": true});
    return userRef;
  }

  static Future<DatabaseReference> teilnehmen(
      FirebaseDatabase db, String userID, String regattaID) async {
    var userRef = db.ref("user/$userID/hasAccess");
    await userRef.update({"$regattaID/teilnahme": true});
    return userRef;
  }

  static Future<DatabaseReference> addKurs(
      FirebaseDatabase db, String regattaID, Kurs kurs,
      {int runde = 0}) async {
    var ref = db.ref("kurse/$regattaID/$runde");
    await ref.set(kurs.toJson());
    return ref;
  }
}
