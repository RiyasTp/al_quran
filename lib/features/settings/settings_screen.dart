import 'package:al_quran/features/settings/settings_model.dart';
import 'package:al_quran/features/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({
    super.key,
  });

  @override
  createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  late AppSettings _currentSettings;
  late final ValueChanged<AppSettings> onSettingsChanged;

  @override
  void initState() {
    super.initState();
    final settingsVM = context.read<AppSettingsViewModel>();
    _currentSettings = settingsVM.settings;
    onSettingsChanged = (newSettings) {
      context.read<AppSettingsViewModel>().saveSettings(newSettings);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildFontSettings(),
            Divider(height: 32),
            _buildTafseerSettings(),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildFontSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        _buildFontFamilySelector(),
        SizedBox(height: 16),
        _buildFontSizeSlider(
          label: 'Quran Font Size',
          value: _currentSettings.quranFontSize,
          min: 16,
          max: 32,
          onChanged: (value) {
            setState(() {
              _currentSettings =
                  _currentSettings.copyWith(quranFontSize: value);
            });
            onSettingsChanged(_currentSettings);
          },
        ),
        SizedBox(height: 16),
        _buildFontSizeSlider(
          label: 'Tafseer Font Size',
          value: _currentSettings.tafseerFontSize,
          min: 12,
          max: 24,
          onChanged: (value) {
            setState(() {
              _currentSettings =
                  _currentSettings.copyWith(tafseerFontSize: value);
            });
           onSettingsChanged(_currentSettings);
          },
        ),
        SizedBox(height: 16),
        _buildFontSizeSlider(
          label: 'App Font Size',
          value: _currentSettings.appFontSize,
          min: 12,
          max: 20,
          onChanged: (value) {
            setState(() {
              _currentSettings = _currentSettings.copyWith(appFontSize: value);
            });
            onSettingsChanged(_currentSettings);
          },
        ),
      ],
    );
  }

  Widget _buildFontFamilySelector() {
    final fontFamilies = [
      'Hafs',
      'Amiri',
      'KFGQPC',
      'Scheherazade',
      'Traditional Arabic',
    ];

    return DropdownButtonFormField<String>(
      value: fontFamilies
          .firstWhere((family) => family == _currentSettings.fontFamily,
              orElse: () => fontFamilies.first),
      decoration: InputDecoration(
        labelText: 'Font Family',
        border: OutlineInputBorder(),
      ),
      items: fontFamilies.map((family) {
        return DropdownMenuItem(
          value: family,
          child: Text(family),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _currentSettings = _currentSettings.copyWith(fontFamily: value);
          });
          onSettingsChanged(_currentSettings);
        }
      },
    );
  }

  Widget _buildFontSizeSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Text('${min.toInt()}'),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                 max: max,
                divisions: (max - min).toInt(),
                label: value.toStringAsFixed(1),
                onChanged: onChanged,
              ),
            ),
            Text('${max.toInt()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildTafseerSettings() {
    final tafseerAuthors = [
      'Ibn Kathir',
      'Al-Jalalayn',
      'Al-Saadi',
      'Al-Tabari',
      'Al-Qurtubi',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tafseer Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        SwitchListTile(
          title: Text('Show Tafseer'),
          value: _currentSettings.showTaranslation,
          onChanged: (value) {
            setState(() {
              _currentSettings =
                  _currentSettings.copyWith(showTaranslation: value);
            });
            onSettingsChanged(_currentSettings);
          },
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          // value: _currentSettings.translationAuthor,
          value: tafseerAuthors
              .firstWhere((author) => author == _currentSettings.translationAuthor,
                  orElse: () => tafseerAuthors.first),
          decoration: InputDecoration(
            labelText: 'Tafseer Author',
            border: OutlineInputBorder(),
          ),
          items: tafseerAuthors.map((author) {
            return DropdownMenuItem(
              value: author,
              child: Text(author),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _currentSettings =
                    _currentSettings.copyWith(translationAuthor: value);
              });
              onSettingsChanged(_currentSettings);
            }
          },
        ),
      ],
    );
  }
}