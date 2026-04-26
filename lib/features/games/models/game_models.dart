import 'dart:convert';

// ─── Enums ───────────────────────────────────────────────────────────────────

enum GameType {
  cloudBreathing,
  memoryMatch,
  balloonPop,
  sortingStorm,
  speedTap,
  wordBuilder,
  iceBreaker,
  focusFlow,
  patternChain,
}

enum EnergyLevel { low, medium, high }

enum DifficultyLevel { easy, medium, hard }

// ─── Game Type Helpers ────────────────────────────────────────────────────────

extension GameTypeExtension on GameType {
  String get displayName {
    switch (this) {
      case GameType.cloudBreathing:
        return 'Cloud Breathing';
      case GameType.memoryMatch:
        return 'Memory Match';
      case GameType.balloonPop:
        return 'Balloon Pop';
      case GameType.sortingStorm:
        return 'Sorting Storm';
      case GameType.speedTap:
        return 'Speed Tap';
      case GameType.wordBuilder:
        return 'Word Builder';
      case GameType.iceBreaker:
        return 'Ice Breaker';
      case GameType.focusFlow:
        return 'Focus Flow';
      case GameType.patternChain:
        return 'Pattern Chain';
    }
  }

  String get emoji {
    switch (this) {
      case GameType.cloudBreathing:
        return '☁️';
      case GameType.memoryMatch:
        return '🃏';
      case GameType.balloonPop:
        return '🎈';
      case GameType.sortingStorm:
        return '🌀';
      case GameType.speedTap:
        return '⚡';
      case GameType.wordBuilder:
        return '🔤';
      case GameType.iceBreaker:
        return '🧊';
      case GameType.focusFlow:
        return '🎯';
      case GameType.patternChain:
        return '🔮';
    }
  }

  String get goal {
    switch (this) {
      case GameType.cloudBreathing:
        return 'Calm your mind with guided breathing';
      case GameType.memoryMatch:
        return 'Match positive emoji pairs to boost mood';
      case GameType.balloonPop:
        return 'Release tension by popping balloons';
      case GameType.sortingStorm:
        return 'Sort emotions to regain mental clarity';
      case GameType.speedTap:
        return 'Boost focus with rapid target tapping';
      case GameType.wordBuilder:
        return 'Spell positive words to shift mindset';
      case GameType.iceBreaker:
        return 'Release anger, then reset with breathing';
      case GameType.focusFlow:
        return 'Train attention with the Stroop challenge';
      case GameType.patternChain:
        return 'Sharpen memory with sequence patterns';
    }
  }

  String get duration {
    switch (this) {
      case GameType.cloudBreathing:
        return '3 min';
      case GameType.memoryMatch:
        return '3 min';
      case GameType.balloonPop:
        return '2 min';
      case GameType.sortingStorm:
        return '2 min';
      case GameType.speedTap:
        return '90 sec';
      case GameType.wordBuilder:
        return '2 min';
      case GameType.iceBreaker:
        return '3 min';
      case GameType.focusFlow:
        return '2 min';
      case GameType.patternChain:
        return '3 min';
    }
  }

  int get baseXp {
    switch (this) {
      case GameType.cloudBreathing:
        return 30;
      case GameType.memoryMatch:
        return 40;
      case GameType.balloonPop:
        return 35;
      case GameType.sortingStorm:
        return 45;
      case GameType.speedTap:
        return 35;
      case GameType.wordBuilder:
        return 40;
      case GameType.iceBreaker:
        return 50;
      case GameType.focusFlow:
        return 45;
      case GameType.patternChain:
        return 50;
    }
  }

  String get name => toString().split('.').last;
}

// ─── Game Spec ────────────────────────────────────────────────────────────────

class GameSpec {
  final GameType gameType;
  final DifficultyLevel difficulty;
  final int xpReward;
  final int pointsReward;
  final String emotion;
  final EnergyLevel energyLevel;

  const GameSpec({
    required this.gameType,
    required this.difficulty,
    required this.xpReward,
    required this.pointsReward,
    required this.emotion,
    required this.energyLevel,
  });
}

// ─── Game Session ─────────────────────────────────────────────────────────────

class GameSession {
  final String gameTypeName;
  final String emotion;
  final int score;
  final int xpEarned;
  final int pointsEarned;
  final DateTime playedAt;
  final String difficulty;

  const GameSession({
    required this.gameTypeName,
    required this.emotion,
    required this.score,
    required this.xpEarned,
    required this.pointsEarned,
    required this.playedAt,
    required this.difficulty,
  });

  GameType get gameType {
    return GameType.values.firstWhere(
      (e) => e.name == gameTypeName,
      orElse: () => GameType.cloudBreathing,
    );
  }

  Map<String, dynamic> toJson() => {
        'gameTypeName': gameTypeName,
        'emotion': emotion,
        'score': score,
        'xpEarned': xpEarned,
        'pointsEarned': pointsEarned,
        'playedAt': playedAt.toIso8601String(),
        'difficulty': difficulty,
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        gameTypeName: json['gameTypeName'] as String,
        emotion: json['emotion'] as String,
        score: json['score'] as int,
        xpEarned: json['xpEarned'] as int,
        pointsEarned: json['pointsEarned'] as int,
        playedAt: DateTime.parse(json['playedAt'] as String),
        difficulty: json['difficulty'] as String,
      );

  static String encodeList(List<GameSession> sessions) =>
      jsonEncode(sessions.map((s) => s.toJson()).toList());

  static List<GameSession> decodeList(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => GameSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
