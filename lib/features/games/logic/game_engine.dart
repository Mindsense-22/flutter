import 'dart:math';
import 'package:mindsense_app/features/games/models/game_models.dart';

class GameEngine {
  static final Random _rng = Random();

  static const Map<String, List<GameType>> _tagMap = {
    'sad-low': [GameType.cloudBreathing],
    'sad-medium': [GameType.memoryMatch],
    'sad-high': [GameType.memoryMatch, GameType.wordBuilder],
    'anxious-low': [GameType.cloudBreathing],
    'anxious-medium': [GameType.balloonPop],
    'anxious-high': [GameType.sortingStorm],
    'happy-low': [GameType.wordBuilder, GameType.focusFlow],
    'happy-medium': [GameType.wordBuilder],
    'happy-high': [GameType.speedTap],
    'angry-low': [GameType.iceBreaker],
    'angry-medium': [GameType.iceBreaker],
    'angry-high': [GameType.iceBreaker],
    'neutral-low': [GameType.cloudBreathing, GameType.focusFlow],
    'neutral-medium': [GameType.focusFlow],
    'neutral-high': [GameType.patternChain],
  };
  static EnergyLevel inferEnergy(double confidence) {
    if (confidence >= 70) return EnergyLevel.high;
    if (confidence >= 40) return EnergyLevel.medium;
    return EnergyLevel.low;
  }

  
  static GameSpec generateSpec({
    required String emotion,
    required EnergyLevel energyLevel,
    required List<GameSession> pastSessions,
    int streakDays = 0,
  }) {
    final tag = '${emotion.toLowerCase()}-${energyLevel.name}';

    List<GameType> candidates = List<GameType>.from(
      _tagMap[tag] ?? _tagMap['neutral-medium']!,
    );

    final recentTypes = pastSessions
        .take(3)
        .map((s) => s.gameType)
        .toSet();

    final filtered = candidates
        .where((g) => !recentTypes.contains(g))
        .toList();

    if (filtered.isNotEmpty) candidates = filtered;

    final chosen = candidates[_rng.nextInt(candidates.length)];

    final diffRoll = _rng.nextDouble();
    final difficulty = diffRoll < 0.30
        ? DifficultyLevel.easy
        : diffRoll < 0.80
            ? DifficultyLevel.medium
            : DifficultyLevel.hard;

    final baseXp = chosen.baseXp;
    final multiplier = _streakMultiplier(streakDays);
    final diffMultiplier = difficulty == DifficultyLevel.hard
        ? 1.5
        : difficulty == DifficultyLevel.medium
            ? 1.0
            : 0.75;

    final xpReward = (baseXp * multiplier * diffMultiplier).round();
    final pointsReward = (xpReward * 2.5).round();

    return GameSpec(
      gameType: chosen,
      difficulty: difficulty,
      xpReward: xpReward,
      pointsReward: pointsReward,
      emotion: emotion,
      energyLevel: energyLevel,
    );
  }

  static double _streakMultiplier(int streakDays) {
    if (streakDays >= 30) return 2.0;
    if (streakDays >= 14) return 1.75;
    if (streakDays >= 7) return 1.5;
    if (streakDays >= 3) return 1.25;
    return 1.0;
  }

  // ─── Level Calculation ────

  static int calculateLevel(int totalXp) {
    int level = 1;
    while ((level * level * 100) <= totalXp) {
      level++;
    }
    return level - 1 < 1 ? 1 : level - 1;
  }

  /// XP required to reach the next level from current level.
  static int xpForNextLevel(int currentLevel) {
    return (currentLevel + 1) * (currentLevel + 1) * 100;
  }

  /// XP required to reach the current level.
  static int xpForCurrentLevel(int currentLevel) {
    if (currentLevel <= 1) return 0;
    return currentLevel * currentLevel * 100;
  }

  /// Progress (0.0 → 1.0) within the current level.
  static double xpProgress(int totalXp) {
    final level = calculateLevel(totalXp);
    final start = xpForCurrentLevel(level);
    final end = xpForNextLevel(level);
    if (end <= start) return 1.0;
    return ((totalXp - start) / (end - start)).clamp(0.0, 1.0);
  }
}
