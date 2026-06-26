class GamificationPastSession {
  final String gameName;
  final String gameType;
  final String emotion;
  final int score;
  final int xpEarned;
  final DateTime date;

  const GamificationPastSession({
    required this.gameName,
    required this.gameType,
    required this.emotion,
    required this.score,
    required this.xpEarned,
    required this.date,
  });

  factory GamificationPastSession.fromJson(Map<String, dynamic> json) {
    return GamificationPastSession(
      gameName: json['game_name'] as String,
      gameType: json['game_type'] as String,
      emotion: json['emotion'] as String,
      score: json['score'] as int,
      xpEarned: json['xp_earned'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class GamificationProfile {
  final int xp;
  final int points;
  final int streakDays;
  final DateTime? lastPlayed;
  final List<GamificationPastSession> pastSessions;

  const GamificationProfile({
    required this.xp,
    required this.points,
    required this.streakDays,
    this.lastPlayed,
    required this.pastSessions,
  });

  factory GamificationProfile.fromJson(Map<String, dynamic> json) {
    final rawSessions = json['past_sessions'] as List<dynamic>? ?? [];
    return GamificationProfile(
      xp: json['xp'] as int,
      points: json['points'] as int,
      streakDays: json['streak_days'] as int,
      lastPlayed: json['last_played'] != null
          ? DateTime.parse(json['last_played'] as String)
          : null,
      pastSessions: rawSessions
          .map((e) => GamificationPastSession.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
