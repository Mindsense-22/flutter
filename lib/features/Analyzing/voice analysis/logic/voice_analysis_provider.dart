import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mindsense_app/features/Analyzing/voice analysis/ui/widgets/voicepermissiondialog_wid.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceAnalysisProvider extends ChangeNotifier {
  bool voicePermissionAllowed = false;
  bool isRecording = false;
  int recordTime = 0;
  Timer? timer; 
  bool recoredStoped=false;
  File? audioFile;
  final AudioRecorder recorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  final RecordConfig recordConfig = const RecordConfig(
    encoder: AudioEncoder.wav,
    sampleRate: 16000,
    numChannels: 1,
    autoGain: false,
    echoCancel: true,
    noiseSuppress: true,
  );

  /// Show permission dialog
  Future<dynamic> voicePermissionShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => VoicepermissiondialogWid(),
    );
  }

  /// Permission
  void changeVoicePermission(bool permission) {
    voicePermissionAllowed = permission;
    notifyListeners();
  }

  /// START / STOP recording
  Future<void> changeIsRecording() async {
    isRecording = !isRecording;
    try {
      if (isRecording) {
        // START
        if(recoredStoped&&audioFile!=null){
          recordTime=0;
        }
        isRecording = true;
        await Permission.microphone.request();
        notifyListeners();
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          recordTime ++; 
          notifyListeners();
        });
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/voicerecorder.wav';
        await recorder.start(recordConfig, path: path);
      }
      else {
        // STOP
        timer?.cancel();
        isRecording = false;
        await recorder.pause();

        

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Recording error: $e");
      timer?.cancel();
      timer = null;
      isRecording = false;
      notifyListeners();
    }
  }

  Future<void> stopRecording() async {
    timer?.cancel();    
    isRecording=false;
    recoredStoped=true;
    audioFile=null;    
    final path = await recorder.stop();
    log(path.toString());
    if (path != null) {          
      audioFile = File(path);
    }
    else{
      audioFile=null;
    }
    notifyListeners();
  }

  /// CANCEL recording
  Future<void> cancelRecording() async {
    try {
      timer?.cancel();      
      isRecording = false;
      recordTime = 0;
      audioFile=null;
      await recorder.cancel();      
      notifyListeners();
    } catch (e) {
      debugPrint("Cancel recording error: $e");
    }
  }

  /// FORMAT TIME (MM:SS:MS)
  // String formatTime(int milliseconds) {
  //   final minutes = milliseconds ~/ 60000;
  //   final seconds = (milliseconds % 60000) ~/ 1000;
  //   final ms = (milliseconds % 1000) ~/ 10;

  //   String twoDigits(int n) => n.toString().padLeft(2, '0');

  //   return "${twoDigits(minutes)}:${twoDigits(seconds):${twoDigits(ms)}}";
  // }

  String formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  Future<void> playRecordedAudio() async {
    try {
      if (audioFile == null || !audioFile!.existsSync()) {
        log("Audio file not found");
        return;
      }

      await audioPlayer.stop(); // stop previous if playing

      await audioPlayer.play(
        DeviceFileSource(audioFile!.path),
      );
    } catch (e) {
      debugPrint("Play error: $e");
    }
  }
}