import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appName = 'Al Quran';
  String version = '';
  String website = 'https://alquran.example.com';
  String generalInfo =
      'Al Quran is a simple and easy-to-use app for reading and understanding the Quran.';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset('assets/logo/ic_launcher.webp', height: 100),
            const SizedBox(height: 16),
       
            // App Name & Version
            Text(
              appName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Version $version',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // General Info
            Text(
              generalInfo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Website Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // You can use url_launcher to open the website
                  },
                  child: Text(
                    website,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
