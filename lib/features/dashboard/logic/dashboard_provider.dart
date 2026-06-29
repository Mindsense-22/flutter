import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:mindsense_app/features/dashboard/modules/dashboarditems.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';

class DashboardProvider extends ChangeNotifier {
  String userStatus="Nuteral"; 
  
  bool _isLoading = false;
  bool _dashBoardIsLoading=false;
  List<dynamic> emotionHistory = [];
  List<dynamic> emotionReport = [];
  List  mainDashboardData=[];
  String? _error;
  bool _needsRefresh = true;
  bool get isLoading => _isLoading;  
  String? get error => _error;
  bool get needsRefresh => _needsRefresh;
  List <DashboardItems> dashboardItems=[];
    
  
  
  Future<void> refreshData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.wait([
        fetchEmotionHistory(),
        fetchEmotionReport(),
        
      ]);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // get dashboard data
  Future<void> fetchMainDashboard() async {
    _dashBoardIsLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await EmotionService.getMainDashboard();

      if (response['status'] == 'success') {
        final List<Map<String, dynamic>> chartData =
            List<Map<String, dynamic>>.from(response['data']['chartData']);

        dashboardItems.clear();

        for (final item in chartData) {
          dashboardItems.add(
            DashboardItems(
              day: item["day"] ?? "",
              faceValue: item["faceScore"] ?? 0.0,
              voiceValue: item["voiceScore"] ?? 0.0,
            ),
          );notifyListeners();
          
        }
        // log(dashboardItems.length.toString());
      }
    } catch (e) {
      log("main dashboard error: ${e.toString()}");
    } finally {
      _dashBoardIsLoading = false;
      notifyListeners();
    }
  }


  // get emotion history
  Future<void> fetchEmotionHistory({
    int? limit,
    String? source,
    String? from,
    String? to,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await EmotionService.getEmotionHistory(
        limit: limit,
        source: source,
        from: from,
        to: to,
      );

      if (response['status'] == 'success') {
        emotionHistory = response['data'] ?? [];
        _needsRefresh = false; // Reset flag on success
      } else {
        _error = response['message'] ?? "Failed to fetch history";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  /// get emotion report
  Future<void> fetchEmotionReport({
    String groupBy = "daily",
    String? from,
    String? to,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await EmotionService.getEmotionReport(
        groupBy: groupBy,
        from: from,
        to: to,
      );

      if (response['status'] == 'success') {
        emotionReport = response['data'] ?? [];        
        _needsRefresh = false;
      } else {
        _error = response['message'] ?? "Failed to fetch report";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void setNeedsRefresh() {
    _needsRefresh = true;
    notifyListeners();
  }

  void resetProvider() {
    userStatus = "Nuteral";
    _isLoading = false;
    _dashBoardIsLoading = false;
    emotionHistory.clear();
    emotionReport.clear();
    mainDashboardData.clear();
    _error = null;
    _needsRefresh = true;
    dashboardItems.clear();
    notifyListeners();
  }
}