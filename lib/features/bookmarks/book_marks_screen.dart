import 'dart:developer';

import 'package:al_quran/features/al_quran/screens/sura_aya_wise_screen.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/bookmarks/book_mark_model.dart';
import 'package:al_quran/features/bookmarks/book_marks_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final BookmarkDatabaseHelper _dbHelper = BookmarkDatabaseHelper.instance;
  late Future<List<Bookmark>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = _getBookmarks();
  }

  Future<List<Bookmark>> _getBookmarks() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getAllBookmarks();
    return List.generate(maps.length, (i) {
      return Bookmark.fromMap(maps[i]);
    });
  }

  Future<void> _refreshBookmarks() async {
    setState(() {
      _bookmarksFuture = _getBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quranVM = context.read<QuranViewModel>();

    var quranData = quranVM.quranData;
    final quranMetaData = quranVM.quranMetaData;
    final quranTranslationData = quranVM.quranTranslationData;
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks')),
      body: RefreshIndicator(
        onRefresh: _refreshBookmarks,
        child: FutureBuilder<List<Bookmark>>(
          future: _bookmarksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading bookmarks'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No bookmarks yet'));
            }

            final bookmarks = snapshot.data!;
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return ListTile(
                  leading: Icon(
                    bookmark.type == 'surah' ? Icons.book : Icons.bookmark,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    bookmark.type == 'surah'
                        ? 'Surah ${bookmark.surahNumber}'
                        : 'Surah ${bookmark.surahNumber}:${bookmark.ayahNumber}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await _dbHelper.removeBookmark(
                        type: bookmark.type,
                        surahNumber: bookmark.surahNumber,
                        ayahNumber: bookmark.ayahNumber,
                      );
                      _refreshBookmarks();
                    },
                  ),
                 onTap: () {
                    log('Bookmark tapped: ${bookmark.type} ${bookmark.surahNumber}:${bookmark.ayahNumber}');
                    var i = bookmark.surahNumber - 1;
                    final sura = quranData[i];
                    final suraMetaData = quranMetaData[i];
                    final suraTranslation = quranTranslationData[i];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AyahPage(
                            sura: sura,
                            suraMetaData: suraMetaData,
                            suraTranslation: suraTranslation,
                            initialAyahIndex: bookmark.ayahNumber),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
