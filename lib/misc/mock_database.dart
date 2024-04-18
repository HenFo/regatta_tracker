typedef RegattaDbEntry = Map<String, dynamic>;
typedef RundeDbEntry = Map<int, Map<String, dynamic>>;
typedef KursDbEntry = Map<String, Map<String, dynamic>>;
typedef UserDbEntry = Map<String, bool>;
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
}
