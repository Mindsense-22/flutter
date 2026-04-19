import 'package:flutter/foundation.dart';
import 'package:mindsense_app/features/dashboard/modules/dashboarditems.dart';

class DashboardProvider extends ChangeNotifier {
  String userStatus="mild exhaustion";
  
  late DailyDashboardData _dashboardData;
  bool _isLoading = false;

  DashboardProvider({DailyDashboardData? initialData}) {
    if (initialData != null) {
      _dashboardData = initialData;
    } else {
      _dashboardData = _generateDefaultData();
    }
  }

  DailyDashboardData get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  List<DashboardItems> get items => _dashboardData.items;
  double get maxValue => _dashboardData.maxValue;

  void updateDashboardData(DailyDashboardData newData) {
    _dashboardData = newData;
    notifyListeners();
  }

  void updateItem(int index, {required double faceValue, required double voiceValue}) {
    if (index >= 0 && index < _dashboardData.items.length) {
      final item = _dashboardData.items[index];
      _dashboardData.items[index] = DashboardItems(
        day: item.day,
        faceValue: faceValue,
        voiceValue: voiceValue,
        maxValue: item.maxValue,
      );
      notifyListeners();
    }
  }

  void addItem(DashboardItems item) {
    _dashboardData.items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _dashboardData.items.length) {
      _dashboardData.items.removeAt(index);
      notifyListeners();
    }
  }

  void clearItems() {
    _dashboardData.items.clear();
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _dashboardData = _generateDefaultData();
    _isLoading = false;
    notifyListeners();
  }

  void loadFromJson(List<Map<String, dynamic>> jsonData) {
    _dashboardData = DailyDashboardData.fromJson(jsonData);
    notifyListeners();
  }

  List<Map<String, dynamic>> toJson() => _dashboardData.toJson();

  DashboardItems? getItemAt(int index) {
    if (index >= 0 && index < _dashboardData.items.length) {
      return _dashboardData.items[index];
    }
    return null;
  }

  double get averageFaceValue {
    if (_dashboardData.items.isEmpty) return 0;
    final sum = _dashboardData.items.fold<double>(0, (prev, item) => prev + item.faceValue);
    return sum / _dashboardData.items.length;
  }

  double get averageVoiceValue {
    if (_dashboardData.items.isEmpty) return 0;
    final sum = _dashboardData.items.fold<double>(0, (prev, item) => prev + item.voiceValue);
    return sum / _dashboardData.items.length;
  }

  void reset() {
    _dashboardData = _generateDefaultData();
    _isLoading = false;
    notifyListeners();
  }

  DailyDashboardData _generateDefaultData() {
    return DailyDashboardData(
      items: [
        DashboardItems(day: 'Sat', faceValue: 10, voiceValue: 0, maxValue: 10.0),
        DashboardItems(day: 'Sun', faceValue: 9.5, voiceValue: 5.8, maxValue: 10.0),
        DashboardItems(day: 'Mon', faceValue: 6.0, voiceValue: 3.7, maxValue: 10.0),
        DashboardItems(day: 'Tue', faceValue: 7.5, voiceValue: 6.0, maxValue: 10.0),
        DashboardItems(day: 'Wed', faceValue: 7.0, voiceValue: 4.8, maxValue: 10.0),
        DashboardItems(day: 'Thu', faceValue: 8.0, voiceValue: 2.3, maxValue: 10.0),
        DashboardItems(day: 'Fri', faceValue: 3, voiceValue: 7, maxValue: 10),
      ],
    );
  }
}