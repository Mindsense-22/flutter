import 'package:flutter/material.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/games/logic/game_engine.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class GamificationProvider extends ChangeNotifier {
  // ─── Persisted Keys ──────────────────────────────────────────────────────
  static const _kXp = 'gamif_xp';
  static const _kPoints = 'gamif_points';
  static const _kStreak = 'gamif_streak';
  static const _kLastPlayed = 'gamif_last_played';
  static const _kSessions = 'gamif_sessions';

  // ─── State ───────────────────────────────────────────────────────────────
  int _xp = 0;
  int _points = 0;
  int _streakDays = 0;
  DateTime? _lastPlayed;
  List<GameSession> _sessions = [];
  GameSpec? _activeSpec;
  bool _justLeveledUp = false;
  int _previousLevel = 1;

  // ─── Getters ─────────────────────────────────────────────────────────────
  int get xp => _xp;
  int get points => _points;
  int get streakDays => _streakDays;
  DateTime? get lastPlayed => _lastPlayed;
  List<GameSession> get recentSessions => _sessions.take(10).toList();
  GameSpec? get activeSpec => _activeSpec;

  int get level => GameEngine.calculateLevel(_xp);
  double get xpProgress => GameEngine.xpProgress(_xp);
  int get xpForNext => GameEngine.xpForNextLevel(level);
  int get xpSinceLevel => _xp - GameEngine.xpForCurrentLevel(level);

  bool get justLeveledUp => _justLeveledUp;
  bool get hasInactivityAlert =>
      _lastPlayed != null &&
      DateTime.now().difference(_lastPlayed!).inHours >= 24;

  // ─── Init ─────────────────────────────────────────────────────────────────
  GamificationProvider() {
    _load();
  }

  void _load() {
    _xp = SharedPreferencesitem.getInt(_kXp) ?? 0;
    _points = SharedPreferencesitem.getInt(_kPoints) ?? 0;
    _streakDays = SharedPreferencesitem.getInt(_kStreak) ?? 0;

    final lastStr = SharedPreferencesitem.getString(_kLastPlayed);
    _lastPlayed = lastStr != null ? DateTime.tryParse(lastStr) : null;

    final sessionsStr = SharedPreferencesitem.getString(_kSessions);
    _sessions =
        sessionsStr != null ? GameSession.decodeList(sessionsStr) : [];

    _previousLevel = level;
  }

  Future<void> _save() async {
    await SharedPreferencesitem.setInt(_kXp, _xp);
    await SharedPreferencesitem.setInt(_kPoints, _points);
    await SharedPreferencesitem.setInt(_kStreak, _streakDays);
    if (_lastPlayed != null) {
      await SharedPreferencesitem.setString(
          _kLastPlayed, _lastPlayed!.toIso8601String());
    }
    // Keep only last 50 sessions
    final trimmed = _sessions.take(50).toList();
    await SharedPreferencesitem.setString(
        _kSessions, GameSession.encodeList(trimmed));
  }

  // ─── Game Completion ─────────────────────────────────────────────────────
  Future<bool> completeGame(GameSpec spec, int rawScore) async {
    final oldLevel = level;
    _justLeveledUp = false;

    // Streak logic
    final now = DateTime.now();
    if (_lastPlayed == null) {
      _streakDays = 1;
    } else {
      final lastDate = DateTime(
          _lastPlayed!.year, _lastPlayed!.month, _lastPlayed!.day);
      final todayDate = DateTime(now.year, now.month, now.day);
      final diff = todayDate.difference(lastDate).inDays;
      if (diff == 0) {
        // already played today – no streak change
      } else if (diff == 1) {
        _streakDays += 1;
      } else {
        _streakDays = 1; // broken
      }
    }
    _lastPlayed = now;

    // XP & Points
    _xp += spec.xpReward;
    _points += spec.pointsReward;

    // Session record
    final session = GameSession(
      gameTypeName: spec.gameType.name,
      emotion: spec.emotion,
      score: rawScore,
      xpEarned: spec.xpReward,
      pointsEarned: spec.pointsReward,
      playedAt: now,
      difficulty: spec.difficulty.name,
    );
    _sessions.insert(0, session);

    // Level-up check
    if (level > oldLevel) {
      _justLeveledUp = true;
    }
    _previousLevel = level;

    await _save();
    notifyListeners();
    return _justLeveledUp;
  }

  // ─── Game Recommendation ─────────────────────────────────────────────────
  GameSpec generateRecommendation(String emotion, double confidence) {
    final energy = GameEngine.inferEnergy(confidence);
    final spec = GameEngine.generateSpec(
      emotion: emotion.toLowerCase(),
      energyLevel: energy,
      pastSessions: _sessions,
      streakDays: _streakDays,
    );
    _activeSpec = spec;
    notifyListeners();
    return spec;
  }

  void setActiveSpec(GameSpec spec) {
    _activeSpec = spec;
    notifyListeners();
  }

  void clearJustLeveledUp() {
    _justLeveledUp = false;
  }

  // ─── Streak Milestone Check ───────────────────────────────────────────────
  bool isStreakMilestone() {
    return [3, 7, 14, 30].contains(_streakDays);
  }
}
