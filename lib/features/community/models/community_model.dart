class Author {
  final String id;
  final String name;
  final String? profileImage;

  Author({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      profileImage: json['profileImage'] as String?,
    );
  }
}

class DisplayAuthor {
  final String name;
  final String? avatarSeed;
  final String? profileImage;
  final String? mode;

  DisplayAuthor({
    required this.name,
    this.avatarSeed,
    this.profileImage,
    this.mode,
  });

  factory DisplayAuthor.fromJson(Map<String, dynamic> json) {
    return DisplayAuthor(
      name: json['name'] as String? ?? 'Anonymous',
      avatarSeed: json['avatarSeed'] as String?,
      profileImage: json['profileImage'] as String?,
      mode: json['mode'] as String?,
    );
  }
}

class Reaction {
  final String id;
  final String user;
  final String type;
  final DateTime createdAt;

  Reaction({
    required this.id,
    required this.user,
    required this.type,
    required this.createdAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['_id'] as String? ?? '',
      user: json['user'] as String? ?? '',
      type: json['type'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}

class FeedPost {
  final String id;
  final dynamic author; // String or Author object depending on population
  final dynamic circle; // String or Circle object
  final String type;
  final String content;
  final String visibility;
  final DisplayAuthor? displayAuthor;
  final String status;
  final int shareCount;
  final int commentCount;
  final int reportCount;
  final int trendingScore;
  final List<Reaction> reactions;
  final DateTime createdAt;
  final List savedBy;
  FeedPost({
    required this.id,
    this.author,
    this.circle,
    required this.type,
    required this.content,
    required this.visibility,
    this.displayAuthor,
    required this.status,
    required this.shareCount,
    required this.commentCount,
    required this.reportCount,
    required this.trendingScore,
    required this.reactions,
    required this.createdAt, required this.savedBy,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['_id'] as String? ?? '',
      author: json['author'],
      circle: json['circle'],
      type: json['type'] as String? ?? 'reflection',
      content: json['content'] as String? ?? '',
      visibility: json['visibility'] as String? ?? 'public',
      displayAuthor: json['displayAuthor'] != null ? DisplayAuthor.fromJson(json['displayAuthor']) : null,
      status: json['status'] as String? ?? 'published',
      shareCount: json['shareCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      reportCount: json['reportCount'] as int? ?? 0,
      trendingScore: json['trendingScore'] as int? ?? 0,
      reactions: (json['reactions'] as List<dynamic>? ?? []).map((e) => Reaction.fromJson(e)).toList(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      savedBy: json['savedBy'] as List? ?? [],
    );
  }
}

class Circle {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final List<String> tags;
  final List<String> rules;
  final int memberCount;
  final String visibility;

  Circle({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.tags = const [],
    this.rules = const [],
    this.memberCount = 0,
    required this.visibility,
  });

  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      rules: (json['rules'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      memberCount: json['memberCount'] as int? ?? 0,
      visibility: json['visibility'] as String? ?? 'public',
    );
  }
}

class ChallengeTask {
  final String id;
  final String title;
  final int xp;

  ChallengeTask({
    required this.id,
    required this.title,
    required this.xp,
  });

  factory ChallengeTask.fromJson(Map<String, dynamic> json) {
    return ChallengeTask(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      xp: json['xp'] as int? ?? 0,
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final String type;
  final int durationDays;
  final int xp;
  final String difficulty;
  final List<ChallengeTask> tasks;
  final String badgeKey;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationDays,
    required this.xp,
    required this.difficulty,
    required this.tasks,
    required this.badgeKey,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      durationDays: json['durationDays'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'easy',
      tasks: (json['tasks'] as List<dynamic>? ?? []).map((e) => ChallengeTask.fromJson(e)).toList(),
      badgeKey: json['badgeKey'] as String? ?? '',
    );
  }
}

class Badge {
  final String id;
  final String key;
  final String name;
  final String description;
  final String category;

  Badge({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.category,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['_id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class Reputation {
  final int supportScore;
  final int consistency;
  final int contribution;
  final int helpful;
  final int trust;
  final int level;

  Reputation({
    required this.supportScore,
    required this.consistency,
    required this.contribution,
    required this.helpful,
    required this.trust,
    required this.level,
  });

  factory Reputation.fromJson(Map<String, dynamic> json) {
    return Reputation(
      supportScore: json['supportScore'] as int? ?? 0,
      consistency: json['consistency'] as int? ?? 0,
      contribution: json['contribution'] as int? ?? 0,
      helpful: json['helpful'] as int? ?? 0,
      trust: json['trust'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
    );
  }
}

class CommunityOverview {
  final String tagline;
  final List<Circle> circles;
  final List<FeedPost> recentPosts;
  final List<Challenge> challenges;
  final List<Badge> badges;
  final Reputation? reputation;
  final int xp;

  CommunityOverview({
    required this.tagline,
    required this.circles,
    required this.recentPosts,
    required this.challenges,
    required this.badges,
    this.reputation,
    required this.xp,
  });

  factory CommunityOverview.fromJson(Map<String, dynamic> json) {
    return CommunityOverview(
      tagline: json['tagline'] as String? ?? '',
      circles: (json['circles'] as List<dynamic>? ?? []).map((e) => Circle.fromJson(e)).toList(),
      recentPosts: (json['recentPosts'] as List<dynamic>? ?? []).map((e) => FeedPost.fromJson(e)).toList(),
      challenges: (json['challenges'] as List<dynamic>? ?? []).map((e) => Challenge.fromJson(e)).toList(),
      badges: (json['badges'] as List<dynamic>? ?? []).map((e) => Badge.fromJson(e)).toList(),
      reputation: json['reputation'] != null ? Reputation.fromJson(json['reputation']) : null,
      xp: json['xp'] as int? ?? 0,
    );
  }
}

class Comment {
  final String id;
  final String post;
  final dynamic author;
  final String content;
  final String visibility;
  final DisplayAuthor? displayAuthor;
  final String status;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.post,
    this.author,
    required this.content,
    required this.visibility,
    this.displayAuthor,
    required this.status,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String? ?? '',
      post: json['post'] as String? ?? '',
      author: json['author'],
      content: json['content'] as String? ?? '',
      visibility: json['visibility'] as String? ?? 'public',
      displayAuthor: json['displayAuthor'] != null ? DisplayAuthor.fromJson(json['displayAuthor']) : null,
      status: json['status'] as String? ?? 'published',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}
