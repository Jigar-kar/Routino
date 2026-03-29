# Routino 🚀

![Routino Banner](https://img.shields.io/badge/Routino-Your%20Life%20Organized-4F46E5?style=for-the-badge&logo=flutter)

**Routino** is a beautiful, highly-customizable, and privacy-first Flutter application designed to organize your daily life. It brings together Task Management, Routine Tracking, Expense Logging, and Notes into a single cohesive experience.

Built with **Flutter**, **Riverpod**, and **Sqflite**, Routino respects your privacy with an offline-first architecture, reinforced by secure 4-digit PIN and Biometric authentication.

---

## 🌟 Key Features

*   **⚡ All-in-One Dashboard:** Get a bird's-eye view of your daily tasks, routines, recent expenses, and pinned notes the moment you open the app.
*   **🔒 Privacy & Security:** 
    *   **Always-On Security:** App auto-locks when pushed to the background.
    *   **Biometric Unlock:** Seamlessly logs you back in using Fingerprint or Face ID via `local_auth`.
    *   **Offline-First:** Your data is yours. Everything is stored locally on your device via SQLite.
*   **🔔 Smart Notifications:** Get scheduled reminders for your tasks natively on iOS and Android with timezone support. (Optional Firebase Cloud Messaging integration available).
*   **🎨 Highly Customizable Themes:** Choose between Light, Dark, Colorful, Minimalist, Glass, or define a completely **Custom Theme** with an interactive color picker.
*   **☁ Backup & Restore:** Export your entire SQLite database to a single JSON file and save it securely to Google Drive, Dropbox, Email, or local files. Import your JSON backups easily when you get a new device.

---

## 📸 Screenshots

*(Replace these placeholders with your actual app screenshots)*

|<img src="https://via.placeholder.com/250x500.png?text=Dashboard" width="200"/> | <img src="https://via.placeholder.com/250x500.png?text=Tasks" width="200"/> | <img src="https://via.placeholder.com/250x500.png?text=Settings" width="200"/>|
|:---:|:---:|:---:|
| **Dashboard** | **Tasks & Notifications** | **Custom Themes** |

---

## 🛠️ Technology Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
*   **Database:** `sqflite` (with FFI support for desktop environments)
*   **Authentication:** `flutter_secure_storage` & `local_auth`
*   **Notifications:** `flutter_local_notifications` & `timezone`
*   **Data Export:** `share_plus`, `file_picker`, `path_provider`

---

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

*   Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
*   Android Studio / Xcode for emulators and building

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Jiggar-kar/routino.git
   cd routino
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

*(Optional) Firebase Integration:*
> If you want to use cloud syncing or Firebase Cloud Messaging, add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective directories.

---

## 📦 App Size Reduction Tips (For Release)

Routino is already pre-configured for aggressive size reduction on Android! When you build an APK or App Bundle, the Gradle configuration uses **R8/ProGuard** to minify and shrink unused resources.

To build the smallest possible executable:

**For Android App Bundles (AAB) - Recommended for Play Store:**
```bash
flutter build appbundle
```

**For APKs (Split per Architecture):**
```bash
flutter build apk --split-per-abi
```
> This produces separate APKs for `arm64-v8a`, `armeabi-v7a`, and `x86_64`, significantly reducing the file size users have to download compared to a "fat" universal APK.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check [issues page](https://github.com/yourusername/routino/issues).

---

## 📝 License

This project is [MIT](https://opensource.org/licenses/MIT) licensed.
