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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.94,
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAppSettings(),
                  Divider(height: 32),
                  _buildFontSettings(),
                  Divider(height: 32),
                  _buildTafseerSettings(),
                  Divider(height: 32),
                  _buildRecitationSettings(),
                  Divider(height: 32),
                  _buildResetSettings(),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildAppSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('App Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        _buildFontSizeSlider(
          label: 'App Font Size',
          value: _currentSettings.appFontSize,
          min: .5,
          max: 2,
          onChanged: (value) {
            setState(() {
              _currentSettings = _currentSettings.copyWith(appFontSize: value);
            });
            onSettingsChanged(_currentSettings);
          },
        ),
        SizedBox(height: 16),
        Text('Theme'),
        SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.settings),
            ),
          ],
          selected: <ThemeMode>{_currentSettings.themeMode},
          onSelectionChanged: (Set<ThemeMode> newSelection) {
            if (newSelection.isNotEmpty) {
              setState(() {
                _currentSettings = _currentSettings.copyWith(
                  themeMode: newSelection.first,
                );
              });
              onSettingsChanged(_currentSettings);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFontSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quran Font Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        _buildFontFamilySelector(),
        SizedBox(height: 16),
        _buildFontSizeSlider(
          label: 'Quran Font Size',
          value: _currentSettings.quranFontSize,
          min: .5,
          max: 2,
          onChanged: (value) {
            setState(() {
              _currentSettings =
                  _currentSettings.copyWith(quranFontSize: value);
            });
            onSettingsChanged(_currentSettings);
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFontFamilySelector() {
    final fontFamilies = _currentSettings.allFontFamilies;
    return DropdownButtonFormField<String>(
      value: fontFamilies.firstWhere(
          (family) => family == _currentSettings.quranFontFamily,
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
            Text('$min x'),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: ((max - min) / .25).toInt(),
                label: value.toStringAsFixed(2),
                onChanged: onChanged,
              ),
            ),
            Text('$max x'),
          ],
        ),
      ],
    );
  }

  Widget _buildTafseerSettings() {
    final tafseerAuthors = _currentSettings.allTranslationAuthors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Translation Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        SwitchListTile(
          title: Text('Show Translation'),
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
          value: tafseerAuthors.firstWhere(
              (author) => author == _currentSettings.translationAuthor,
              orElse: () => tafseerAuthors.first),
          decoration: InputDecoration(
            labelText: 'Translation Author',
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
        SizedBox(height: 8),
        _buildFontSizeSlider(
          label: 'Translation Font Size',
          value: _currentSettings.translationFontSize,
          min: .5,
          max: 2,
          onChanged: (value) {
            setState(() {
              _currentSettings =
                  _currentSettings.copyWith(tafseerFontSize: value);
            });
            onSettingsChanged(_currentSettings);
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecitationSettings() {
    final recitations = _currentSettings.allRecitations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recitation Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: recitations
              .firstWhere((reciter) => reciter.id == _currentSettings.reciterId,
                  orElse: () => recitations.first)
              .id,
          decoration: InputDecoration(
            labelText: 'Reciter',
            border: OutlineInputBorder(),
          ),
          items: recitations.map((reciter) {
            return DropdownMenuItem(
              value: reciter.id,
              child: Text(reciter.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _currentSettings = _currentSettings.copyWith(reciterId: value);
              });
              onSettingsChanged(_currentSettings);
            }
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResetSettings() {
    return ElevatedButton(
      onPressed: () async {
        // show confirmation dialogbox
        final result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Reset Settings'),
            content: Text('Are you sure you want to reset all settings?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Reset'),
              ),
            ],
          ),
        );
        if (result != true) return;
        setState(() {
          _currentSettings = AppSettings(); // Reset to default settings
        });
        onSettingsChanged(_currentSettings);
      },
      child: Text('Reset to Default Settings'),
    );
  }
}
