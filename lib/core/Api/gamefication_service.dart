import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/features/games/models/gamification_model.dart';

class GameficationService {
  static String apiMessage = "";

  /// GET /api/v1/gamification
  /// Fetches the user's gamification profile (xp, points, streak_days, last_played, past_sessions).
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

  /// POST /api/v1/gamification/complete
  /// Records a completed game, awards XP, and updates streak.
  /// Returns the updated [GamificationProfile].
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
}