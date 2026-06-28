import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
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
      if(detectedEmotion!=null){
        await SharedPreferencesitem.setString("detectedEmotion", detectedEmotion!);
      }
      
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
      customSnackbar(context,true,"Failed To connect");
      
    }
  }

  Future<void> submitVoiceAnalysis(context) async {    
    if (selectedaudio == null){log("error in api: audio file is null"); return;} 
    try {
      isAnalyzing = true;
      notifyListeners();
      final result = await EmotionService.analyzeVoice(selectedaudio!);   
      log(result.toString());   
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"] ?? "gg";
      emotionScores = result["analysis"]?["scores"];  
      if(detectedEmotion!=null){
        await SharedPreferencesitem.setString("detectedEmotion", detectedEmotion!);
      }
      aiAdvice = Advice.fromJson(
        result["advice"] ?? {},
      );
      shownAdvice2=aiAdvice;      
      finalScore = (result["emotion"]?["confidence"] as num?)?.toDouble() ?? 0.0;


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
      customSnackbar(context,true,"Failed To connect");
      
    }
  }

  Future<void> submitCombinedAnalysis(context) async {
    if (selctedimage == null || selectedaudio == null) return;
    
    try {
      isAnalyzing = true;
      notifyListeners();
      
      final result = await EmotionService.analyzeAll(File(selctedimage!.path), selectedaudio!);
      detectedEmotion = result["emotion"]?["state"] ?? result["analysis"]?["state"] ?? "neutral";
      emotionScores = result["analysis"]?["scores"];
      if(detectedEmotion!=null){
        await SharedPreferencesitem.setString("detectedEmotion", detectedEmotion!);
      }
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
      customSnackbar(context,true,"Failed To connect");
    }
  }


}