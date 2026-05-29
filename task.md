# Task List Electus App

Delegasi tugas pengembangan UI dan integrasi berdasarkan mockup desain. 

## 1. Authentication (Login & Register) - **[Assignee: Hamas]**
- [ ] Buat UI halaman Login.
- [ ] Buat UI halaman Register.
- [ ] Hubungkan UI dengan `AuthBloc`.
- [ ] Tambahkan validasi form input.

## 2. Home Dashboard - **[Assignee: Hamas]**
- [ ] Buat UI metrik ringkasan (Total CVs, dll).
- [ ] Buat komponen list kandidat.
- [ ] Tampilkan tag keahlian kandidat (HTML, React, dll).
- [ ] Buat popup/modal AI Summary kandidat.

## 3. Upload & Scan CV - **[Assignee: Oliver]**
- [ ] Buat UI area drag & drop file.
- [ ] Integrasi package `file_picker` untuk telusuri file.
- [ ] Integrasi package `camera` untuk fitur Scan CV.
- [ ] Tampilkan list "Recent Uploads".
- [ ] Tangani state upload (berhasil/gagal format).

## 4. Statistics & Analytics - **[Assignee: Bryan]**
- [ ] Pasang package `fl_chart`.
- [ ] Buat grafik pie "Talent Distribution" (RIASEC).
- [ ] Buat indikator visual "Hiring Pipeline".
- [ ] Tampilkan metrik utama pendukung (Time to Hire, dll).

## 5. Account Settings - **[Assignee: Oliver]**
- [ ] Buat form data profil (Avatar, Nama, Email, Password).
- [ ] Buat toggle ganti tema (Light/Dark mode).
- [ ] Implementasi manajemen state tema.
- [ ] Buat komponen slider "Target Culture" (model RIASEC).

## 6. Core & Data Layer - **[Assignee: Hamas]**
- [ ] Setup HTTP client (contoh: Dio).
- [ ] Buat model data API (`freezed` / `json_serializable`).
- [ ] Hubungkan repository layer via `get_it`.
- [ ] Setup lokalisasi jika diperlukan.
