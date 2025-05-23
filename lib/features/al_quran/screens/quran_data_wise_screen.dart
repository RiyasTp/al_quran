import 'dart:developer';

import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/al_quran/widgets/aya_text_span_builder.dart';
import 'package:al_quran/features/al_quran/widgets/bismillah_widget.dart';
import 'package:al_quran/features/al_quran/widgets/sura_heading_wdiget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuranDataView extends StatefulWidget {
  final QuranDataType type;
  final int? initialPage;
  const QuranDataView({super.key, required this.type, this.initialPage});
  @override
  createState() => _QuranDataViewState();
}

class _QuranDataViewState extends State<QuranDataView> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? 0;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final quranVM = context.watch<QuranViewModel>();
    var pages = quranVM.getDataFromType(widget.type);
    var quranData = quranVM.quranData;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type.typeName} ${_currentPage + 1}'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            final page = pages[index];
            return QuranTypeWisePageContentBuilder(
              page: page,
            );
          },
        ),
      ),
      bottomNavigationBar: _buildPageNavigation(pages),
    );
  }

  Widget _buildPageNavigation(List<QuranTypeWiseData> pages) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // IconButton(
              //   icon: Icon(Icons.onetwothree),
              //   onPressed: () => _pageController.animateToPage(
              //     600,
              //     duration: Duration(milliseconds: 300),
              //     curve: Curves.easeInOut,
              //   ),
              // ),
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: _currentPage > 0
                    ? () => _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        )
                    : null,
              ),
              Text(
                  '${widget.type.typeName} ${_currentPage + 1} of ${pages.length}'),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: _currentPage < pages.length - 1
                    ? () => _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class QuranTypeWisePageContentBuilder extends StatelessWidget {
  const QuranTypeWisePageContentBuilder({
    super.key,
    required this.page,
  });
  final QuranTypeWiseData page;
  @override
  Widget build(BuildContext context) {
    final quranVM = context.watch<QuranViewModel>();
    final quranData = quranVM.quranData;
    try {
      final widgets = <Widget>[];
      int currentSura = page.startSura;
      while (currentSura <= (page.endSura!)) {
        final ayahTextSpans = <InlineSpan>[]; // Changed to InlineSpan
        var sura = quranData.firstWhere((s) => s.index == currentSura);
        final startAya = (currentSura == page.startSura) ? page.startAya : 1;
        final endAya =
            (currentSura == page.endSura) ? page.endAya : sura.ayas.last.index;

        // Add sura title if this is the first ayah
        if (startAya == 1) {
          widgets.add(
            SuraHeadingWidget(sura: sura),
          );

          // Add Bismillah if not Surah 1 or 9
          if (sura.index != 1 && sura.index != 9) {
            widgets.add(
              BismillahWidget(),
            );
          }
        }

        // Add ayahs to RichText
        for (final aya in sura.ayas) {
          if (aya.index >= startAya && endAya != null && aya.index <= endAya) {
            ayahTextSpans.addAll(ayaTextSpanBuilder(context, aya));
            ayahTextSpans.add(TextSpan(text: ' ')); // Add space between ayahs
          }
        }
        widgets.add(
          Directionality(
            textDirection: TextDirection.rtl,
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: ayahTextSpans,
              ),
            ),
          ),
        );

        currentSura++;
      }

      // Add the RichText with all ayahs

      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      );
    } catch (e, s) {
      log("Error on page content build $e", stackTrace: s);
      return Center(
        child: Text(
          'Error loading page content',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
