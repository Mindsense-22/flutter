import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/community_service.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/features/community/models/community_model.dart';

class CommunityProvider extends ChangeNotifier {
  bool postisLoading = false;
  bool isFeedLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  int _currentPage = 1;
  static const int _pageLimit = 10;

  String? error;
  List<FeedPost> feedPosts = [];

  /// Fetches page 1 and replaces the list (used on first load & pull-to-refresh)
  Future<void> fetchFeed() async {
    isFeedLoading = true;
    error = null;
    _currentPage = 1;
    hasMore = true;
    notifyListeners();

    try {
      final posts = await CommunityService.getFeed(page: 1, limit: _pageLimit);
      feedPosts = posts;
      hasMore = posts.length >= _pageLimit;
      isFeedLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isFeedLoading = false;
      notifyListeners();
    }
  }

  /// Appends the next page to the list (pagination / infinite scroll)
  Future<void> loadMoreFeed() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final posts = await CommunityService.getFeed(page: nextPage, limit: _pageLimit);
      if (posts.isNotEmpty) {
        _currentPage = nextPage;
        feedPosts = [...feedPosts, ...posts];
        hasMore = posts.length >= _pageLimit;
      } else {
        hasMore = false;
      }
      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoadingMore = false;
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

  Future<bool> updatePost({
    required String postId,
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
      final updateData = {
        "type": type.toLowerCase(),
        "content": content,
        "visibility": visibility.toLowerCase(),
        if (circleId != null && circleId != 'Global') "circle": circleId,
      };

      final updatedPost = await CommunityService.updatePost(
        postId,
        updateData: updateData,
      );

      final index = feedPosts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        feedPosts[index] = updatedPost;
      }

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

  Future<bool> deletePost(context,String postId) async {
    if (postId.isEmpty) {
      error = "Post id is required.";
      notifyListeners();
      return false;
    }

    postisLoading = true;
    error = null;
    notifyListeners();

    try {
      await CommunityService.deletePost(postId);
      feedPosts.removeWhere((post) => post.id == postId);
      postisLoading = false;
      customSnackbar(context, false, "Post Deleted");
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      postisLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> reportPost(context,String postId) async {
    if (postId.isEmpty) {
      error = "Post id is required.";
      notifyListeners();
      return false;
    }

    postisLoading = true;
    error = null;
    notifyListeners();

    try {
      await CommunityService.reportContent(postId,"Spam");      
      postisLoading = false;
      customSnackbar(context, false, "Post Reported");
      log("Post Reported");
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      postisLoading = false;
      log("Post not Reported");
      log(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> sharePost(context,String postId) async {
    if (postId.isEmpty) {
      error = "Post id is required.";
      notifyListeners();
      return false;
    }

    postisLoading = true;
    error = null;
    notifyListeners();

    try {
      await CommunityService.sharePost(postId,);      
      postisLoading = false;
      customSnackbar(context, false, "Post Shared");
      log("Post Shared");
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      postisLoading = false;
      log("Post not Shared");
      log(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> savePost(context,String postId) async {
    if (postId.isEmpty) {
      error = "Post id is required.";
      notifyListeners();
      return false;
    }

    postisLoading = true;
    error = null;
    notifyListeners();

    try {
      await CommunityService.savePost(postId,);      
      postisLoading = false;
      customSnackbar(context, false, "Post Saved");
      log("Post Saved");
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      postisLoading = false;
      log("Post not Saved");
      log(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> reaactPost(context,String postId) async {
    if (postId.isEmpty) {
      error = "Post id is required.";
      notifyListeners();
      return false;
    }

    postisLoading = true;
    error = null;
    notifyListeners();

    try {
      await CommunityService.reactToPost(postId,"support");      
      postisLoading = false;
      customSnackbar(context, false, "Post supported");
      log("Post supported");
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      postisLoading = false;
      log("Post not supported");
      log(e.toString());
      notifyListeners();
      return false;
    }
  }

  List<Comment> comments = [];
  bool commentsIsLoading = false;
  String? commenterror;
  /// Tracks how many comments were added locally per post (postId → delta)
  Map<String, int> commentCountDeltas = {};
  Future<List<Comment>?> getPostComments(String postId) async {
    if (postId.isEmpty) {
      error = "Post id is required.";
      notifyListeners();
      return null;
    }

    commentsIsLoading = true;
    error = null;
    notifyListeners();

    try {
      comments = await CommunityService.getPostComments(postId);

      commentsIsLoading = false;
      log("Comments fetched successfully");
      notifyListeners();

      return comments;
    } catch (e) {
      error = e.toString();
      commentsIsLoading = false;

      log("Failed to fetch comments");
      log(e.toString());

      notifyListeners();
      return null;
    }
  }

  bool addCommentIsLoading = false;
  String? addCommentError;
  var commentContrroller=TextEditingController();
  Future<Comment?> addComment(context,String postId, String text) async {
    if (postId.isEmpty) {
      addCommentError = "Post id is required.";
      notifyListeners();
      return null;
    }

    if (text.trim().isEmpty) {
      addCommentError = "Comment cannot be empty.";
      notifyListeners();
      return null;
    }

    addCommentIsLoading = true;
    addCommentError = null;
    notifyListeners();

    try {
      final comment = await CommunityService.addPostComment(postId, text);
      
      comments.insert(0,comment);
      commentCountDeltas[postId] = (commentCountDeltas[postId] ?? 0) + 1;
      customSnackbar(context, false, "Comment added successfully");
      addCommentIsLoading = false;
      log("Comment added successfully");
      commentContrroller.clear();
      FocusScope.of(context).unfocus(); 
      notifyListeners();

      return comment;
    } catch (e) {
      addCommentError = e.toString();
      addCommentIsLoading = false;

      log("Failed to add comment");
      customSnackbar(context, true, "Comment Not added ");
      log(e.toString());

      notifyListeners();
      return null;
    }
  }
 
  void resetProvider() {
    postisLoading = false;
    isFeedLoading = false;
    isLoadingMore = false;
    hasMore = true;
    _currentPage = 1;
    error = null;
    feedPosts.clear();
    comments.clear();
    commentsIsLoading = false;
    commenterror = null;
    commentCountDeltas.clear();
    addCommentIsLoading = false;
    addCommentError = null;
    commentContrroller.clear();
    notifyListeners();
  }
}
