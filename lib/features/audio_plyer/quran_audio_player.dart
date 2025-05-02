import 'dart:async';
import 'dart:developer';

import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioPlayer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _preloadPlayer = AudioPlayer();

  static const String _baseUrl = 'https://tanzil.net/res/audio/';
  String author = 'afasy';
  List<String> authors = ['afasy', 'mishary'];
  static const String _audioFormat = '.mp3';

  Sura? _currentSura;
  Sura? get currentSura => _currentSura;
  List<Aya>? _currentAyas;
  List<Aya>? get currentAyas => _currentAyas;
  int _currentAyaIndex = 0;
  int get currentAya => _currentAyaIndex + 1;
  get currentAyyaIndex => _currentAyaIndex;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _loopMode = false;
  double _playbackSpeed = 1.0;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Duration? get duration => _audioPlayer.duration;
  Duration get position => _audioPlayer.position;
  bool get loopMode => _loopMode;
  double get playbackSpeed => _playbackSpeed;

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

    _playCurrentAya();
    _preloadNextAya();
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
          playNextAya();
        }
      });
      await _audioPlayer.setSpeed(_playbackSpeed);
      await _audioPlayer.play();
    } catch (e, s) {
      log('Error playing audio: $e', stackTrace: s);
    }
  }

  void _preloadNextAya() async {
    if (_currentAyas == null || _currentAyaIndex + 1 >= _currentAyas!.length)
      return;

    final nextAya = _currentAyas![_currentAyaIndex + 1];
    final nextUrl = _getAyaAudioUrl(
      _currentSura!.index.toString(),
      nextAya.index.toString(),
    );

    try {
      await _preloadPlayer.setAudioSource(AudioSource.uri(Uri.parse(nextUrl)));
      // We don't call play() here — just loading into memory
    } catch (e, s) {
      log("Preload error: $e", stackTrace: s);
    }
  }

  get canShowControls => _currentAyas != null && _currentSura != null;

  Future<void> playNextAya() async {
    _currentAyaIndex++;
    notifyListeners();
    if (_currentAyaIndex < _currentAyas!.length) {
      await _playCurrentAya();
    }
  }

  Future<void> playPreviousAya() async {
    if (_currentAyas == null) return;

    _currentAyaIndex = (_currentAyaIndex - 1) % _currentAyas!.length;
    await _playCurrentAya();
  }

  Future<void> toggleLoopMode() async {
    _loopMode = !_loopMode;
    await _audioPlayer.setLoopMode(_loopMode ? LoopMode.one : LoopMode.off);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _audioPlayer.setSpeed(speed);
  }

  String _getAyaAudioUrl(String suraIndex, String ayaIndex) {
    return "${_baseUrl}afasy/${suraIndex.padLeft(3, '0')}${ayaIndex.padLeft(3, '0')}$_audioFormat";
  }

  Future<void> play() async {
    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> seek(Duration position) => _audioPlayer.seek(position);

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
