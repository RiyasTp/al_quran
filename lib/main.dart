import 'package:al_quran/design_system/themes/dark_theme.dart';
import 'package:al_quran/design_system/themes/light_theme.dart';
import 'package:al_quran/features/al_quran/screens/quran_home_screen.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/bookmarks/book_marks_screen.dart';
import 'package:al_quran/features/notes/notes_screen.dart';
import 'package:al_quran/features/settings/settings_screen.dart';
import 'package:al_quran/features/settings/settings_view_model.dart';
import 'package:al_quran/utils/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsVM = AppSettingsViewModel();
  await settingsVM.loadSettings();

  final quranVM = QuranViewModel();
  await quranVM.initQuranViewModel();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => quranVM),
      ChangeNotifierProvider(create: (_) => settingsVM),
    ],
    builder: (context, _) => const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<AppSettingsViewModel>(context);
    final themeMode = settingsVM.settings.themeMode;
    return MaterialApp(
      navigatorKey: MyRouter.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      builder: (context, child) {
        final settingsVM = Provider.of<AppSettingsViewModel>(context);
        final textScale = settingsVM.settings.appFontSize;
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // In your main app or settings screen
  void _showSettingsBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SettingsBottomSheet();
      },
    );
  }

  int _currentIndex = 0;
  void _onItemTapped(int index) {
    if (index == 3) {
      _showSettingsBottomSheet();
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const QuranScreen();
      case 1:
        return const BookmarksPage();
      case 2:
        return const NotesPage();

      default:
        return const QuranScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                label: 'Home', icon: Icon(Icons.home_filled)),
            BottomNavigationBarItem(
                label: 'Bookmarks', icon: Icon(Icons.bookmark_rounded)),
            BottomNavigationBarItem(
                label: 'Notes', icon: Icon(Icons.sticky_note_2_rounded)),
            BottomNavigationBarItem(
                label: 'Settings', icon: Icon(Icons.settings_rounded)),
          ]),
    );
  }
}

String toArabicNumerals(int number) {
  const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final n = number
      .toString()
      .split('')
      .map((digit) => arabicNumerals[int.parse(digit)])
      .join('');
  // return " ‎﴿$n﴾‏ ";
  return n;
}

const nonBreakSpaceChar = ' '; // 	&nbsp; U+00A0
