import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/gamefication_service.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/games/logic/game_engine.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';
import 'package:mindsense_app/features/games/models/gamification_model.dart';

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
  bool _isLoading = false;
  String? _error;

  // ─── Getters ─────────────────────────────────────────────────────────────
  int get xp => _xp;
  int get points => _points;
  int get streakDays => _streakDays;
  DateTime? get lastPlayed => _lastPlayed;
  List<GameSession> get recentSessions => _sessions.take(10).toList();
  GameSpec? get activeSpec => _activeSpec;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
    _loadFromCache();
  }

  /// Load cached values from SharedPreferences on startup.
  void _loadFromCache() {
    _xp = SharedPreferencesitem.getInt(_kXp) ?? 0;
    _points = SharedPreferencesitem.getInt(_kPoints) ?? 0;
    _streakDays = SharedPreferencesitem.getInt(_kStreak) ?? 0;

    final lastStr = SharedPreferencesitem.getString(_kLastPlayed);
    _lastPlayed = lastStr != null ? DateTime.tryParse(lastStr) : null;

    final sessionsStr = SharedPreferencesitem.getString(_kSessions);
    _sessions = sessionsStr != null ? GameSession.decodeList(sessionsStr) : [];
  }

  /// Persist current state to SharedPreferences.
  Future<void> _saveToCache() async {
    await SharedPreferencesitem.setInt(_kXp, _xp);
    await SharedPreferencesitem.setInt(_kPoints, _points);
    await SharedPreferencesitem.setInt(_kStreak, _streakDays);
    if (_lastPlayed != null) {
      await SharedPreferencesitem.setString(
          _kLastPlayed, _lastPlayed!.toIso8601String());
    }
    // Keep only last 50 sessions
    await SharedPreferencesitem.setString(
        _kSessions, GameSession.encodeList(_sessions.take(50).toList()));
  }

  /// Apply a [GamificationProfile] received from the API to local state.
  void _applyProfile(GamificationProfile profile) {
    _xp = profile.xp;
    _points = profile.points;
    _streakDays = profile.streakDays;
    _lastPlayed = profile.lastPlayed;

    // Merge API past_sessions into local GameSession list (prepend, dedup by date)
    final apiSessions = profile.pastSessions.map((s) => GameSession(
          gameTypeName: s.gameName, // Use gameName (e.g. "Focus") so substring matching works 
          emotion: s.emotion,
          score: s.score,
          xpEarned: s.xpEarned,
          pointsEarned: 0, // not returned by API
          playedAt: s.date,
          difficulty: "unknown", // not returned by API
        )).toList();

    _sessions = apiSessions;
  }

  // ─── API: Fetch Profile ───────────────────────────────────────────────────
  /// Fetches the user's gamification profile from the server and syncs state.
  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await GameficationService.getProfile();
      final oldLevel = level;

      _applyProfile(profile);
      _justLeveledUp = level > oldLevel;

      await _saveToCache();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── API: Complete Game ───────────────────────────────────────────────────
  /// Records a completed game via the API, then syncs the returned profile.
  /// Returns true if the user leveled up.
  Future<bool> completeGame(GameSpec spec, int rawScore) async {
    final oldLevel = level;
    _justLeveledUp = false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await GameficationService.completeGame(
        gameName: spec.gameType.displayName,
        gameType: spec.gameType.name,
        emotion: spec.emotion,
        score: rawScore,
        xpEarned: spec.xpReward,
      );

      _applyProfile(profile);
      _justLeveledUp = level > oldLevel;

      await _saveToCache();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ─── Streak Milestone Check ───────────────────────────────────────────────
  bool isStreakMilestone() {
    return [3, 7, 14, 30].contains(_streakDays);
  }
}
