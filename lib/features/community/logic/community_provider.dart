import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/community_service.dart';
import 'package:mindsense_app/features/community/models/community_model.dart';

class CommunityProvider extends ChangeNotifier {
  bool postisLoading = false;
  bool isFeedLoading = false;
  String? error;
  List<FeedPost> feedPosts = [];

  Future<void> fetchFeed({int page = 1, int limit = 10}) async {
    isFeedLoading = true;
    error = null;
    notifyListeners();

    try {
      final posts = await CommunityService.getFeed(page: page, limit: limit);
      feedPosts = posts;
      isFeedLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isFeedLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPost({
    required String type,
    required String content,
    required String visibility,
    String? circleId,
  }) async {
    if (content.isEmpty) {
      error = "Content cannot be empty.";
      notifyListeners();
      return false;
    }

    postisLoading = true;
    error = null;
    notifyListeners();

    try {
      final postData = {
        "type": type.toLowerCase(),
        "content": content,
        "visibility": visibility.toLowerCase(),
        if (circleId != null && circleId != 'Global') "circle": circleId,
      };

      final newPost = await CommunityService.createPost(postData: postData);
      
      // Insert new post at the top
      feedPosts.insert(0, newPost);
      
      postisLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      postisLoading = false;
      notifyListeners();
      return false;
    }
  }

}