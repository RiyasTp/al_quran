import 'package:al_quran/design_system/themes/dark_theme.dart';
import 'package:al_quran/design_system/themes/light_theme.dart';
import 'package:al_quran/features/al_quran/screens/quran_home_screen.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/bookmarks/book_marks_screen.dart';
import 'package:al_quran/features/notes/notes_screen.dart';
import 'package:al_quran/utils/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final quranVM = QuranViewModel();
  await quranVM.initQuranViewModel();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => quranVM),
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
  int _currentIndex = 0;
  void _onItemTapped(int index) {
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
      case 3:
        return const QuranScreen();
      default:
        return const QuranScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyRouter.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
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
      ),
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

class AppSettings {
  var themeMode = ThemeMode.system;
  var quranFontFamily = 'Hafs';
  var fontSizeFactor = 1;
  var arabicFontFactor = 1;
  var translationFontFactor = 1;
  var showTranslation = true;
  var translation = "Sahih International";
}
