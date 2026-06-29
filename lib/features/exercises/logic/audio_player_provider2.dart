import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  String? _currentUrl;
  PlayerState _state = PlayerState.stopped;

  String? get currentUrl => _currentUrl;
  bool get isPlaying => _state == PlayerState.playing;

  AudioProvider() {
    _player.onPlayerStateChanged.listen((state) {
      _state = state;
      notifyListeners();
    });
  }
  

  Future<void> play(String url) async {
    try {
      // same audio , toggle play/pause
      if (_currentUrl == url) {
        if (_state == PlayerState.playing) {
          await _player.pause();
        } else {
          await _player.resume();
        }
      } else {
        // new audio
        _currentUrl = url;
        await _player.stop();
        await _player.play(UrlSource(url));
      }

      notifyListeners();
    } catch (e) {
      log("Audio Error: $e");

      _currentUrl = null;
      _state = PlayerState.stopped;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    _currentUrl = null;
    await _player.stop();
    notifyListeners();
  }

  void resetProvider() {
    _currentUrl = null;
    _state = PlayerState.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}