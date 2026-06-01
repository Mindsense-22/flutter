import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';
import 'package:mindsense_app/features/Analyzing/modules/adviceresponse.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/photo_scan_result_screen.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/report_screen.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/voice_scan_result_screen.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:provider/provider.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;
  File ? selectedaudio;

  String ? analysistype;
  bool isAnalyzing = false;
  //for image
  // String? detectedPhotoEmotion;
  // Map<String, dynamic>?  emotionPhotoScores;
  // // List aiPhotoAdvices=[];
  // //Map aiPhotoAdvice={};
  // Advice? aiPhotoAdvice;
  // double ? photoFinalScore;
  // //for voice
  // String? detectedVoiceEmotion;
  // Map<String, dynamic>? emotionVoiceScores;
  // List aiVoiceAdvices=[];
  // String aiVoiceAdvice=" ";
  // double  voiceFinalScore=0.0;
  // //for all
  // String? detectedAllEmotion="sad";
  // Map<String, dynamic>? emotionAllScores;
  // List aiAllAdvices=[];
  // String aiAllAdvice="";
  // double  allFinalScore=0.50;

  String? detectedEmotion;
  Map<String, dynamic>?  emotionScores;  
  Advice? aiAdvice;
  double  finalScore=0.0;
  Advice ? shownAdvice;
  Advice ? shownAdvice2;

  
  changeAnalysingType(type){
    analysistype=type;
    notifyListeners();
  }
  setSelectedImage(image){
    selctedimage=image;
    notifyListeners();
  }

  setSelectedAudio(audio){
    selectedaudio=audio;
    notifyListeners();
  }
  
  Future<void> submitFaceAnalysis(context) async {
    if (selctedimage == null){log("error in api"); return;} 
    
    try {
      isAnalyzing = true;
      notifyListeners();
      
      final result = await EmotionService.analyzeFace(File(selctedimage!.path));
      log(result["advice"].toString());

      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"] ?? "neutral";
      emotionScores = result["analysis"]?["scores"];
      
      aiAdvice = Advice.fromJson(
        result["advice"] ?? {},
      );
      shownAdvice=aiAdvice;      
      finalScore = (result["emotion"]?["confidence"] as num?)?.toDouble() ?? 0.0;
      isAnalyzing = false;

      Provider.of<DashboardProvider>(context, listen: false).setNeedsRefresh();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoScanResultScreen()),
      );
      notifyListeners();
    } catch (e,stackTrace) {
      isAnalyzing = false;
      notifyListeners();
      log(
        "Face analysis error: $e",
        stackTrace: stackTrace,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Failed To connect ",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitVoiceAnalysis(context) async {    
    if (selectedaudio == null){log("error in api: audio file is null"); return;} 
    try {
      isAnalyzing = true;
      notifyListeners();
      // shownAdvice=null;      
      final result = await EmotionService.analyzeVoice(selectedaudio!);      
      log(result["advice"].toString());
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"] ?? "neutral";
      emotionScores = result["analysis"]?["scores"];   
      aiAdvice = Advice.fromJson(
        result["advice"] ?? {},
      );
      shownAdvice2=aiAdvice;      
      finalScore = (result["emotion"]?["confidence"] as num?)?.toDouble() ?? 0.0;
      // final emotion = result["emotion"];
      // final analysis = result["analysis"];
      // final advice = result["advice"];
      
      // // emotion
      // if (emotion is Map && emotion["state"] is String) {
      //   detectedEmotion = emotion["state"];
      // } else if (analysis is Map && analysis["final_emotion"] is String) {
      //   detectedEmotion = analysis["final_emotion"];
      // } else {
      //   detectedEmotion = "neutral";
      // }

      // // scores
      // if (analysis is Map && analysis["details"] is Map) {
      //   emotionScores = Map<String, dynamic>.from(analysis["details"]);
      // } else {
      //   emotionScores = {};
      // }

      // // advice
      // if (advice is String) {
      //   aiAdvice = advice;
      //   aiAdvices = [advice];
      // } else if (advice is List && advice.isNotEmpty) {
      //   aiVoiceAdvices = advice;
      //   aiVoiceAdvice = advice.first?.toString() ?? "";
      // } else {
      //   aiVoiceAdvice = "";
      //   aiVoiceAdvices = [];
      // }

      // // confidence
      // if (emotion is Map && emotion["confidence"] is num) {
      //   voiceFinalScore = (emotion["confidence"] as num).toDouble();
      // } else {
      //   voiceFinalScore = 0.0;
      // }

      isAnalyzing = false;

      Provider.of<DashboardProvider>(context, listen: false).setNeedsRefresh();

      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VoiceScanResultScreen()),
      );
    } catch (e) {
      isAnalyzing = false;
      notifyListeners();
      log("Voice analysis error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Failed To connect ",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitCombinedAnalysis(context) async {
    if (selctedimage == null || selectedaudio == null) return;
    
    try {
      isAnalyzing = true;
      notifyListeners();
      
      final result = await EmotionService.analyzeAll(File(selctedimage!.path), selectedaudio!);
      
      // detectedAllEmotion = result["analysis"]?["fusion"]?["final_state"] ;      
      // aiAllAdvice = result["analysis"]?["advice"];
      // aiAllAdvices.add(aiAllAdvice);
      // allFinalScore=  result["emotion"]?["confidence"];
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"] ?? "neutral";
      emotionScores = result["analysis"]?["scores"];
      
      aiAdvice = Advice.fromJson(
        result["advice"] ?? {},
      );
      shownAdvice=aiAdvice;      
      finalScore = (result["emotion"]?["confidence"] as num?)?.toDouble() ?? 0.0;
      isAnalyzing = false;     

      Provider.of<DashboardProvider>(context, listen: false).setNeedsRefresh();

      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportScreen()),
      );
    } catch (e) {
      isAnalyzing = false;
      notifyListeners();
      log("Combined analysis error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Failed To connect ",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


}