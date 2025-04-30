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
                                  arabicText: aya.text,
                                  translationText: ayaTranslation.text,
                                  reference:
                                      "Surah ${widget.sura.name} • ${widget.sura.index} ${aya.index}",
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
    showNotesEditorSheet(
      context,
      surahNumber: widget.sura.index,
      ayahNumber: ayahNumber,
      existingNote: existingNote,
    );

    setState(() {}); // Refresh the UI
  }
}
