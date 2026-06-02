import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/doctors_service.dart';
import 'package:mindsense_app/features/doctors/modules/doctordetails.dart';

class DoctorsProvider extends ChangeNotifier{
  List<DoctorDetails> doctorsList = [];
  var follow=[{"index":int ,"isfollow":bool}];
  bool isLoading = false;

  Future<void> getAllDoctors() async {
    isLoading = true;
    notifyListeners();
    try {
      doctorsList = await DoctorsService.getAllDoctors();
    } catch (e) {
      // Handle error silently or add error state later
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}