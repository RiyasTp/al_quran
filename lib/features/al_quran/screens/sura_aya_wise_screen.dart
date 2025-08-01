import 'package:al_quran/design_system/icons/cusotm_svg_icon.dart';
import 'package:al_quran/design_system/icons/svg_icons.dart';
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/quran_data_wise_screen.dart';
import 'package:al_quran/features/al_quran/screens/sheets_and_alerts/copy_aya_bottom_sheet.dart';
import 'package:al_quran/features/al_quran/widgets/aya_rich_text_widget.dart';
import 'package:al_quran/features/al_quran/widgets/bismillah_widget.dart';
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:al_quran/features/al_quran/widgets/custom_icon_button.dart';
import 'package:al_quran/features/audio_plyer/quran_audio_player.dart';
import 'package:al_quran/features/bookmarks/book_marks_db_helper.dart';
import 'package:al_quran/features/bookmarks/book_marks_title_sheet.dart';
import 'package:al_quran/features/notes/edit_notes_bottom_sheet.dart';
import 'package:al_quran/features/notes/notes_list_bottom_sheet.dart';
import 'package:al_quran/features/notes/notes_view_model.dart';
import 'package:al_quran/features/settings/settings_screen.dart';
import 'package:al_quran/features/settings/settings_view_model.dart';
import 'package:al_quran/main.dart';
import 'package:al_quran/utils/analytics/export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AyahPage extends StatefulWidget {
  final Sura sura;
  final SuraMetaData suraMetaData;
  final SuraTranslation suraTranslation;
  final int? initialAyahIndex;

  const AyahPage(
      {super.key,
      required this.suraMetaData,
      required this.sura,
      required this.suraTranslation,
      this.initialAyahIndex});

  @override
  State<AyahPage> createState() => _AyahPageState();
}

class _AyahPageState extends State<AyahPage> {
  final _dbHelper = BookmarkDatabaseHelper.instance;
  // final _notesDbHelper = NotesDatabaseHelper.instance;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late final QuranAudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = QuranAudioPlayer();

    audioPlayer.init();
    audioPlayer.addListener(() {
      if (audioPlayer.isPlaying) {
        _scrollToAyah(audioPlayer.currentAyyaIndex);
      }
    });

    final initialIndex = widget.initialAyahIndex != null
        ? widget.sura.ayas
            .indexWhere((aya) => aya.index == widget.initialAyahIndex)
        : 0;
    if (initialIndex > 0) {
      _jumpToAyah(initialIndex);
    }

    // Log the event for opening the Surah
    AppAnalytics.logScreenView(
      screenName: 'Sura ${widget.sura.index}: ${widget.suraMetaData.tname}',
      screenClass: 'SuraPage',
      parameters: {
        'sura_number': widget.sura.index,
        'sura_name': widget.suraMetaData.tname,
        'current_ayah_index': initialIndex,
      },
    );
  }

  // Future<void> _playSurahFromStart() async {
  //   await audioPlayer.playSurah(widget.sura);
  // }

  Future<void> _playAya(Aya aya, int index) async {
    audioPlayer.playSurah(widget.sura, startAya: index);
  }

  bool readMode = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => audioPlayer,
      child: Scaffold(
        bottomNavigationBar: QuranPlayerControls(
          audioPlayer: audioPlayer,
        ),
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                Theme.of(context).textTheme.displaySmall?.fontSize ?? 35),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.sura.index.toString()}. ${widget.suraMetaData.tname}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(widget.sura.index.toString().padLeft(3, '0'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontFamily: 'Sura Names')),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                const Text("Read Mode"),
                Transform.scale(
                  scale: 0.6,
                  child: Switch.adaptive(
                    value: readMode,
                    onChanged: (val) {
                      audioPlayer.stop();
                      setState(() => readMode = val);

                      // Log the event for toggling read mode
                      AppAnalytics.logEvent(
                        event: val
                            ? AnalyticsEvent.readModeEnabled
                            : AnalyticsEvent.readModeDisabled,
                        parameters: {
                          'read_mode': val,
                          'sura_number': widget.sura.index,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SettingsBottomSheet();
                    },
                  );
                },
                icon: CustomSvgIcon(icon: SvgIcons.settings)),
            // DownloadButton(sura: widget.sura),
          ],
        ),
        body: readMode
            ? QuranTypeWisePageContentBuilder(page: QuranSura.sura(widget.sura))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ScrollablePositionedList.builder(
                  itemPositionsListener: itemPositionsListener,
                  itemScrollController: itemScrollController,
                  itemBuilder: (context, index) {
                    final aya = widget.sura.ayas[index];
                    final ayaTranslation = widget.suraTranslation.ayas[index];

                    var richText = AyaRichText(aya: aya);

                    var settings2 =
                        context.read<AppSettingsViewModel>().settings;
                    final translationFontFactor = context
                        .watch<AppSettingsViewModel>()
                        .settings
                        .translationFontSize;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 10),
                        if (aya.bismillah != null) BismillahWidget(),
                        richText,
                        if (settings2.showTaranslation)
                          Text(ayaTranslation.text,
                              textScaler:
                                  TextScaler.linear(translationFontFactor)),
                        const SizedBox(height: 4),
                        Consumer<QuranAudioPlayer>(
                            builder: (context, audioPlayer, child) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                color: (audioPlayer.currentAyyaIndex == index &&
                                        audioPlayer.isPlaying)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomIconButton(
                                  child: Text(aya.index.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                ),
                                Row(
                                  children: [
                                    CustomIconButton(
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        size: 22,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    CustomIconButton(
                                      child: Icon(
                                        Icons.copy,
                                        size: 22,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onTap: () {
                                        showCopyBottomSheet(
                                          context,
                                          arabicText: aya.text +
                                              nonBreakSpaceChar +
                                              toArabicNumerals(aya.index),
                                          translationText: ayaTranslation.text,
                                          translationReference:
                                              "Surah ${widget.suraMetaData.tname} (${widget.suraMetaData.ename})  ${widget.sura.index} : ${aya.index} - ${context.read<AppSettingsViewModel>().settings.translationAuthor}",
                                          arabicReference:
                                              "سورة$nonBreakSpaceChar${widget.sura.name}$nonBreakSpaceChar•$nonBreakSpaceChar${toArabicNumerals(widget.sura.index)}$nonBreakSpaceChar:$nonBreakSpaceChar${toArabicNumerals(aya.index)}",
                                        );
                                      },
                                    ),
                                    FutureBuilder(
                                        future: context
                                            .read<NotesViewModel>()
                                            .hasNotesForAyah(
                                                widget.sura.index, aya.index),
                                        builder: (context, snapshot) {
                                          final hasNote =
                                              snapshot.data ?? false;
                                          return CustomIconButton(
                                            child: Icon(
                                              hasNote
                                                  ? Icons.sticky_note_2_rounded
                                                  : Icons
                                                      .sticky_note_2_outlined,
                                              size: 22,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onTap: () => _handleNoteAction(
                                                aya.index, hasNote),
                                          );
                                        }),
                                    FutureBuilder<bool>(
                                        future: _dbHelper.isBookmarked(
                                          type: 'ayah',
                                          surahNumber: widget.sura.index,
                                          ayahNumber: aya.index,
                                        ),
                                        builder: (context, snapshot) {
                                          final isBookmarked =
                                              snapshot.data ?? false;
                                          return CustomIconButton(
                                            child: Icon(
                                              isBookmarked
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              size: 22,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onTap: () =>
                                                _toggleAyahBookmark(aya.index),
                                          );
                                        }),
                                    CustomIconButton(
                                      child: Icon(
                                        audioPlayer.currentAyyaIndex == index &&
                                                audioPlayer.isPlaying
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_outline,
                                        size: 22,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onTap: () {
                                        if (audioPlayer.currentAyyaIndex ==
                                                index &&
                                            audioPlayer.isPlaying) {
                                          audioPlayer.pause();
                                        } else {
                                          _playAya(aya, index);
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                        divider,
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                  itemCount: widget.sura.ayas.length,
                ),
              ),
      ),
    );
  }

  void _jumpToAyah(int ayahIndex) {
    Future.delayed(Duration.zero, () {
      if (ayahIndex >= 0 && ayahIndex < widget.sura.ayas.length) {
        itemScrollController.jumpTo(
          index: ayahIndex,
        );
      }
    });
  }

  void _scrollToAyah(int ayahIndex) {
    final visibleIndexes = itemPositionsListener.itemPositions.value
        .where((item) => item.itemLeadingEdge < 1 && item.itemTrailingEdge > 0)
        .map((item) => item.index)
        .toList();
    var ayaLength = widget.sura.ayas.length;
    if (visibleIndexes.contains(ayaLength - 1) && ayahIndex != ayaLength - 1) {
      return;
    }
    Future.delayed(Duration.zero, () {
      if (ayahIndex >= 0 && ayahIndex < ayaLength) {
        itemScrollController.scrollTo(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          index: ayahIndex,
        );
      }
    });
  }

  Future<void> _toggleAyahBookmark(int ayahNumber) async {
    final isBookmarked = await _dbHelper.isBookmarked(
      type: 'ayah',
      surahNumber: widget.sura.index,
      ayahNumber: ayahNumber,
    );

    if (isBookmarked) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Bookmark'),
            content: Text('Are you sure you want to delete this bookmark?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete'),
              ),
            ],
          );
        },
      );

      if (confirmed != true) {
        return;
      }
      await _dbHelper.removeBookmark(
        type: 'ayah',
        surahNumber: widget.sura.index,
        ayahNumber: ayahNumber,
      );
      // Log the event for removing bookmark
      AppAnalytics.logEvent(
        event: AnalyticsEvent.bookMarkRemoved,
        parameters: {
          'surah_number': widget.sura.index,
          'ayah_number': ayahNumber,
        },
      );
    } else {
      await showBookmarksTitleSheet(
        context,
        surahNumber: widget.sura.index,
        ayahNumber: ayahNumber,
        onSave: (String? title) async {
          await _dbHelper.addBookmark(
            type: 'ayah',
            title: title,
            surahNumber: widget.sura.index,
            ayahNumber: ayahNumber,
          );
          // Log the event for adding bookmark
          AppAnalytics.logEvent(
            event: AnalyticsEvent.bookMarkAdded,
            parameters: {
              'surah_number': widget.sura.index,
              'ayah_number': ayahNumber,
            },
          );
        },
      );
    }
    setState(() {});
  }

  Future<void> _handleNoteAction(int ayahNumber, bool hasNotes) async {
    if (hasNotes) {
      showNotesListBottomSheet(
        context,
        suraNumber: widget.sura.index,
        ayahNumber: ayahNumber,
      );
      return;
    }

    await showNotesEditorSheet(
      context,
      surahNumber: widget.sura.index,
      ayahNumber: ayahNumber,
      existingNote: null,
    );
    return;
  }
}

class QuranPlayerControls extends StatefulWidget {
  final QuranAudioPlayer audioPlayer;

  const QuranPlayerControls({
    super.key,
    required this.audioPlayer,
  });

  @override
  createState() => _QuranPlayerControlsState();
}

class _QuranPlayerControlsState extends State<QuranPlayerControls> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.audioPlayer.canShowControls) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(),
          Text(
            'Surah ${widget.audioPlayer.currentSura?.index}:${widget.audioPlayer.currentAya}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: _playPreviousAya,
                iconSize: 30,
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 36,
                ),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: _playNextAya,
                iconSize: 30,
              ),
              IconButton(
                icon: Icon(Icons.repeat),
                onPressed: _toggleRepeatMode,
                color: widget.audioPlayer.loopMode ? Colors.blue : null,
              ),
              IconButton(
                icon: Icon(Icons.speed),
                onPressed: _showSpeedDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: widget.audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = widget.audioPlayer.duration ?? Duration.zero;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(widget.audioPlayer.position),
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  _formatDuration(widget.audioPlayer.duration),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: duration.inSeconds.toDouble(),
              onChanged: (value) {
                widget.audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _togglePlayPause() async {
    _isPlaying
        ? await widget.audioPlayer.pause()
        : await widget.audioPlayer.play();
  }

  Future<void> _playNextAya() async {
    await widget.audioPlayer.playNextAya();
  }

  Future<void> _playPreviousAya() async {
    await widget.audioPlayer.playPreviousAya();
  }

  Future<void> _toggleRepeatMode() async {
    await widget.audioPlayer.toggleLoopMode();
    setState(() {});
  }

  Future<void> _showSpeedDialog() async {
    final speed = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Playback Speed'),
          children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, speed),
              child: Text(
                '${speed}x',
                style: TextStyle(
                  color: widget.audioPlayer.playbackSpeed == speed
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    if (speed != null) {
      await widget.audioPlayer.setPlaybackSpeed(speed);
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class DownloadButton extends StatelessWidget {
  final Sura sura;

  const DownloadButton({
    super.key,
    required this.sura,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranAudioPlayer>();
    try {
      return FutureBuilder<bool>(
        future: vm.downloadManger.isSurahDownloaded(sura.index, 'afasy'),
        builder: (context, snapshot) {
          final isDownloaded = snapshot.data ?? false;

          return IconButton(
            icon: Icon(isDownloaded ? Icons.download_done : Icons.download),
            onPressed: () async {
              if (isDownloaded) {
                // Option to delete downloaded surah
                _confirmDelete(context);
              } else {
                await _downloadSurah(context, vm.downloadManger);
              }
            },
          );
        },
      );
    } catch (e) {
      return CircularProgressIndicator();
    }
  }

  Future<void> _downloadSurah(
      BuildContext context, QuranDownloadManager downloadManager) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      await downloadManager.downloadSurah(
        sura: sura,
        surahNumber: sura.index,
        reciter: 'afasy',
        onProgress: (count, total) {
          // Show download progress
          scaffold.showSnackBar(SnackBar(
            content: LinearProgressIndicator(value: count / total),
            duration: Duration(days: 1),
          ));
        },
      );
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(SnackBar(content: Text('Download completed')));
    } catch (e) {
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete downloaded surah?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteSurah(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSurah(BuildContext context) async {
    // final dir = Directory(
    //   '${downloadManager._cachePath}/afasy/$surahNumber'
    // );
    // if (await dir.exists()) {
    //   await dir.delete(recursive: true);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Surah deleted')),
    //   );
    // }
  }
}
