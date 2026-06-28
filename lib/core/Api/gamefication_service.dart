import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/features/games/models/gamification_model.dart';

class GameficationService {
  static String apiMessage = "";

  
  static Future<GamificationProfile> getProfile() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.gamificationProfile,
      );
      final data = response.data as Map<String, dynamic>;
      return GamificationProfile.fromJson(data['data']['gamification'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to fetch gamification profile";
      throw apiMessage;
    }
  }

  
  static Future<GamificationProfile> completeGame({
    required String gameName,
    required String gameType,
    required String emotion,
    required int score,
    required int xpEarned,
    int? bonusXp,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "game_name": gameName,
        "game_type": gameType,
        "emotion": emotion,
        "score": score,
        "xp_earned": xpEarned,
        if (bonusXp != null) "bonus_xp": bonusXp,
      };

      final response = await DioFactory.postData(
        path: ApiConstants.gamificationComplete,
        data: data,
      );
      final responseData = response.data as Map<String, dynamic>;
      return GamificationProfile.fromJson(responseData['data']['gamification'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to record completed game";
      throw apiMessage;
    }
  }

  /// Fetches the leaderboard for a given [period].
  /// [period] can be "weekly", "monthly", or "allTime".
  static Future<List<LeaderboardEntry>> getLeaderboard({
    String period = "weekly",
  }) async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.leaderboard,
        queryParameters: {"period": period},
      );
      final data = response.data as Map<String, dynamic>;
      final rawList = data['data'] as List<dynamic>;
      return rawList
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to fetch leaderboard";
      throw apiMessage;
    }
  }
}