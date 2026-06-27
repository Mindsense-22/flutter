class Advice {
  final String version;
  final String state;
  final String stateKey;
  final String recommendedGoal;
  final String defaultLanguage;
  final List<String> availableLanguages;
  final Content content;  

  final String source;
  final String title;
  final String summary;
  final String focusLabel;
  final List<String> items;
  final String why;
  final String aftercare;

  Advice({
    required this.version,
    required this.state,
    required this.stateKey,
    required this.recommendedGoal,
    required this.defaultLanguage,
    required this.availableLanguages,
    required this.content,
    required this.source,
    required this.title,
    required this.summary,
    required this.focusLabel,
    required this.items,
    required this.why,
    required this.aftercare,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      version: json["version"] ?? "",
      state: json["state"] ?? "",
      stateKey: json["state_key"] ?? "",
      recommendedGoal: json["recommended_goal"] ?? "",
      defaultLanguage: json["default_language"] ?? "",
      availableLanguages:
          List<String>.from(json["available_languages"] ?? []),
      content: Content.fromJson(json["content"] ?? {}),
      source: json["source"] ?? "",
      title: json["title"] ?? "",
      summary: json["summary"] ?? "",
      focusLabel: json["focus_label"] ?? "",
      items: List<String>.from(json["items"] ?? []),
      why: json["why"] ?? "",
      aftercare: json["aftercare"] ?? "",
    );
  }
}

class Content {
  final LanguageContent en;
  final LanguageContent? ar;

  Content({
    required this.en,
    this.ar,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      en: LanguageContent.fromJson(json["en"] ?? {}),
      ar: json["ar"] != null ? LanguageContent.fromJson(json["ar"]) : null,
    );
  }
}

class LanguageContent {
  final String title;
  final String summary;
  final Goals goals;

  LanguageContent({
    required this.title,
    required this.summary,
    required this.goals,
  });

  factory LanguageContent.fromJson(Map<String, dynamic> json) {
    return LanguageContent(
      title: json["title"] ?? "",
      summary: json["summary"] ?? "",
      goals: Goals.fromJson(json["goals"] ?? {}),
    );
  }
}

class Goals {
  final Goal calm;
  final Goal focus;
  final Goal reflect;

  Goals({
    required this.calm,
    required this.focus,
    required this.reflect,
  });

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      calm: Goal.fromJson(json["calm"] ?? {}),
      focus: Goal.fromJson(json["focus"] ?? {}),
      reflect: Goal.fromJson(json["reflect"] ?? {}),
    );
  }
}

class Goal {
  final String label;
  final List<String> plan;
  final String why;
  final String after;

  Goal({
    required this.label,
    required this.plan,
    required this.why,
    required this.after,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      label: json["label"] ?? "",
      plan: List<String>.from(json["plan"] ?? []),
      why: json["why"] ?? "",
      after: json["after"] ?? "",
    );
  }
}