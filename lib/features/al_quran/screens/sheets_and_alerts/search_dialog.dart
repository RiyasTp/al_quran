
import 'package:al_quran/design_system/icons/cusotm_svg_icon.dart';
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/sura_aya_wise_screen.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/icons/svg_icons.dart';
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

  /// Navigates to the AyahPage.
  /// This helper method avoids code duplication in the suggestions builder.
  void _navigateToAyahPage(
    BuildContext context,
    SearchController controller,
    Sura sura, {
    int? initialAyahIndex,
  }) {
    // Safely get metadata and translation data.
    final metaData = quranMetaData.firstWhere((m) => m.index == sura.index);
    final translation =
        quranTranslationData.firstWhere((t) => t.index == sura.index);

    final viewLabel = initialAyahIndex != null
        ? '${sura.index}:$initialAyahIndex'
        : 'Surah ${sura.index}';
    controller.closeView(viewLabel);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AyahPage(
          sura: sura,
          suraMetaData: metaData,
          suraTranslation: translation,
          initialAyahIndex: initialAyahIndex ?? 1, // Default to first Ayah
        ),
      ),
    );
  }

  /// Builds suggestions for queries like "2:15" (Surah:Ayah).
  List<Widget> _buildAyahSuggestions(
      String query, BuildContext context, SearchController controller) {
    final parts = query.split(':');
    if (parts.length != 2) return [];

    final surahNum = int.tryParse(parts[0]);
    final ayahNum = int.tryParse(parts[1]);

    if (surahNum == null ||
        ayahNum == null ||
        surahNum <= 0 ||
        surahNum > 114) {
      return [];
    }

    final Sura? surah = quranData.firstWhere((s) => s.index == surahNum);
    if (surah == null) return [];

    // Find ayahs that match or start with the queried number.
    return surah.ayas
        .where((aya) => aya.index.toString().startsWith(ayahNum.toString()))
        .take(5) // Limit results for performance and UI clarity.
        .map((aya) {
      return ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(
          '${surah.name} ${surah.index}:${aya.index}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          aya.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => _navigateToAyahPage(context, controller, surah,
            initialAyahIndex: aya.index),
      );
    }).toList();
  }

  /// Builds suggestions for queries like "112" (Surah number).
  List<Widget> _buildSurahSuggestions(
      String query, BuildContext context, SearchController controller) {
    // Find surahs that match or start with the queried number.
    return quranData
        .where((sura) => sura.index.toString().startsWith(query))
        .take(5)
        .map((sura) {
      return ListTile(
        leading: const Icon(Icons.bookmark),
        title: Text('Surah ${sura.index}: ${sura.name}'),
        subtitle:
            Text(quranMetaData[sura.index - 1].tname), // Translated name
        onTap: () => _navigateToAyahPage(context, controller, sura),
      );
    }).toList();
  }

  /// Builds suggestions for text queries (e.g., "merciful").
  List<Widget> _buildTextSearchSuggestions(
      String query, BuildContext context, SearchController controller) {
    if (query.length < 3) return []; // Avoid searching for very short strings.

    final results = <Widget>[];
    final normalizedQuery = query.toLowerCase();

    // Limit the search to a reasonable number of results to avoid UI lag.
    const resultLimit = 10;

    for (final sura in quranData) {
      if (results.length >= resultLimit) break;

      // Also search in the corresponding translation
      final translation = quranTranslationData[sura.index - 1];

      for (final aya in sura.ayas) {
        if (results.length >= resultLimit) break;
        final ayaTranslationText = translation.ayas[aya.index - 1].text;

        if (aya.text.toLowerCase().contains(normalizedQuery) ||
            ayaTranslationText.toLowerCase().contains(normalizedQuery)) {
          results.add(
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: Text('Found in ${sura.name} ${sura.index}:${aya.index}'),
              subtitle: Text(
                aya.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _navigateToAyahPage(context, controller, sura,
                  initialAyahIndex: aya.index),
            ),
          );
        }
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: sc,
      builder: (context, controller) {
        return IconButton(
          icon: const CustomSvgIcon(icon: SvgIcons.search),
          tooltip: 'Search Quran',
          onPressed: () => controller.openView(),
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text.trim();
        if (query.isEmpty) {
          return [
            const ListTile(
                title: Text('Search by Surah name, number (e.g., 2), or Ayah (e.g., 2:153)'))
          ];
        }

        List<Widget> suggestions;

        if (query.contains(':')) {
          suggestions = _buildAyahSuggestions(query, context, controller);
        } else if (int.tryParse(query) != null) {
          suggestions = _buildSurahSuggestions(query, context, controller);
        } else {
          suggestions = _buildTextSearchSuggestions(query, context, controller);
        }

        if (suggestions.isEmpty) {
          return [ListTile(title: Text('No results found for "$query"'))];
        }

        return suggestions;
      },
    );
  }
}