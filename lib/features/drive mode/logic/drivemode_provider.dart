import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';

class DrivemodeProvider extends ChangeNotifier {
  Map<String, dynamic> statusData = {};
  List showedData = [];
  bool isLoading = false;
  bool error = false;
  bool isFinished = false;
  bool _isFetching = false; 
  CancelToken? _cancelToken;

  Future<void> startFetching() async {
    
    if (_isFetching) return;
    _isFetching = true;
    isFinished = false;

    while (!isFinished) {
      log("drive mode start");
      _cancelToken = CancelToken();
      await fetchStatus(_cancelToken!);
      if (isFinished) break; 
      await Future.delayed(const Duration(seconds: 4));
    }

    _isFetching = false;
    log("drive mode End");
  }

  void stopFetching(context) {
    isFinished = true;
    _cancelToken?.cancel("Drive mode stopped"); 
    customSnackbar(context, true, "Drive mode closed");
    notifyListeners();
  }

  Future<void> fetchStatus(CancelToken cancelToken) async {
    if (statusData.isEmpty) {
      isLoading = true;
      notifyListeners();
    }
    try {
      final response = await Dio().get(
        'http://10.42.0.1:5000/status',
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);

        String timestampKey = data.keys.firstWhere(
          (k) => k.toLowerCase() == 'timestamp',
          orElse: () => '',
        );

        if (timestampKey.isNotEmpty && data[timestampKey] != null) {
          String timestampValue = data[timestampKey].toString();
          if (timestampValue.contains('T')) {
            data[timestampKey] = timestampValue.split('T').last;
          }
        }

        statusData = data;
        showedData.add(Map<String, dynamic>.from(statusData));
        notifyListeners();
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        log('Request cancelled: ${e.message}');
      } else {
        log('Error fetching status: $e');
        error = true;
        notifyListeners();
      }
    } catch (e) {
      log('Error fetching status: $e');
      error = true;
      notifyListeners();
    } finally {
      if (isLoading) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
