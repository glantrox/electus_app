# Electus App

Aplikasi ini merupakan sisi klien mobile dari Electus Platform (Website), Electus adalah aplikasi Applicant Tracking System yang terintegrasi dengan Artificial Intelligence dalam penerapan ekstraksi konten Curriculum Vitae menjadi segmentasi Holland Code & RIASEC.
Architecture aplikasi ini dibangun dengan menerapkan arsitektur terstruktur, State Management BLoC, dan navigasi menggunakan GoRouter.

## Teknologi Utama
- **Framework:** Flutter
- **State Management:** BLoC (`flutter_bloc`, `equatable`)
- **Routing:** `go_router` (dilengkapi proteksi rute berbasis otentikasi)
- **Dependency Injection:** `get_it`

## Struktur Direktori (`/lib`)
Proyek ini mengadopsi prinsip *Separation of Concerns* (pemisahan tanggung jawab) dan *Clean Architecture* di setiap layernya:

```text
lib/
├── core/           # Utilitas inti, konstanta, tema, dan helper (misal: RouterRefreshStream)
├── data/           # Implementasi Repositori, Model Data, dan terhubung ke API/Database Lokal
├── domain/         # Entitas Bisnis, Use Case, dan Interface Repositori
├── presentation/   # UI Layer (Pages, Widgets, dan BLoC/Cubit per fitur)
│   ├── auth/       # Layar Splash, Login, Register & AuthBloc (Global Auth State)
│   ├── features/   # Fitur inti seperti Scan CV dan Upload CV
│   ├── pages/      # Tampilan Dashboard, Account Settings, dan Statistics
│   └── main_dashboard.dart # Layout shell utama untuk Bottom Navigation Bar
├── injection.dart  # Setup file untuk Dependensi menggunakan get_it
├── router.dart     # Penanganan rute GoRouter dan logika redirect (Auth Guard)
└── main.dart       # Entri point utama aplikasi
```

## Alur Logika
- **Otentikasi & Redirect Routing:** Status otentikasi dikendalikan oleh `AuthBloc`. Parameter `refreshListenable` pada GoRouter mendengarkan perubahan stream `AuthBloc`. Jika status pengguna tertandai "unauthenticated" dan mencoba masuk ke rute privat (contoh: Home), pengguna otomatis tertendang ke `/login`. Demikian juga pengguna yang sudah Auth tidak bisa mengakses layar Splash/Login.
- **Nested Navigation (BottomNav):** Memakai `StatefulShellRoute` dari GoRouter. Memungkinkan setiap cabang rute mempertahankan _state_ navigasinya masing-masing ketika pengguna berpindah menu dari Bottom Navigation Bar.

## Installation
1. Jalankan perintah instalasi dependensi (package):
   ```bash
   flutter pub get
   ```
2. Anda bisa memeriksa potensi isu struktur *linting* melalui:
   ```bash
   flutter analyze
   ```
3. Mulai kompilasi atau jalankan ke perangkat/simulator:
   ```bash
   flutter run
   ```
