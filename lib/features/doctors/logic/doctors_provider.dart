import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/core/Api/doctors_service.dart';
import 'package:mindsense_app/features/doctors/modules/doctordetails.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

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
  Future<void> followButton(id,context) async { 
    Provider.of<ProfileScreenProvider>(context, listen: false).addFollowingOptimistic(id);
    try{
      final response = await DioFactory.postData(
      path: "/api/v1/professionals/$id/follow",
      data: {}
    );
    log(response.data["status"]);
    Provider.of<ProfileScreenProvider>(context, listen: false)
      .fetchUserProfile();
    getAllDoctors();    
    }catch(e){
      log(e.toString());
    } 
  }
  Future<void> unfollowButton(id,context) async { 
      Provider.of<ProfileScreenProvider>(context, listen: false).removeFollowingOptimistic(id);
      try{
        final response = await DioFactory.postData(
        path: "/api/v1/professionals/$id/follow",
        data: {}
      );
      log(response.data["status"]);
      Provider.of<ProfileScreenProvider>(context, listen: false)
        .fetchUserProfile();
      getAllDoctors();
      
    }catch(e){
        log("unfollow :"+e.toString());
    }
  } 
}
