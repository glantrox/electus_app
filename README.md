# Electus App

Aplikasi ini merupakan sisi klien mobile dari Electus Platform (Website), Electus adalah aplikasi Applicant Tracking System yang terintegrasi dengan Artificial Intelligence dalam penerapan ekstraksi konten Curriculum Vitae menjadi segmentasi Holland Code & RIASEC.
Architecture aplikasi ini dibangun dengan menerapkan arsitektur terstruktur, State Management BLoC, dan navigasi menggunakan GoRouter.

## Teknologi Utama
- **Framework:** Flutter
- **State Management:** BLoC (`flutter_bloc`, `equatable`)
- **Routing:** `go_router` (dilengkapi proteksi rute berbasis otentikasi)
- **Dependency Injection:** `get_it`
- **Environment Config:** `flutter_dotenv`

## Struktur Direktori (`/lib`)
Proyek ini mengadopsi prinsip *Separation of Concerns* (pemisahan tanggung jawab) dan *Clean Architecture* di setiap layernya:

```text
lib/
├── core/           # Utilitas inti, konstanta, tema, dan helper (misal: RouterRefreshStream)
│   └── config/     # Konfigurasi aplikasi (AppConfig) – membaca dari .env
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

## Environment Configuration

Aplikasi ini menggunakan `flutter_dotenv` untuk memuat variabel konfigurasi dari file `.env` pada saat runtime.

### Setup

1. Salin template `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```

2. Sesuaikan nilai-nilai di dalam file `.env` sesuai kebutuhan lingkungan Anda.

### Template `.env`

```env
# Base URL untuk backend API server.
# - iOS Simulator:    http://localhost:3000
# - Android Emulator: http://10.0.2.2:3000
# - Physical Device:  http://<ip-mesin-anda>:3000
API_BASE_URL=http://localhost:3000

# URL default untuk avatar pengguna (dipakai jika belum ada foto profil).
DEFAULT_AVATAR_URL=https://i.pravatar.cc/150?img=47

# Nama perangkat yang dikirim bersama permintaan otentikasi.
DEVICE_NAME=Flutter Client
```

| Variable | Deskripsi | Default |
|---|---|---|
| `API_BASE_URL` | Base URL untuk backend API | `http://localhost:3000` |
| `DEFAULT_AVATAR_URL` | URL fallback gambar avatar | `https://i.pravatar.cc/150?img=47` |
| `DEVICE_NAME` | Nama perangkat untuk auth request | `Flutter Client` |

> **Catatan:** File `.env` sudah tercantum di `.gitignore` dan tidak akan ter-commit ke repository. Gunakan `.env.example` sebagai referensi.

## Persyaratan Sistem

Aplikasi ini disarankan untuk dijalankan pada platform **Windows**, **Android**, atau **iOS**. 

> [!WARNING]
> Jika Anda menjalankan aplikasi ini menggunakan **Chrome (Web)**, Anda akan mengalami masalah **CORS (Cross-Origin Resource Sharing) restriction** ketika aplikasi mencoba berinteraksi dengan API.

## Installation
1. Salin template konfigurasi environment:
   ```bash
   cp .env.example .env
   ```
2. Jalankan perintah instalasi dependensi (package):
   ```bash
   flutter pub get
   ```
3. Anda bisa memeriksa potensi isu struktur *linting* melalui:
   ```bash
   flutter analyze
   ```
4. Mulai kompilasi atau jalankan ke perangkat/simulator:
   ```bash
   flutter run
   ```
