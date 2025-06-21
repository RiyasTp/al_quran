
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/sura_aya_wise_screen.dart';
import 'package:flutter/material.dart';

class SearchQuranWidget extends StatelessWidget {
  const SearchQuranWidget({
    super.key,
    required this.sc,
    required this.quranData,
    required this.quranMetaData,
    required this.quranTranslationData,
  });

  final SearchController sc;
  final List<Sura> quranData;
  final List<SuraMetaData> quranMetaData;
  final List<SuraTranslation> quranTranslationData;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: sc,
      builder: (context, controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => controller.openView(),
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text.trim();
        final suggestions = <Widget>[];

        // Parse search query patterns
        if (query.contains(':')) {
          // Handle Surah:Ayah search (e.g., "2:1")
          final parts = query.split(':');
          if (parts.length == 2) {
            final surahNum = int.tryParse(parts[0]);
            final ayahNum = int.tryParse(parts[1]);

            if (surahNum != null && ayahNum != null) {
              // Find matching Surah
              final surah = quranData.firstWhere(
                (s) => s.index == surahNum,
                orElse: () => Sura(index: -1, name: '', ayas: []),
              );

              if (surah.index != -1) {
                // Find exact Ayah match
                final exactAyah = surah.ayas.firstWhere(
                  (a) => a.index == ayahNum,
                  orElse: () => Aya(index: -1, text: ''),
                );

                if (exactAyah.index != -1) {
                  suggestions.add(
                    ListTile(
                      title: Text(
                          "$surahNum:$ayahNum - ${exactAyah.text.substring(0, 30)}..."),
                      subtitle: Text("Surah ${surah.name}"),
                      onTap: () {
                        final suraMetaData = quranMetaData[surah.index - 1];
                        final suraTranslation =
                            quranTranslationData[surah.index - 1];
                        controller.closeView("Surah $surahNum");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AyahPage(
                              sura: surah,
                              suraMetaData: suraMetaData,
                              suraTranslation: suraTranslation,
                              initialAyahIndex: ayahNum,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                // Find Ayah ranges (e.g., 2:10-19)
                final rangeMatches = surah.ayas.where((a) {
                  return a.index.toString().startsWith(ayahNum.toString()) ||
                      (a.index >= ayahNum * 10 && a.index < (ayahNum + 1) * 10);
                }).take(5);

                for (final aya in rangeMatches) {
                  suggestions.add(
                    ListTile(
                      title: Text(
                          "$surahNum:${aya.index} - ${aya.text.substring(0, 30)}..."),
                      subtitle: Text("Surah ${surah.name}"),
                      onTap: () {
                        controller.closeView("Surah ${surah.index}");
                        final suraMetaData = quranMetaData[surah.index - 1];
                        final suraTranslation =
                            quranTranslationData[surah.index - 1];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AyahPage(
                              sura: surah,
                              suraMetaData: suraMetaData,
                              suraTranslation: suraTranslation,
                              initialAyahIndex: aya.index,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            }
          }
        } else {
          // Handle Surah number search (e.g., "2")
          final number = int.tryParse(query);
          if (number != null) {
            // Exact Surah match
            final exactSurah = quranData.firstWhere(
              (s) => s.index == number,
              orElse: () => Sura(index: -1, name: '', ayas: []),
            );

            if (exactSurah.index != -1) {
              suggestions.add(
                ListTile(
                  title: Text("Surah $number: ${exactSurah.name}"),
                  onTap: () {
                    final suraMetaData = quranMetaData[number - 1];
                    final suraTranslation = quranTranslationData[number - 1];
                    controller.closeView("Surah $number");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AyahPage(
                          sura: exactSurah,
                          suraMetaData: suraMetaData,
                          suraTranslation: suraTranslation,
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            // Surah ranges (e.g., 10-19 when searching "1")
            final rangeSurahs = quranData.where((s) {
              return s.index.toString().startsWith(query) ||
                  (s.index >= number * 10 && s.index < (number + 1) * 10) ||
                  (number == 1 && s.index >= 100); // Special case for 100-114
            }).take(5);

            for (final surah in rangeSurahs) {
              suggestions.add(
                ListTile(
                  title: Text("Surah ${surah.index}: ${surah.name}"),
                  onTap: () {
                    controller.closeView("Surah ${surah.index}");
                    final suraMetaData = quranMetaData[surah.index - 1];
                    final suraTranslation =
                        quranTranslationData[surah.index - 1];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AyahPage(
                          sura: exactSurah,
                          suraMetaData: suraMetaData,
                          suraTranslation: suraTranslation,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        }

        return suggestions;
      },
    );
  }
}