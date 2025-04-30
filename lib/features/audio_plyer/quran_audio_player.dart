import 'dart:async';

import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioPlayer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  static const String _baseUrl = 'https://tanzil.net/res/audio/';
  String author = 'afasy';
  List<String> authors = ['afasy', 'mishary'];
  static const String _audioFormat = '.mp3';
  
  Sura? _currentSura;
  List<Aya>? _currentAyas;
  int _currentAyaIndex = 0;
  get currentAyyaIndex => _currentAyaIndex;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }
  get isPlaying => _audioPlayer.playing;
  
  Future<void> playSurah(Sura sura, {int startAya = 0}) async {
    // Clear previous subscription
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    // Stop any current playback
    await _audioPlayer.stop();

    // Set new surah data
    _currentSura = sura;
    _currentAyas = sura.ayas;
    _currentAyaIndex = startAya;
    
    await _playCurrentAya();
  }

  Future<void> _playCurrentAya() async {
    if (_currentSura == null || 
        _currentAyas == null || 
        _currentAyaIndex >= _currentAyas!.length) {
      return;
    }

    final aya = _currentAyas![_currentAyaIndex];
    final audioUrl = _getAyaAudioUrl(
      _currentSura!.index.toString(),
      aya.index.toString(),
    );

    try {
      // Cancel previous subscription if exists
      await _playerStateSubscription?.cancel();

      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      
      // Create new subscription
      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        notifyListeners();
        if (state.processingState == ProcessingState.completed) {
          _playNextAya();
        }
      });

      await _audioPlayer.play();

    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _playNextAya() async {
    _currentAyaIndex++;
    notifyListeners();
    if (_currentAyaIndex < _currentAyas!.length) {
      await _playCurrentAya();
    }
  }

  String _getAyaAudioUrl(String suraIndex, String ayaIndex) {
    return "${_baseUrl}afasy/${suraIndex.padLeft(3, '0')}${ayaIndex.padLeft(3, '0')}$_audioFormat";
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _audioPlayer.stop();
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _audioPlayer.dispose();
    super.dispose();
  }
}