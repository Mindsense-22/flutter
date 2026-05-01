import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/photo_scan_result_screen.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/report_screen.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/voice_scan_result_screen.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;
  File ? selectedaudio;

  String ? analysistype;
  bool isAnalyzing = false;
  //for image
  String? detectedPhotoEmotion;
  Map<String, dynamic>?  emotionPhotoScores;
  List aiPhotoAdvices=[];
  String aiPhotoAdvice="";
  double ? photoFinalScore;
  //for voice
  String? detectedVoiceEmotion;
  Map<String, dynamic>? emotionVoiceScores;
  List aiVoiceAdvices=[];
  String aiVoiceAdvice=" ";
  double  voiceFinalScore=0.0;
  //for all
  String? detectedAllEmotion="sad";
  Map<String, dynamic>? emotionAllScores;
  List aiAllAdvices=[];
  String aiAllAdvice="";
  double  allFinalScore=0.50;


  

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
      
      detectedPhotoEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"] ?? "neutral";
      emotionPhotoScores = result["analysis"]?["scores"];
      aiPhotoAdvice = result["advice"] ?? "";
      aiPhotoAdvices.add(aiPhotoAdvice);
      photoFinalScore = (result["emotion"]?["confidence"] as num?)?.toDouble() ?? 0.0;
      isAnalyzing = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoScanResultScreen()),
      );
      notifyListeners();
    } catch (e) {
      isAnalyzing = false;
      notifyListeners();
      log("Face analysis error: $e");
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
      
      final result = await EmotionService.analyzeVoice(selectedaudio!);      

      final emotion = result["emotion"];
      final analysis = result["analysis"];
      final advice = result["advice"];
      
      // emotion
      if (emotion is Map && emotion["state"] is String) {
        detectedVoiceEmotion = emotion["state"];
      } else if (analysis is Map && analysis["final_emotion"] is String) {
        detectedVoiceEmotion = analysis["final_emotion"];
      } else {
        detectedVoiceEmotion = "neutral";
      }

      // scores
      if (analysis is Map && analysis["details"] is Map) {
        emotionVoiceScores = Map<String, dynamic>.from(analysis["details"]);
      } else {
        emotionVoiceScores = {};
      }

      // advice
      if (advice is String) {
        aiVoiceAdvice = advice;
        aiVoiceAdvices = [advice];
      } else if (advice is List && advice.isNotEmpty) {
        aiVoiceAdvices = advice;
        aiVoiceAdvice = advice.first?.toString() ?? "";
      } else {
        aiVoiceAdvice = "";
        aiVoiceAdvices = [];
      }

      // confidence
      if (emotion is Map && emotion["confidence"] is num) {
        voiceFinalScore = (emotion["confidence"] as num).toDouble();
      } else {
        voiceFinalScore = 0.0;
      }

      isAnalyzing = false;
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
      
      detectedAllEmotion = result["analysis"]?["fusion"]?["final_state"] ;      
      aiAllAdvice = result["analysis"]?["advice"];
      aiAllAdvices.add(aiAllAdvice);
      allFinalScore=  result["emotion"]?["confidence"];
      isAnalyzing = false;
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