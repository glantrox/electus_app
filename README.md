# Electus App
Artificial Intelligence based Applicant Tracking System, this is the mobile application version of the platform.

# Struktur Project

Aplikasi ini menggunakan pola **Clean Architecture** untuk memisahkan logika bisnis, data, dan antarmuka pengguna.

## Struktur Folder Dasar

### 1. `lib/core/`
Blok bangunan dasar yang digunakan di seluruh aplikasi.
- **`enums/`**: Definisi tipe data enumerasi global.
- **`errors/`**: Penanganan kesalahan (Failure & Exception).

### 2. `lib/domain/`
Lapisan inti bisnis (Pure Dart, tidak bergantung pada Flutter).
- **`entities/`**: Objek data utama (Contoh: `AppStage`).
- **`repositories/`**: Antarmuka (Interface) untuk kontrak data.
- **`usecase/`**: Fungsi spesifik yang menjalankan logika bisnis tunggal.

### 3. `lib/data/`
Implementasi pengambilan data dan integrasi luar.
- **`datasource/`**: Koneksi langsung ke API (Remote) atau Local Database.
- **`models/`**: Ekstensi Entities dengan konversi JSON (`fromJson`/`toJson`).
- **`repositories/`**: Implementasi konkret dari domain repository.

### 4. `lib/presentation/`
Semua hal terkait UI dan Manajemen State.
- **`bloc/`**: Logika state management (Business Logic Component).
- **`pages/`**: Komponen layar penuh (Screen/View).
- **`widget/`**: Komponen UI kecil yang dapat digunakan kembali.

### 5. `lib/route/`
Konfigurasi navigasi sistem.
- **`app_router.dart`**: Pengaturan `GoRouter` dan logika routing.
- **`auth_service.dart`**: Layanan pemantau status login pengguna.

---

## Folder Lainnya
- **`assets/`**: Penyimpanan aset statis seperti gambar, ikon, dan fonts.
- **`android/`, `ios/`, `web/`**: Kode native untuk runtime di masing-masing platform.
- **`pubspec.yaml`**: Manajer paket dan konfigurasi aset Flutter.

# State management
untuk state management di aplikasi ini kita menggunakan bloc, bloc ini menggunakan design pattern state, kalian bisa pelajari giman cara pakai bloc di sini https://pub.dev/packages/bloc
![alt text](image.png)

# Routing
GoRouter sebagai router aplikasi ini, kalian bisa pelajari gimana cara pakai GoRouter di sini https://pub.dev/packages/go_router, semua route yang essential akan di simpan di dalam app_router.dart.
# Development Stage
Jadi ada 3 tipe production stage, ubah sesuai kebutuhan kalian, dalam ini
**developmentUI, production, developmentRegular**
kalian ubah variabel appStage di ```lib/main.dart```, misalnya kalau kalian lagi
develop UI nya dan kalian lagi testing, kalian ubah appStage ini menjadi
'AppStage.developmentUI'
- Development UI: Kalo kalian lagi develop dan testing UI, dalam konteks ini middleware redirect tidak akan terlibat
- Development Regular: Jika kalian lagi develop aplikasi biasa dengan intervensi middleware


