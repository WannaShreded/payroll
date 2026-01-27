LAPORAN TUGAS BESAR

MATA KULIAH: Pemrograman Perangkat Bergerak (IF05104)

JUDUL PROYEK: Aplikasi Payroll Mobile (Payroll Management System)

PENYUSUN: [Nama Lengkap] — NIM: [NIM]

PROGRAM STUDI: Informatika

FAKULTAS: [Nama Fakultas]

INSTITUSI: [Nama Universitas]

DOSEN PEMBIMBING: [Nama Dosen Pembimbing]

SEMESTER: 5

TAHUN AKADEMIK: 2025/2026

--------------------------------------------------------------------------------

CATATAN VALIDASI
- File ini berisi laporan Tugas Besar sesuai struktur yang diminta (Bagian Awal, Bagian Inti, Bagian Akhir).
- Daftar pustaka telah distandarisasi dan dilengkapi; sumber daring menyertakan URL dan tanggal akses (20 Januari 2026).
- Pemeriksaan EYD telah dilakukan: perbaikan tata bahasa, kapitalisasi, dan tanda baca. Penggantian placeholder (nama, NIM, fakultas, institusi, dsb.) diperlukan oleh penyusun.
- Validitas faktual terhadap isi sumber eksternal (mis. DOI, nomor jurnal, atau edisi buku cetak) belum diverifikasi secara otomatis oleh sistem — disarankan verifikasi akhir oleh penyusun.

--------------------------------------------------------------------------------

A. BAGIAN AWAL

1. Halaman Sampul

LAPORAN TUGAS BESAR

MATA KULIAH: Pemrograman Perangkat Bergerak (IF05104)

JUDUL PROYEK: Aplikasi Payroll Mobile (Payroll Management System)

PENYUSUN: [Nama Lengkap]

NIM: [NIM]

PROGRAM STUDI: Informatika, Fakultas [Nama Fakultas]

INSTITUSI: [Nama Universitas]

DOSEN PEMBIMBING: [Nama Dosen Pembimbing]

SEMESTER: 5 — Tahun Akademik 2025/2026


2. Halaman Judul

LAPORAN TUGAS BESAR

"Aplikasi Payroll Mobile untuk Pengelolaan Gaji dan Profil Karyawan"

Disusun untuk memenuhi syarat Ujian Akhir Semester Mata Kuliah Pemrograman Perangkat Bergerak (IF05104)

Disusun oleh:

[Nama Lengkap] — NIM: [NIM]

Program Studi Informatika, [Nama Universitas]

Pembimbing: [Nama Dosen Pembimbing]

Tanggal Penyerahan: Januari 2026


3. Kata Pengantar

Puji syukur penulis panjatkan ke hadirat Tuhan Yang Maha Esa karena dengan rahmat-Nya laporan Tugas Besar ini dapat diselesaikan. Laporan ini disusun sebagai salah satu syarat penyelesaian mata kuliah Pemrograman Perangkat Bergerak (IF05104). Aplikasi yang dilaporkan adalah aplikasi mobile untuk pengelolaan payroll (penggajian) yang telah diimplementasikan menggunakan teknologi Flutter dan layanan Firebase.

Penulis menyadari bahwa laporan ini masih dapat disempurnakan. Oleh karena itu, kritik dan saran yang membangun sangat penulis harapkan demi perbaikan di masa mendatang. Penulis mengucapkan terima kasih kepada dosen pembimbing, rekan-rekan, dan semua pihak yang telah memberikan dukungan selama proses perancangan dan pengembangan aplikasi.


4. Daftar Isi

- A. BAGIAN AWAL
  - Halaman Sampul
  - Halaman Judul
  - Kata Pengantar
  - Daftar Isi
- B. BAGIAN INTI
  - BAB I – PENDAHULUAN
  - BAB II – TINJAUAN PUSTAKA / LANDASAN TEORI
  - BAB III – IMPLEMENTASI DAN PEMBAHASAN
  - BAB IV – PENUTUP
- C. BAGIAN AKHIR
  - Daftar Pustaka
  - Lampiran


B. BAGIAN INTI

BAB I – PENDAHULUAN

1. Latar Belakang

Dalam pengelolaan sumber daya manusia di banyak organisasi, proses penghitungan gaji, pencatatan kehadiran, dan penyimpanan data profil karyawan sering kali dilakukan secara manual atau tersebar di beberapa sistem yang tidak terintegrasi. Kondisi ini berpotensi menimbulkan kesalahan perhitungan, keterlambatan pembayaran, serta kesulitan dalam menghasilkan laporan yang akurat. Kebutuhan akan sistem yang mampu mengotomatisasi proses payroll, menyimpan data profil karyawan secara terpusat, serta menyediakan laporan yang mudah diakses menjadi penting, terutama pada era mobilitas tinggi di mana akses melalui perangkat mobile semakin dominan.

Perkembangan teknologi mobile dan layanan backend cloud—seperti Flutter untuk pengembangan antarmuka lintas platform dan Firebase untuk layanan autentikasi serta basis data—memungkinkan pengembangan aplikasi payroll yang responsif, aman, dan dapat diakses kapan saja melalui perangkat seluler. Oleh karena itu, dikembangkan aplikasi mobile payroll yang mengintegrasikan autentikasi pengguna, manajemen data karyawan, perhitungan komponen gaji, serta pembuatan laporan profil.


2. Rumusan Masalah

Rumusan masalah yang menjadi fokus dalam tugas besar ini adalah:

a. Bagaimana merancang dan mengimplementasikan aplikasi mobile yang memungkinkan pengelolaan data karyawan dan perhitungan gaji secara terpusat?

b. Bagaimana mengintegrasikan autentikasi dan penyimpanan data secara aman menggunakan layanan cloud pada aplikasi mobile?

c. Bagaimana menyajikan laporan profil dan rekap penggajian yang mudah diakses oleh pengguna melalui perangkat mobile?

d. Apa saja kendala teknis yang muncul selama pengembangan dan bagaimana solusi yang diterapkan?


3. Tujuan Tugas Besar

Tujuan yang ingin dicapai dalam tugas besar ini adalah:

a. Mengembangkan aplikasi mobile berbasis Flutter yang dapat melakukan manajemen profil karyawan dan penghitungan payroll.

b. Mengimplementasikan solusi autentikasi dan penyimpanan data menggunakan Firebase untuk memastikan keamanan dan konsistensi data.

c. Menyediakan fitur pembuatan laporan profil karyawan dan rekap penggajian yang dapat diakses melalui antarmuka mobile.

d. Menganalisis hasil implementasi, termasuk kekuatan, keterbatasan, dan rekomendasi pengembangan lebih lanjut.


4. Manfaat Penelitian/Perancangan

Manfaat praktis dan akademis dari perancangan ini antara lain:

- Praktis: Memfasilitasi proses penggajian dan manajemen data karyawan bagi usaha kecil hingga menengah, mengurangi kesalahan manual, dan mempercepat pembuatan laporan.
- Akademis: Menambah wawasan tentang penerapan arsitektur aplikasi mobile, integrasi Flutter dengan Firebase, serta praktik terbaik pengembangan aplikasi lintas platform.


BAB II – TINJAUAN PUSTAKA / LANDASAN TEORI

1. Konsep Pemrograman Perangkat Bergerak

Pemrograman perangkat bergerak mencakup pembuatan aplikasi untuk perangkat seperti smartphone dan tablet. Karakteristik penting yang perlu diperhatikan meliputi keterbatasan sumber daya (CPU, memori, baterai), antarmuka pengguna berbasis sentuhan, manajemen siklus hidup aplikasi, serta kebutuhan akan penanganan konektivitas yang tidak selalu stabil. Arsitektur aplikasi mobile umumnya memisahkan lapisan presentasi (UI), logika bisnis, dan akses data untuk memudahkan pemeliharaan dan pengujian.


2. Teknologi yang Digunakan

Aplikasi ini diimplementasikan menggunakan teknologi dan layanan sebagai berikut:

- Flutter: Framework UI lintas platform dari Google yang menggunakan bahasa pemrograman Dart, memungkinkan pengembangan satu basis kode untuk Android dan iOS dengan performa mendekati native.
- Dart: Bahasa pemrograman yang digunakan pada Flutter untuk penulisan logika aplikasi.
- Firebase: Layanan backend-as-a-service yang menyediakan fitur autentikasi pengguna (Firebase Authentication), basis data dokumen (Cloud Firestore), dan infrastruktur cloud untuk penyimpanan serta sinkronisasi data.
- Paket pendukung Flutter: library untuk manajemen state, validasi input, dan pembuatan laporan/penanganan cetak (paket `printing` atau `pdf` sesuai implementasi proyek).
- Struktur proyek: Organisasi kode mengikuti pemisahan modul `models/`, `services/`, `screens/`, `widgets/`, `utils/`, dan `theme/` untuk keteraturan dan kemudahan pemeliharaan.


3. Teori-teori Pendukung

Teori langsung yang relevan dengan sistem yang diimplementasikan:

- Prinsip Arsitektur Berlapis (Layered Architecture): Memisahkan modul presentasi, logika bisnis, dan akses data untuk meningkatkan keterawatan. Dalam proyek ini, pemisahan terlihat pada folder `screens/` (UI), `services/` (integrasi Firebase), dan `models/` (entitas data).
- Autentikasi dan Keamanan Data: Konsep dasar autentikasi (misalnya token-based authentication) dan praktik keamanan data diterapkan melalui konfigurasi Firebase Authentication dan aturan keamanan Cloud Firestore.
- Perhitungan Komponen Gaji: Konsep dasar payroll termasuk komponen seperti gaji pokok, tunjangan, potongan (pajak, iuran), dan logika perhitungan gaji bersih yang diimplementasikan pada modul perhitungan.


BAB III – IMPLEMENTASI DAN PEMBAHASAN

1. Implementasi Sistem

a. Arsitektur Aplikasi

Aplikasi diimplementasikan dengan arsitektur berlapis sederhana:

- Presentation Layer: `screens/` dan `widgets/` berisi halaman antarmuka seperti layar login, dashboard, daftar karyawan, detail karyawan, form payroll, dan layar laporan. UI dibangun menggunakan widget Flutter dengan penyesuaian tema di folder `theme/`.
- Business Logic Layer: Fungsi-fungsi validasi, perhitungan gaji, dan orkestrasi antara UI dan layanan berada pada `utils/` dan beberapa file di `services/`.
- Data Layer: `services/` berisi integrasi dengan Firebase (autentikasi, Cloud Firestore) dan `models/` mendefinisikan entitas seperti `Employee`, `PayrollRecord`, dan `UserProfile`.


b. Fitur Utama dan Cara Kerjanya

Fitur utama yang telah diimplementasikan meliputi:

- Autentikasi Pengguna: Pengguna (admin atau staf HR) dapat masuk menggunakan email dan kata sandi melalui Firebase Authentication. Akses data disesuaikan menurut peran pengguna.
- Manajemen Data Karyawan (CRUD): Pengguna dapat menambah, mengubah, menghapus, dan melihat detail profil karyawan. Data tersimpan di Cloud Firestore dengan struktur dokumen yang memuat atribut seperti nama, NIK, jabatan, gaji pokok, dan kontak.
- Penghitungan Payroll: Modul perhitungan menerima input komponen gaji (gaji pokok, tunjangan, potongan) dan menerapkan rumus untuk menghitung gaji bersih. Hasil disimpan sebagai `PayrollRecord` pada basis data.
- Laporan Profil dan Rekap Penggajian: Pengguna dapat menampilkan rekap gaji per periode serta profil karyawan; laporan dapat diekspor atau dicetak bila fitur printing/pdf diaktifkan.
- UI dan Navigasi: Menggunakan Navigator Flutter untuk alur aplikasi dan widget adaptif untuk mendukung berbagai ukuran layar.


c. Alat, Library, dan Proses Pengembangan

- SDK dan Build: Proyek dibangun dengan Flutter SDK; konfigurasi Android dan iOS terdapat di direktori proyek.
- Backend: Firebase dikonfigurasi pada proyek, terlihat dari adanya `firebase_options.dart` dan berkas konfigurasi Google Services.
- Library: Paket-paket Flutter untuk Firebase Authentication, Cloud Firestore, dan paket pembuatan PDF/printing (misalnya `printing`) digunakan sesuai kebutuhan proyek.
- Dokumentasi: Terdapat dokumentasi setup Firebase (FIREBASE_SETUP.md) dan dokumentasi fitur di folder `docs/`.


2. Hasil

Hasil implementasi nyata meliputi:

- Aplikasi mobile yang dapat dijalankan pada emulator atau perangkat nyata (Android/iOS) dan menyediakan antarmuka untuk manajemen karyawan dan payroll.
- Fitur autentikasi yang mengatur akses ke data payroll.
- Fitur CRUD untuk profil karyawan yang tersimpan di Cloud Firestore.
- Modul perhitungan gaji yang menghasilkan rekap per periode dan menyimpannya ke basis data.
- Fitur pembuatan laporan profil dan rekap penggajian yang dapat ditampilkan dalam aplikasi dan diekspor/dicetak.


3. Pembahasan Hasil

a. Pencapaian Tujuan

Tujuan utama proyek telah dicapai: pembuatan aplikasi mobile untuk manajemen payroll yang terintegrasi dengan layanan cloud. Fitur autentikasi, penyimpanan data, perhitungan gaji, dan pembuatan laporan telah diimplementasikan dan dapat diuji secara fungsional.

b. Kekuatan Sistem

- Integrasi Cloud: Pemanfaatan Firebase memudahkan sinkronisasi data dan autentikasi.
- Keteraturan Kode: Pemisahan modul meningkatkan keterawatan dan memudahkan pengujian.
- Portabilitas: Penggunaan Flutter memungkinkan dukungan lintas platform dengan satu basis kode.

c. Keterbatasan dan Tantangan Teknis

- Dukungan Offline Terbatas: Implementasi saat ini mengutamakan konektivitas online; mekanisme cache/offline perlu ditingkatkan.
- Aturan Keamanan: Perlu penyusunan aturan keamanan Cloud Firestore yang lebih rinci untuk penggunaan produksi.
- Pengujian Terbatas: Pengujian fungsional dilakukan, namun pengujian beban dan pengujian unit untuk skenario penggajian kompleks perlu diperluas.

d. Solusi yang Diterapkan

- Panduan setup Firebase dan konfigurasi proyek disertakan agar integrasi dapat direplikasi.
- Validasi input dilakukan di UI dan logika aplikasi untuk mengurangi data tidak valid.
- Dokumentasi fitur disediakan agar pengembang selanjutnya mudah memahami alur dan menambah fitur baru.


BAB IV – PENUTUP

1. Kesimpulan

- Aplikasi Payroll Mobile berhasil diimplementasikan menggunakan Flutter dan Firebase, mencakup autentikasi, manajemen data karyawan, perhitungan payroll, dan pembuatan laporan.
- Struktur proyek yang rapi memudahkan pemeliharaan dan pengembangan lanjutan.
- Terdapat keterbatasan seperti dukungan offline terbatas dan perlunya penguatan aturan keamanan basis data serta pengujian lebih luas.


2. Saran

Rekomendasi pengembangan lebih lanjut:

- Implementasikan mekanisme sinkronisasi offline (cache lokal) menggunakan solusi seperti `sqflite` atau `hive`.
- Perkuat aturan keamanan di Cloud Firestore berdasarkan model peran (role-based access control) dan tambahkan mekanisme logging untuk audit.
- Tambahkan pengujian unit dan integrasi yang lebih luas, terutama pada logika perhitungan gaji dan ekspor laporan.
- Kembangkan antarmuka administrator untuk pengaturan struktur gaji dan skema potongan/pajak yang fleksibel.


C. BAGIAN AKHIR

1. Daftar Pustaka

Sumber ilmiah dan dokumentasi teknis yang digunakan dalam perancangan dan implementasi proyek ini:

- Hevner, A. R., March, S. T., Park, J., & Ram, S. (2004). Design Science in Information Systems Research. MIS Quarterly, 28(1), 75–105.

- Google. (2026). Flutter — Beautiful native apps in record time. Diakses 20 Januari 2026 dari https://flutter.dev
  - Dokumen utama: https://flutter.dev/docs (panduan pengembangan dan referensi widget).

- Dart Language. (2026). Dart documentation. Diakses 20 Januari 2026 dari https://dart.dev

- Google. (2026). Firebase Documentation. Diakses 20 Januari 2026 dari https://firebase.google.com/docs
  - Halaman penting: Firebase Authentication (https://firebase.google.com/docs/auth), Cloud Firestore (https://firebase.google.com/docs/firestore).

- Google. (2026). Material Design. Diakses 20 Januari 2026 dari https://material.io

- Paket Flutter untuk pencetakan dan PDF:
  - `printing` package — pub.dev. (2026). printing package for Flutter. Diakses 20 Januari 2026 dari https://pub.dev/packages/printing
  - `pdf` package — pub.dev. (2026). pdf package for Flutter. Diakses 20 Januari 2026 dari https://pub.dev/packages/pdf

- Alat konversi dan pustaka yang digunakan untuk ekspor/preview laporan:
  - Pandoc. (2026). Pandoc — a universal document converter. Diakses 20 Januari 2026 dari https://pandoc.org
  - ReportLab. (2026). ReportLab: PDF library for Python. Diakses 20 Januari 2026 dari https://www.reportlab.com
  - Python Software Foundation. (2026). Python documentation. Diakses 20 Januari 2026 dari https://www.python.org

- Dokumentasi tambahan dan panduan penggunaan:
  - Firebase setup guide in project: `docs/FIREBASE_SETUP.md` (lokal, proyek).

Sumber kode proyek (file internal yang menjadi rujukan implementasi):

- Kode entry point: `lib/main.dart` (lokal, proyek).
- Konfigurasi Firebase: `lib/firebase_options.dart` (lokal, proyek).
- Modul layanan dan integrasi: semua file pada folder `lib/services/` (lokal, proyek).
- Definisi model data: semua file pada folder `lib/models/` (lokal, proyek).
- Skrip konversi laporan yang ditambahkan: `tools/md_to_pdf.py` (lokal, proyek).
- Salinan laporan: `Laporan_UAS_Pemrograman_Perangkat_Bergerak.md` dan `Laporan_UAS_Pemrograman_Perangkat_Bergerak.html` (lokal, proyek).

Catatan mengenai daftar pustaka:
- Entri jurnal (Hevner et al.) digunakan sebagai landasan metodologis desain sistem informasi. Jika institusi mensyaratkan gaya sitasi tertentu (mis. APA, MLA, IEEE), silakan sesuaikan formatnya.
- Untuk referensi daring (Flutter, Firebase, paket pub.dev, pandoc, reportlab), lampirkan versi paket atau tanggal revisi bila diperlukan untuk replikasi eksperimen.



2. Lampiran

Lampiran A — Struktur Direktori Proyek (Ringkasan)

- lib/
  - firebase_options.dart
  - main.dart
  - models/        (definisi entitas data seperti Employee, PayrollRecord)
  - screens/       (halaman UI: login, dashboard, daftar karyawan, detail karyawan, payroll, laporan)
  - services/      (integrasi Firebase: auth_service, firestore_service)
  - widgets/       (komponen UI yang dapat digunakan ulang)
  - utils/         (fungsi bantu seperti validasi dan perhitungan gaji)
  - theme/         (tema aplikasi)

- android/ dan ios/ (konfigurasi build platform)
- docs/ (panduan setup Firebase dan dokumentasi fitur)


Lampiran B — Contoh Alur Penggunaan Singkat

1. Ikuti petunjuk setup Firebase pada `docs/FIREBASE_SETUP.md` dan letakkan `google-services.json` serta konfigurasi yang diperlukan.
2. Jalankan aplikasi pada emulator atau perangkat fisik.
3. Login menggunakan akun yang terdaftar atau daftar akun baru jika diizinkan.
4. Tambah profil karyawan pada menu manajemen karyawan.
5. Masukkan komponen gaji untuk periode tertentu dan simpan rekap payroll.
6. Akses menu laporan untuk melihat rekap gaji dan profil; ekspor atau cetak laporan bila diperlukan.


Lampiran C — Catatan Implementasi Penting

- Pastikan `firebase_options.dart` dan `google-services.json` (Android) atau `GoogleService-Info.plist` (iOS) dikonfigurasi sesuai proyek Firebase yang benar.
- Periksa aturan keamanan Cloud Firestore agar sesuai dengan model akses yang diinginkan.
- Gantilah placeholder [Nama Lengkap], [NIM], [Nama Fakultas], dan [Nama Universitas] sebelum mencetak atau mengumpulkan laporan.


---

PENUTUP SINGKAT: Laporan ini menyajikan bukti implementasi aplikasi payroll mobile, hasil pengujian fungsional, serta analisis yang relevan dengan tujuan tugas besar. Untuk langkah selanjutnya, penyusun dapat meminta:

- Ekspor file ini menjadi PDF dan menyiapkan tata letak cetak; atau
- Penambahan lampiran kode penting (mis. `lib/main.dart` atau contoh `models/employee.dart`); atau
- Verifikasi lanjutan pada daftar pustaka sesuai gaya sitasi yang diinginkan.
