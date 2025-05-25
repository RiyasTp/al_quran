import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/widgets/aya_text_span_builder.dart';
import 'package:al_quran/features/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AyaRichText extends StatelessWidget {
  const AyaRichText({super.key, required this.aya});

  final Aya aya;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = ayaTextSpanBuilder(context, aya);
    final quranFontFactor = context.watch<AppSettingsViewModel>().settings.quranFontSize;
    return RichText(
      textScaler: TextScaler.linear(quranFontFactor),
      text: TextSpan(
          children: spans, style: Theme.of(context).textTheme.bodyLarge),
      textDirection: TextDirection.rtl,
    );
  }
}
