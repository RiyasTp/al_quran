import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/sheets_and_alerts/copy_aya_bottom_sheet.dart';
import 'package:al_quran/features/al_quran/widgets/aya_rich_text_widget.dart';
import 'package:al_quran/features/al_quran/widgets/bismillah_widget.dart';
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:al_quran/features/al_quran/widgets/custom_icon_button.dart';
import 'package:al_quran/features/audio_plyer/quran_audio_player.dart';
import 'package:al_quran/features/bookmarks/book_marks_db_helper.dart';
import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/edit_notes_bottom_sheet.dart';
import 'package:al_quran/main.dart';
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
  final _notesDbHelper = NotesDatabaseHelper.instance;
  final ItemScrollController itemScrollController = ItemScrollController();

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
      _jumpToAyah(audioPlayer.currentAyyaIndex);
    }
  }

  Future<void> _playSurahFromStart() async {
    await audioPlayer.playSurah(widget.sura);
  }

  Future<void> _playAya(Aya aya, int index) async {
    audioPlayer.playSurah(widget.sura, startAya: index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => audioPlayer,
      // builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
      //   value: SystemUiOverlayStyle.light,
      //   child: WillPopScope(
      //     onWillPop: () async {
      //       audioPlayer.stop();
      //       return true;
      //     },
      //     child: _buildAyahPage(context),
      //   ),
      // ),
      child: Scaffold(
        bottomNavigationBar: QuranPlayerControls(
          audioPlayer: audioPlayer,
        ),
        appBar: AppBar(
          elevation: 0,
          title: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                TextSpan(
                  text: '${widget.sura.index.toString()}. ',
                ),
                TextSpan(text: '${widget.suraMetaData.tname}|'),
                TextSpan(
                    text: widget.sura.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemBuilder: (context, index) {
              final aya = widget.sura.ayas[index];
              final ayaTranslation = widget.suraTranslation.ayas[index];

              var richText = AyaRichText(aya: aya);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  if (aya.bismillah != null) BismillahWidget(),
                  richText,
                  Text(ayaTranslation.text),
                  const SizedBox(height: 4),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          child: Text(aya.index.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 22,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            CustomIconButton(
                              child: Icon(
                                Icons.copy,
                                size: 22,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onTap: () {
                                showCopyBottomSheet(
                                  context,
                                  arabicText: aya.text +
                                      nonBreakSpaceChar +
                                      toArabicNumerals(aya.index),
                                  translationText: ayaTranslation.text,
                                  translationReference:
                                      "Surah ${widget.suraMetaData.tname} (${widget.suraMetaData.ename})  ${widget.sura.index} : ${aya.index}",
                                  arabicReference:
                                      "سورة$nonBreakSpaceChar${widget.sura.name}$nonBreakSpaceChar•$nonBreakSpaceChar${toArabicNumerals(widget.sura.index)}$nonBreakSpaceChar:$nonBreakSpaceChar${toArabicNumerals(aya.index)}",
                                );
                              },
                            ),
                            CustomIconButton(
                              child: FutureBuilder<bool>(
                                  future: _notesDbHelper.hasNoteForAyah(
                                      widget.sura.index, aya.index),
                                  builder: (context, snapshot) {
                                    final hasNote = snapshot.data ?? false;
                                    return Icon(
                                      hasNote
                                          ? Icons.sticky_note_2_rounded
                                          : Icons.sticky_note_2_outlined,
                                      size: 22,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    );
                                  }),
                              onTap: () => _handleNoteAction(aya.index),
                            ),
                            FutureBuilder<bool>(
                                future: _dbHelper.isBookmarked(
                                  type: 'ayah',
                                  surahNumber: widget.sura.index,
                                  ayahNumber: aya.index,
                                ),
                                builder: (context, snapshot) {
                                  final isBookmarked = snapshot.data ?? false;
                                  return CustomIconButton(
                                    child: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 22,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () => _toggleAyahBookmark(aya.index),
                                  );
                                }),
                            Consumer<QuranAudioPlayer>(
                              builder: (context, audioPlayer, child) {
                                return CustomIconButton(
                                  child: Icon(
                                    audioPlayer.currentAyyaIndex == index &&
                                            audioPlayer.isPlaying
                                        ? Icons.pause_circle_outline
                                        : Icons.play_circle_outline,
                                    size: 22,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onTap: () {
                                    if (audioPlayer.currentAyyaIndex == index &&
                                        audioPlayer.isPlaying) {
                                      audioPlayer.pause();
                                    } else {
                                      _playAya(aya, index);
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
    Future.delayed(Duration.zero, () {
      if (ayahIndex >= 0 && ayahIndex < widget.sura.ayas.length) {
        itemScrollController.scrollTo(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
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
      await _dbHelper.removeBookmark(
        type: 'ayah',
        surahNumber: widget.sura.index,
        ayahNumber: ayahNumber,
      );
    } else {
      await _dbHelper.addBookmark(
        type: 'ayah',
        surahNumber: widget.sura.index,
        ayahNumber: ayahNumber,
      );
    }
    setState(() {});
  }

  Future<void> _handleNoteAction(int ayahNumber) async {
    final existingNote = await _notesDbHelper.getNoteForAyah(
      widget.sura.index,
      ayahNumber,
    );
    if(!context.mounted) return; 
    await showNotesEditorSheet(
      context,   // ignore: use_build_context_synchronously
      surahNumber: widget.sura.index,
      ayahNumber: ayahNumber,
      existingNote: existingNote,
    );

    setState(() {}); // Refresh the UI
  }
}

class QuranPlayerControls extends StatefulWidget {
  final QuranAudioPlayer audioPlayer;

  const QuranPlayerControls({super.key, 
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
