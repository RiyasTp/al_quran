import 'package:al_quran/features/about/about_screen.dart';
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/quran_data_wise_screen.dart';
import 'package:al_quran/features/al_quran/screens/sheets_and_alerts/search_dialog.dart';
import 'package:al_quran/features/al_quran/screens/sura_aya_wise_screen.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({
    super.key,
  });

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final SearchController sc = SearchController();

  @override
  Widget build(BuildContext context) {
    final quranVM = context.watch<QuranViewModel>();
    var quranData = quranVM.quranData;
    final quranMetaData = quranVM.quranMetaData;
    final quranTranslationData = quranVM.quranTranslationData;
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              },
              icon: const Icon(Icons.menu)),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Sura'),
                Tab(text: 'Page'),
                Tab(text: 'Juz'),
                Tab(text: 'Hizb'),
                Tab(text: 'Ruku'),
              ],
            ),
            actions: [
              SearchQuranWidget(
                  sc: sc,
                  quranData: quranData,
                  quranMetaData: quranMetaData,
                  quranTranslationData: quranTranslationData),
            ],
            title: Text(
              'Al Quran',
              style: TextStyle(color: null),
            )),
        body: TabBarView(
          children: [
            // Tab 1: Sura List
            ListView.separated(
              itemCount: quranData.length,
              itemBuilder: (context, index) {
                final sura = quranData[index];
                final suraMetaData = quranMetaData[index];
                final suraTranslation = quranTranslationData[index];
                return ListTile(
                  leading: Text(
                    sura.index.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        suraMetaData.tname,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    sura.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18),
                    textDirection: TextDirection.rtl,
                  ),
                  subtitle: Row(
                    children: [
                      Text("${suraMetaData.ayas} Ayas | "),
                      Text(suraMetaData.type),
                    ],
                  ),
                  onTap: () {
                    // Navigate to the AyahPage when a Surah is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AyahPage(
                          sura: sura,
                          suraMetaData: suraMetaData,
                          suraTranslation: suraTranslation,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return divider;
              },
            ),

            QuraDataListView(
              type: QuranDataType.page,
            ),
            // Tab 2: Page View
            QuraDataListView(type: QuranDataType.juz),
            // Tab 4: Hizb View
            QuraDataListView(type: QuranDataType.hizb),
            // Tab 5: Ruku View
            QuraDataListView(type: QuranDataType.ruku),
          ],
        ),
      ),
    );
  }
}

class QuraDataListView extends StatelessWidget {
  const QuraDataListView({
    super.key,
    required this.type,
  });
  final QuranDataType type;

  @override
  Widget build(BuildContext context) {
    final quranVM = context.watch<QuranViewModel>();
    var quranData = quranVM.getDataFromType(type);
    final quranMetaData = quranVM.quranMetaData;

    return ListView.separated(
      itemCount: quranData.length,
      itemBuilder: (context, index) {
        final item = quranData[index];
        final startSura = item.startSura;
        final startAya = item.startAya;
        final endSura = item.endSura!;
        final endAya = item.endAya!;
        final startSuraMetaData = quranMetaData[startSura - 1];
        final endSuraMetaData = quranMetaData[endSura -1];
        return ListTile(
          leading: Text(
            item.index.toString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${startSuraMetaData.tname} $startSura: $startAya",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          subtitle: Text("${endSuraMetaData.tname} $endSura : $endAya"),
          onTap: () {
            // Navigate to the AyahPage when a Surah is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuranDataView(
                  type: type,
                  initialPage: item.index - 1,
                ),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return divider;
      },
    );
  }
}

