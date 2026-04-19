Persyaratan Sistem

Sebelum menjalankan aplikasi, pastikan perangkat pengembangan Anda sudah terinstal:

Flutter SDK: Versi terbaru (Channel Stable).

Dart SDK: Terintegrasi dengan Flutter.

Android Studio / VS Code dengan ekstensi Flutter/Dart.

Environment: Disarankan dijalankan pada OS Linux (Dual-boot) atau Windows dengan NDK yang terkonfigurasi untuk OpenCV.

📦 Langkah-Langkah Instalasi

Ikuti langkah berikut untuk menjalankan proyek di perangkat lokal Anda:

1. Ekstraksi & Persiapan Folder

Ekstrak file .zip proyek ini ke direktori kerja Anda. Masuk ke root folder proyek:

cd logbook_appai_001


2. Konfigurasi Environment (.env)

Aplikasi ini menggunakan flutter_dotenv. Buat file bernama .env di root direktori (sejajar dengan pubspec.yaml) jika belum ada, dan isi dengan variabel yang diperlukan (Contoh: API keys atau konfigurasi database).

3. Instalasi Dependencies

Jalankan perintah berikut untuk mengunduh semua library yang diperlukan (Camera, OpenCV, Hive, dll):

flutter pub get


4. Setup OpenCV (Penting)

Aplikasi ini menggunakan opencv_dart. Library ini secara otomatis akan mengunduh binary OpenCV yang sesuai saat pertama kali di-build. Pastikan koneksi internet stabil.

5. Menjalankan Aplikasi

Sambungkan HP Android (dengan mode Debugging aktif) atau gunakan Emulator, lalu jalankan:

flutter run



