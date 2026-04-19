class DashboardItems {
  final String day;
  final double faceValue;
  final double voiceValue;
  final double maxValue;

  DashboardItems({
    required this.day,
    required this.faceValue,
    required this.voiceValue,
    required this.maxValue,
  });

  double get totalHeight => faceValue + voiceValue;
  double get normalizedFaceHeight => faceValue;
  double get normalizedVoiceHeight => voiceValue;
  bool get hasData => faceValue > 0 || voiceValue > 0;

  @override
  String toString() =>
      'DashboardItems(day: $day, faceValue: $faceValue, voiceValue: $voiceValue, maxValue: $maxValue)';
}

class DailyDashboardData {
  final List<DashboardItems> items;

  DailyDashboardData({required this.items});

  double get maxValue {
    if (items.isEmpty) return 0;
    return items.map((e) => e.maxValue).reduce((a, b) => a > b ? a : b);
  }

  List<String> get days => items.map((e) => e.day).toList();
  bool get isEmpty => items.isEmpty;

  factory DailyDashboardData.fromJson(List<Map<String, dynamic>> jsonList) {
    final items = jsonList
        .map((json) => DashboardItems(
              day: json['day'] as String,
              faceValue: (json['faceValue'] as num).toDouble(),
              voiceValue: (json['voiceValue'] as num).toDouble(),
              maxValue: (json['maxValue'] as num?)?.toDouble() ?? 12.0,
            ))
        .toList();
    return DailyDashboardData(items: items);
  }

  List<Map<String, dynamic>> toJson() {
    return items
        .map((item) => {
              'day': item.day,
              'faceValue': item.faceValue,
              'voiceValue': item.voiceValue,
              'maxValue': item.maxValue,
            })
        .toList();
  }
}