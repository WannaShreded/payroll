# Payroll (Aplikasi Mobile)

Ringkasan profesional singkat:

- **Payroll** adalah aplikasi Flutter untuk pengelolaan absensi dan penggajian karyawan. Aplikasi menggunakan Firebase (Authentication + Firestore) untuk autentikasi dan penyimpanan data, serta paket `pdf` + `printing` untuk menghasilkan slip gaji dalam format PDF.

## Fitur Utama

- Autentikasi pengguna (Firebase Auth)
- Manajemen karyawan (CRUD)
- Perekaman dan rekapitulasi absensi
- Perhitungan gaji otomatis dan breakdown gaji
- Unduh slip gaji sebagai PDF
- Dashboard dengan ringkasan dan akses cepat

## Arsitektur & Alur Kerja Kode

- Struktur: folder `lib/` berisi `screens/`, `widgets/`, `services/`, `models/`, `utils/`, `theme/`.
- `AppShell` bertindak sebagai layout utama (top app bar + bottom navigation). Semua halaman ditempatkan dalam `AppShell` sehingga child pages tidak perlu (`Scaffold.appBar`) sendiri.

Alur otentikasi singkat:
- Login menggunakan Firebase Auth (`lib/services/auth_service.dart`).
- Ubah password melakukan re-authenticate lalu `updatePassword` pada user Firebase (perlu memasukkan password lama untuk keamanan).
- Fitur lupa password dihilangkan dari UI sesuai keputusan desain; backend (method) tetap ada jika diperlukan.

Slip gaji & PDF:
- Komponen visual slip gaji ada di `lib/widgets/salary_slip.dart`.
- Saat pengguna menekan `Unduh PDF`, aplikasi membangun dokumen PDF menggunakan paket `pdf` dan memanggil `Printing.sharePdf(bytes, filename)` untuk membagikan/menyimpan file.
- Tombol `Cetak` di UI slip dan cetak detail karyawan telah dihapus (fitur cetak dinonaktifkan).

Header & navigasi:
- `lib/screens/dashboard_page.dart` berisi tampilan beranda yang telah dimodernisasi: avatar, greeting, peran, dan tanggal.
- Detail halaman karyawan dan absensi tidak lagi memiliki `AppBar` sendiri, menggunakan `AppShell` untuk konsistensi.

Komponen layanan utama:
- `lib/services/auth_service.dart` — login/logout, reauthenticate, changePassword, dan integrasi awal dengan Firestore untuk profil.
- `lib/services/employee_service.dart` — CRUD karyawan.
- `lib/services/payroll_service.dart` — pengambilan dan perhitungan payroll terkait karyawan per bulan.
- `lib/services/attendance_service.dart` — perekaman dan query absensi.

Model data utama:
- `EmployeeModel`, `PayrollModel`, `AttendanceModel`, `UserModel` — masing-masing di `lib/models/`.

## File Penting & Penjelasan Singkat

- `lib/widgets/app_shell.dart`: Layout global aplikasi; jangan tambahkan `Scaffold.appBar` dalam child pages.
- `lib/screens/employee_detail_page.dart`: Menampilkan detail karyawan; tombol Cetak telah dihapus.
- `lib/widgets/salary_slip.dart`: Template slip gaji + generator PDF.
- `lib/screens/attendance_page.dart` dan `lib/screens/attendance_detail_page.dart`: Rekap absensi; header kini menggunakan gaya kartu profil.
- `lib/screens/profile_page.dart`: Pengaturan profil pengguna; opsi ubah jabatan dihapus untuk non-admin.

## Cara Menjalankan (pengembang)

1. Siapkan environment Flutter dan SDK sesuai `environment` pada `pubspec.yaml`.
2. Install dependency:

```bash
flutter pub get
```

3. Jalankan analyzer statis:

```bash
flutter analyze
```

4. Jalankan di emulator/perangkat:

```bash
flutter run
```

## Catatan Pengembangan

- Setelah refactor, `flutter analyze` melaporkan beberapa peringatan non-kritis:
  - `analysis_options.yaml` memiliki include ke `package:flutter_lints/flutter.yaml` yang mungkin tidak tersedia di environment; perbaiki dependensi/lint config jika perlu.
  - Penggunaan `.withOpacity()` memberi peringatan deprecation pada beberapa baris; dapat diganti dengan `.withValues()` untuk menghindari precision loss.

- Keputusan desain khusus:
  - Fitur 'Lupa Password' dihapus dari UI — perubahan ini disengaja.
  - Tombol cetak fisik untuk slip dan detail karyawan dihapus; hanya opsi unduh PDF yang aktif.
  - Pengubahan jabatan di dialog edit profil dibatasi (admin-only) — opsi di UI dihapus.

## Testing Manual yang Direkomendasikan

- Verifikasi alur login & ubah password (perlu akun test).
- Verifikasi pembuatan slip gaji dan tombol `Unduh PDF` pada halaman payroll/employee.
- Cek UI Dashboard dan header di berbagai ukuran layar.

## Kontak

Jika ada pertanyaan lanjutan atau permintaan perubahan desain, hubungi pengembang utama proyek.

---
_README ini dibuat dan diperbarui secara otomatis oleh tooling pengembangan._
# payroll

A new Flutter project.
