import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  String? _currentUrl;
  PlayerState _state = PlayerState.stopped;

  StreamSubscription<PlayerState>? _stateSub;

  bool _disposed = false;

  String? get currentUrl => _currentUrl;
  bool get isPlaying => _state == PlayerState.playing;

  AudioProvider() {
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (_disposed) return;

      _state = state;
      notifyListeners();
    });
  }

  Future<void> play(String url) async {
    if (_disposed) return;

    try {
      // toggle same audio
      if (_currentUrl == url) {
        if (_state == PlayerState.playing) {
          await _player.pause();
        } else {
          await _player.resume();
        }
      } else {
        _currentUrl = url;

        await _player.stop();
        await _player.play(UrlSource(url));
      }

      if (_disposed) return;
      notifyListeners();
    } catch (e) {
      log("Audio Error: $e");

      _currentUrl = null;
      _state = PlayerState.stopped;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<void> stop() async {
    if (_disposed) return;

    _currentUrl = null;
    await _player.stop();

    notifyListeners();
  }

  void resetProvider() {
    if (_disposed) return;

    _currentUrl = null;
    _state = PlayerState.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;

    _stateSub?.cancel(); 
    _player.dispose();

    super.dispose();
  }
}