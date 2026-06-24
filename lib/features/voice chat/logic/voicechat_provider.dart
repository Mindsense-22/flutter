import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/voicechat_service.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class VoicechatProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isPlayingAudio = false;

  AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;

  VoicechatProvider() {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlayingAudio = state == PlayerState.playing;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Map<String, dynamic>? settings;
  String? previewAudioBase64;
  
  String? sessionId;
  String? sessionWelcomeAudio;
  String? lastResponseAudio;
  String? lastResponseText;
  String ? quota;
  String? sessionSummary;
  Map<String, dynamic>? sessionSummaryData;

  List<dynamic> history = [];
  Map<String, dynamic>? subscriptionInfo;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void reset() {
    sessionId = null;
    sessionWelcomeAudio = null;
    lastResponseAudio = null;
    lastResponseText = null;
    sessionSummary = null;
    sessionSummaryData = null;
    isLoading = false;
    errorMessage = null;
    _audioPlayer.stop();
    notifyListeners();
  }

  Future<void> playBase64Audio(String base64String) async {
    try {
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }
      Uint8List audioBytes = base64Decode(cleanBase64);
      await _audioPlayer.play(BytesSource(audioBytes));
    } catch (e) {
      print("Failed to play audio: $e");
    }
  }

  Future<void> fetchSettings() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.getSettings();
      settings = response["data"];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSettings({
    String? preferredLanguage,
    bool? autoDetect,
    String? voiceStyle,
    num? speed,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.updateSettings(
        preferredLanguage: preferredLanguage,
        autoDetect: autoDetect,
        voiceStyle: voiceStyle,
        speed: speed,
      );
      settings = response["data"];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> previewSettings({
    required String preferredLanguage,
    required String voiceStyle,
    required num speed,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.previewSettings(
        preferredLanguage: preferredLanguage,
        voiceStyle: voiceStyle,
        speed: speed,
      );
      previewAudioBase64 = response["data"]?["audioBase64"];
      if (previewAudioBase64 != null) {
        playBase64Audio(previewAudioBase64!);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  changeQuota(newval){
    quota=newval;
    SharedPreferencesitem.setString("voiceQuota", quota!);
    notifyListeners();
  }
  
  Future<void> startSession({String? emotion}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.startSession(emotion:SharedPreferencesitem.getString("detectedEmotion")?? emotion);
      final data = response["data"];
      sessionId = data?["sessionId"];
      sessionWelcomeAudio = data?["greetingAudio"];
      lastResponseText = data?["greetingText"] ?? data?["text"];
      if (data["remainingMinutes"] != null) {
        quota = data["remainingMinutes"].toString();
        changeQuota(quota);
      }
      changeQuota(data?["remainingMinutes"]??"100");
      if (sessionWelcomeAudio != null) {
        playBase64Audio(sessionWelcomeAudio!);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage({required File audioFile, String? emotion}) async {
    if (sessionId == null) {
      _setError("No active session");
      return;
    }
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.sendMessage(
        sessionId: sessionId!,
        audioFile: audioFile,
        emotion: emotion,
      );
      
      final data = response["data"] ?? {};
      lastResponseAudio = data["responseAudio"] ?? data["audioBase64"];
      lastResponseText = data["text"] ?? data["message"] ?? data["reply"] ?? data["responseText"];
      
      // Update quota on every message response if it's provided in the response data
      if (data["remainingMinutes"] != null) {
        quota = data["remainingMinutes"].toString();
        changeQuota(quota);
      }
      
      if (lastResponseAudio != null) {
        playBase64Audio(lastResponseAudio!);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> endSession() async {
    if (sessionId == null) return;
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.endSession(sessionId: sessionId!);
      final data = response["data"] ?? {};
      sessionSummary = data["summary"]?.toString();
      sessionSummaryData = data is Map<String, dynamic> ? data : null;
      sessionId = null; // Clear the current session
      lastResponseText = null;
      await _audioPlayer.stop();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchHistory({int? limit}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.getHistory(limit: limit);
      history = response["data"] ?? [];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkSubscription() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.checkSubscription();
      subscriptionInfo = response["data"];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetSubscription() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await VoiceChatService.resetSubscription();
      subscriptionInfo = response["data"];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}