# free_quran


fvm flutter build apk --release   


### **Firebase Configuration:**
To configure Firebase for your app:
1. Install `flutterfire_cli` for Firebase integration:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Add the following to your shell profile to ensure the `flutterfire` command works:
   ```bash
   export PATH="$PATH":"$HOME/.pub-cache/bin"
   ```
3. Set up Firebase in your project:
   ```bash
   flutterfire configure
   ```