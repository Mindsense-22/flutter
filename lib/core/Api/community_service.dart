import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/features/community/models/community_model.dart';

class CommunityService {
  static String apiMessage = "";

  // 8.1 Fetch Community Overview
  static Future<CommunityOverview> getOverview() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.communityOverview,
      );
      final data = response.data as Map<String, dynamic>;
      return CommunityOverview.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to fetch community overview";
      throw apiMessage;
    }
  }

  // 8.2 Fetch Feed
  static Future<List<FeedPost>> getFeed({int page = 1, int limit = 10}) async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.feed,
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final rawList = data['data'] as List<dynamic>;
      return rawList.map((e) => FeedPost.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to fetch feed";
      throw apiMessage;
    }
  }

  // 8.3 Create Post
  static Future<FeedPost> createPost({required Map<String, dynamic> postData}) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.feed,
        data: postData,
      );
      final data = response.data as Map<String, dynamic>;
      return FeedPost.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to create post";
      throw apiMessage;
    }
  }

  // 8.4 Update Post
  static Future<FeedPost> updatePost(String id, {required Map<String, dynamic> updateData}) async {
    try {
      final response = await DioFactory.patchData(
        path: "${ApiConstants.feed}/$id",
        data: updateData,
      );
      final data = response.data as Map<String, dynamic>;
      return FeedPost.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to update post";
      throw apiMessage;
    }
  }

  // 8.5 Delete Post
  static Future<Map<String, dynamic>> deletePost(String id) async {
    try {
      final response = await DioFactory.deleteData(
        path: "${ApiConstants.feed}/$id",
      );
      final data = response.data as Map<String, dynamic>;
      if (data['data'] == null) {
        return {};
      }
      return data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to delete post";
      throw apiMessage;
    }
  }

  // 8.6 React to Post
  static Future<FeedPost> reactToPost(String id, String type) async {
    try {
      final response = await DioFactory.postData(
        path: "${ApiConstants.feed}/$id/react",
        data: {"type": type},
      );
      final data = response.data as Map<String, dynamic>;
      return FeedPost.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to react to post";
      throw apiMessage;
    }
  }

  // 8.7 Save Post
  static Future<FeedPost> savePost(String id) async {
    try {
      final response = await DioFactory.postData(
        path: "${ApiConstants.feed}/$id/save",
        data: {},
      );
      final data = response.data as Map<String, dynamic>;
      return FeedPost.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to save post";
      throw apiMessage;
    }
  }

  // 8.8 Share Post
  static Future<FeedPost> sharePost(String id) async {
    try {
      final response = await DioFactory.postData(
        path: "${ApiConstants.feed}/$id/share",
        data: {},
      );
      final data = response.data as Map<String, dynamic>;
      return FeedPost.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to share post";
      throw apiMessage;
    }
  }

  // 8.9 Get Comments
  static Future<List<Comment>> getPostComments(String id) async {
    try {
      final response = await DioFactory.getData(
        path: "${ApiConstants.feed}/$id/comments",
      );
      final data = response.data as Map<String, dynamic>;
      final rawList = data['data'] as List<dynamic>;
      return rawList.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to fetch comments";
      throw apiMessage;
    }
  }

  // 8.10 Add Comment
  static Future<Comment> addPostComment(String id, String text) async {
    try {
      final response = await DioFactory.postData(
        path: "${ApiConstants.feed}/$id/comments",
        data: {"text": text},
      );
      final data = response.data as Map<String, dynamic>;
      return Comment.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to add comment";
      throw apiMessage;
    }
  }

  // 8.11 Report Content
  static Future<Map<String, dynamic>> reportContent(String targetId, String reason) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.communityReports,
        data: {
          "targetId": targetId,
          "reason": reason,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to report content";
      throw apiMessage;
    }
  }

  // 8.12 Get Health
  static Future<Map<String, dynamic>> getHealth() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.communityHealth,
      );
      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to fetch community health";
      throw apiMessage;
    }
  }
}