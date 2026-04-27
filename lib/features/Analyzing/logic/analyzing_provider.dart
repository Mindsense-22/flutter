import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;
  File ? selectedaudio;
  
  bool isAnalyzing = false;
  String? detectedEmotion;
  Map<String, dynamic>? emotionScores;
  String? aiAdvice;
  
  setSelectedImage(image){
    selctedimage=image;
    notifyListeners();
  }

  setSelectedAudio(audio){
    selectedaudio=audio;
    notifyListeners();
  }
  
  Future<void> submitFaceAnalysis() async {
    if (selctedimage == null) return;
    
    try {
      isAnalyzing = true;
      notifyListeners();
      
      final result = await EmotionService.analyzeFace(File(selctedimage!.path));
      
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"];
      emotionScores = result["analysis"]?["scores"];
      aiAdvice = result["advice"];
      
      isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      isAnalyzing = false;
      notifyListeners();
      log("Face analysis error: $e");
    }
  }

  Future<void> submitVoiceAnalysis() async {
    if (selectedaudio == null) return;
    
    try {
      isAnalyzing = true;
      notifyListeners();
      
      final result = await EmotionService.analyzeVoice(selectedaudio!);
      
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["final_emotion"];
      emotionScores = result["analysis"]?["details"];
      aiAdvice = result["advice"];
      
      isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      isAnalyzing = false;
      notifyListeners();
      log("Voice analysis error: $e");
    }
  }

  Future<void> submitCombinedAnalysis() async {
    if (selctedimage == null || selectedaudio == null) return;
    
    try {
      isAnalyzing = true;
      notifyListeners();
      
      final result = await EmotionService.analyzeAll(File(selctedimage!.path), selectedaudio!);
      
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["fusion"]?["final_state"];
      emotionScores = result["analysis"]?["fusion"]?["scores"];
      aiAdvice = result["advice"];
      
      isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      isAnalyzing = false;
      notifyListeners();
      log("Combined analysis error: $e");
    }
  }
}