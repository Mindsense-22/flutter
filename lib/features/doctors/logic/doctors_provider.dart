import 'dart:developer';
import 'dart:io';

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
  List<Map<String, dynamic>> sessionsList = [];
  bool isLoadingSessions = false;

  Future<void> fetchMySessions() async {
    isLoadingSessions = true;
    notifyListeners();
    try {
      sessionsList = await DoctorsService.getMySessions();
    } catch (e) {
      log("Sessions error: $e");
    } finally {
      isLoadingSessions = false;
      notifyListeners();
    }
  }

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
    //getAllDoctors();    
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
      //getAllDoctors();
      
    }catch(e){
        log("unfollow :"+e.toString());
    }
  }
  
  Future<void> submitBooking(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required String professionalId,
    required String paymentMethod,
    required String? transferRef,
    required File? screenshot,
    required DateTime? startTime,
    required DateTime? endTime,
    required String ? duration
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end times', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    if (screenshot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please attach a money transfer screenshot', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    if (duration == null || duration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Enter Session Dutration', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }    
    if (double.tryParse(duration)! >3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session Duration Can't Be More Than 3 Hours", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    if (double.tryParse(duration)! <1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session Duration Can't Be Less Than 1 Hour", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;      
    }    

    try {
      await DoctorsService.bookSession(
        professionalId: professionalId,
        startTime: startTime,
        endTime: endTime,
        paymentMethod: paymentMethod,
        paymentReference: transferRef,
        paymentProof: screenshot,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking submitted successfully!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );
      fetchMySessions();
      Navigator.pop(context);
    } catch (e) {
      log("Booking error: " + e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit booking: $e', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    }
  }
}
