import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class QuranAudioPlayer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final QuranAudioCache _audioCache;
  late final QuranDownloadManager _downloadManager;
  get downloadManger => _downloadManager;

  static const String _baseUrl = 'https://tanzil.net/res/audio/';
  String reciterName = 'afasy';
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
  
  bool initilized = false;
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    final cacheDir = await getApplicationDocumentsDirectory();
    final cachePath = '${cacheDir.path}/quran_audio_cache';
    _downloadManager = QuranDownloadManager(cachePath: cachePath);
    _audioCache = QuranAudioCache(QuranDownloadManager(cachePath: cachePath));
   initilized = true;
    notifyListeners();
  }

  get isPlaying => _audioPlayer.playing;

Future<void> playSurah(Sura sura, {int startAya = 0}) async {
    _currentSura = sura;
    _currentAyas = sura.ayas;
    _currentAyaIndex = startAya;

    // Check if surah is downloaded
    final isDownloaded = await _downloadManager.isSurahDownloaded(
      sura.index,
      reciterName,
    );

    if (isDownloaded) {
      _playFromCache();
    } else {
      _playWithStreaming();
    }
  }

  Future<void> _playFromCache() async {
    final source = await _audioCache.getAyaAudio(
      surahNumber: _currentSura!.index,
      ayaNumber: _currentAyas![_currentAyaIndex].index,
      reciter: reciterName,
    );

    await _audioPlayer.setAudioSource(source);
    _setupPlayerListeners();
    await _audioPlayer.play();

    // Preload next aya
    if (_currentAyaIndex + 1 < _currentAyas!.length) {
      await _audioCache.preloadNextAya(
        surahNumber: _currentSura!.index,
        currentAyaNumber: _currentAyas![_currentAyaIndex].index,
        reciter: reciterName,
      );
    }
  }

  Future<void> _playWithStreaming() async {
    final audioUrl = _getAyaAudioUrl(
      _currentSura!.index.toString(),
      _currentAyas![_currentAyaIndex].index.toString(),
    );

    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
    _setupPlayerListeners();
    await _audioPlayer.play();

    // For streaming, still try to cache the next aya
    if (_currentAyaIndex + 1 < _currentAyas!.length) {
      unawaited(_audioCache.getAyaAudio(
        surahNumber: _currentSura!.index,
        ayaNumber: _currentAyas![_currentAyaIndex + 1].index,
        reciter: reciterName,
        preload: true,
      ));
    }
  }

  void _setupPlayerListeners() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
      if (state.processingState == ProcessingState.completed) {
        _handlePlaybackCompletion();
      }
    });
  }

  Future<void> _handlePlaybackCompletion() async {
    if (_currentAyaIndex + 1 < _currentAyas!.length) {
      _currentAyaIndex++;
      await _playFromCache(); // Will use cache if available
    } else if (_loopMode) {
      _currentAyaIndex = 0;
      await _playFromCache();
    }
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

class QuranDownloadManager {
  final Dio _dio = Dio();
  final String _baseUrl;
  final String _cachePath;

  QuranDownloadManager(
      {required String cachePath,
      String baseUrl = 'https://tanzil.net/res/audio/'})
      : _cachePath = cachePath,
        _baseUrl = baseUrl;

  Future<String> downloadSurah({
    required Sura sura,
    required int surahNumber,
    required String reciter,
    ProgressCallback? onProgress,
  }) async {
    final surahDir = await _getSurahDirectory(surahNumber, reciter);
    final surahInfo = sura; // You'll need to implement this

    final downloads = <Future>[];

    for (final aya in surahInfo.ayas) {
      downloads.add(_downloadAya(
        surahNumber: surahNumber,
        ayaNumber: aya.index,
        reciter: reciter,
        targetDir: surahDir,
        onProgress: (count, total) {
          // Calculate overall progress
          final progress = /* logic to calculate overall progress */ 0;
          onProgress?.call(progress, total);
        },
      ));
    }

    await Future.wait(downloads);
    return surahDir.path;
  }

  Future<Directory> _getSurahDirectory(int surahNumber, String reciter) async {
    final dir = Directory('$_cachePath/$reciter/$surahNumber');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _downloadAya({
    required int surahNumber,
    required int ayaNumber,
    required String reciter,
    required Directory targetDir,
    ProgressCallback? onProgress,
  }) async {
    final url = _getAyaUrl(surahNumber, ayaNumber, reciter);
    final file =
        File('${targetDir.path}/${ayaNumber.toString().padLeft(3, '0')}.mp3');

    if (await file.exists()) return file;

    await _dio.download(
      url,
      file.path,
      onReceiveProgress: onProgress,
    );

    return file;
  }

  String _getAyaUrl(int surahNumber, int ayaNumber, String reciter) {
    return '$_baseUrl$reciter/'
        '${surahNumber.toString().padLeft(3, '0')}'
        '${ayaNumber.toString().padLeft(3, '0')}.mp3';
  }

  Future<bool> isSurahDownloaded(int surahNumber, String reciter) async {
    final dir = Directory('$_cachePath/$reciter/$surahNumber');
    if (!await dir.exists()) return false;

    final files = await dir.list().toList();
    return files.isNotEmpty;
  }
}

class QuranAudioCache {
  final QuranDownloadManager _downloadManager;
  final Map<String, AudioSource> _memoryCache = {};
  final int _maxCacheSize = 10; // Number of ayas to keep in memory

  QuranAudioCache(this._downloadManager);

  Future<AudioSource> getAyaAudio({
    required int surahNumber,
    required int ayaNumber,
    required String reciter,
    bool preload = false,
  }) async {
    final cacheKey = '$reciter/$surahNumber/$ayaNumber';

    // Check memory cache first
    if (_memoryCache.containsKey(cacheKey)) {
      return _memoryCache[cacheKey]!;
    }

    // Check disk cache
    final file = File('${_downloadManager._cachePath}/$cacheKey.mp3');
    if (await file.exists()) {
      final source = AudioSource.uri(Uri.file(file.path));
      _addToMemoryCache(cacheKey, source);
      return source;
    }

    // If not cached and not preloading, download immediately
    if (!preload) {
      final downloadedFile = await _downloadManager._downloadAya(
        surahNumber: surahNumber,
        ayaNumber: ayaNumber,
        reciter: reciter,
        targetDir:
            await _downloadManager._getSurahDirectory(surahNumber, reciter),
      );
      final source = AudioSource.uri(Uri.file(downloadedFile.path));
      _addToMemoryCache(cacheKey, source);
      return source;
    }

    // For preloading, return a placeholder that will be replaced
    return AudioSource.uri(Uri.parse(''));
  }

  void _addToMemoryCache(String key, AudioSource source) {
    if (_memoryCache.length >= _maxCacheSize) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[key] = source;
  }

  Future<void> preloadNextAya({
    required int surahNumber,
    required int currentAyaNumber,
    required String reciter,
  }) async {
    final nextAyaNumber = currentAyaNumber + 1;
    await getAyaAudio(
      surahNumber: surahNumber,
      ayaNumber: nextAyaNumber,
      reciter: reciter,
      preload: true,
    );
  }
}
