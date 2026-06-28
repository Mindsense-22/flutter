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

class LeaderboardReputation {
  final int supportScore;
  final int consistency;
  final int contribution;
  final int helpful;
  final int trust;
  final int level;

  const LeaderboardReputation({
    required this.supportScore,
    required this.consistency,
    required this.contribution,
    required this.helpful,
    required this.trust,
    required this.level,
  });

  factory LeaderboardReputation.fromJson(Map<String, dynamic> json) {
    return LeaderboardReputation(
      supportScore: json['supportScore'] as int? ?? 0,
      consistency: json['consistency'] as int? ?? 0,
      contribution: json['contribution'] as int? ?? 0,
      helpful: json['helpful'] as int? ?? 0,
      trust: json['trust'] as int? ?? 50,
      level: json['level'] as int? ?? 1,
    );
  }
}

class LeaderboardEntry {
  final String id;
  final String name;
  final GamificationProfile? gamification;
  final LeaderboardReputation? reputation;

  const LeaderboardEntry({
    required this.id,
    required this.name,
    this.gamification,
    this.reputation,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    GamificationProfile? gamification;
    if (json['gamification'] != null) {
      gamification = GamificationProfile.fromJson(
        json['gamification'] as Map<String, dynamic>,
      );
    }

    LeaderboardReputation? reputation;
    final communityProfile = json['communityProfile'] as Map<String, dynamic>?;
    if (communityProfile != null && communityProfile['reputation'] != null) {
      reputation = LeaderboardReputation.fromJson(
        communityProfile['reputation'] as Map<String, dynamic>,
      );
    }

    return LeaderboardEntry(
      id: json['_id'] as String,
      name: json['name'] as String,
      gamification: gamification,
      reputation: reputation,
    );
  }
}
