# Planning Pengajaran Flutter: Slicing UI & Local Storage Simpel (Hive)

> **Total Durasi:** 30 Menit  
> **Prasyarat Peserta:** Sudah memahami dasar `MaterialApp`, `Scaffold`, `StatefulWidget`, dan `setState` (melanjutkan project starter `pekris_day3` pada `lib/main.dart`).  
> **Target Akhir:** Peserta mampu memecah tampilan aplikasi **ListNote (Catatan Cepat)** menjadi komponen widget kecil yang reusable (**Slicing UI**) dan menyimpan daftar catatan secara lokal agar tidak hilang saat aplikasi ditutup (**Hive Simpel**).

---

## 1. Tujuan Pembelajaran

Setelah sesi 30 menit ini, peserta diharapkan mampu:
1. Memahami konsep **Widget Composition** (*sebuah komponen Flutter tersusun dari komponen widget lain*).
2. Memisahkan UI yang menumpuk di satu file (`main.dart`) menjadi halaman dan custom widget terpisah (`StatelessWidget` dengan parameter data & callback).
3. Menggunakan **Hive (`hive_flutter`)** versi simpel (tanpa `TypeAdapter` / `build_runner`) untuk menyimpan, membaca, dan menghapus daftar catatan string (`Box<String>`).

---

## 2. Rundown & Alokasi Waktu (30 Menit)

| Waktu | Durasi | Segmen | Fokus Materi & Aktivitas |
| :--- | :--- | :--- | :--- |
| **00:00 – 03:00** | 3 menit | **Pembukaan & Review Kode Awal** | Demo aplikasi ListNote di `main.dart`, identifikasi 2 masalah: kode menumpuk di 1 file & catatan hilang saat restart. |
| **03:00 – 16:00** | 13 menit | **Materi 1: Slicing UI (Widget Composition)** | Konsep pohon widget + praktik memecah `HomePage` menjadi 4 komponen widget reusable di `lib/widgets/`. |
| **16:00 – 27:00** | 11 menit | **Materi 2: Hive Simpel (`local_storage`)** | Konsep `Box<String>` + setup `hive_flutter`, simpan & hapus catatan di `notesBox`, lalu uji *Cold Restart*. |
| **27:00 – 30:00** | 3 menit | **Recap & Tanya Jawab** | Rangkuman pola Slicing & Hive, perbedaan Hot Reload vs Cold Restart, dan gambaran materi lanjutan (`TypeAdapter`). |

---

## 3. Detail Materi & Langkah Mengajar

### Segmen 1: Pembukaan & Konteks Masalah (00:00 – 03:00 | 3 Menit)
- Jalankan project tahap awal (`lib/main.dart`): tunjukkan fitur **Catatan Cepat (ListNote)** — tambah catatan baru dan hapus catatan.
- Ajak peserta melihat dua keterbatasan kode awal:
  1. **Masalah Struktur UI:** Semua tampilan (header, kartu ringkasan, input catatan, dan daftar catatan) serta logika halaman menumpuk di `main.dart`. Jika halaman makin kompleks, kode menjadi panjang, berulang, dan sulit dirawat.
  2. **Masalah Penyimpanan:** Daftar catatan masih disimpan pada `List<String>` di memori (RAM). Jika aplikasi ditutup lalu dijalankan ulang (*Cold Restart*), semua catatan yang baru dibuat akan hilang.

---

### Segmen 2: Slicing UI — Komponen Terdiri atas Widget Lain (03:00 – 16:00 | 13 Menit)

#### A. Penjelasan Konsep Singkat (3 Menit)
- **Prinsip Utama:** Di Flutter, UI dibangun dengan menyusun widget kecil menjadi widget yang lebih besar (*Widget Composition*).
- **Analogi LEGO:** Halaman (`HomePage`) hanya bertugas menyusun tata letak dan memegang state daftar catatan, sedangkan detail tampilan diserahkan ke komponen widget kecil:
  - `ProfileHeaderCard` → tersusun dari `Container` + `Row` + `CircleAvatar` + `Column(Text, Text)` + badge label.
  - `StatCard` → komponen **reusable** (tersusun dari `Card` + `Padding` + `Row` + `Icon` + `Column(Text, Text)`). Satu class dipakai berkali-kali cukup dengan mengganti parameter.
  - `NoteInputBar` → komponen input interaktif (`Row` + `TextField` + `FilledButton`) yang menerima `TextEditingController` dan callback `VoidCallback onAdd`.
  - `QuickNoteTile` → komponen baris catatan (`Card` + `ListTile`) dengan teks catatan (`note`) dan tombol hapus (`onDelete`).
- **Aturan Main Slicing yang Bersih:**
  - Data masuk lewat parameter `final` di constructor.
  - Aksi anak melapor ke parent lewat callback (`VoidCallback`, `ValueChanged<T>`).

#### B. Praktik Live Coding / Walkthrough (10 Menit)
Struktur folder target:
```text
lib/
├── main.dart                     # Entry point & MyApp
├── pages/
│   └── home_page.dart            # Halaman utama penyusun komponen & state ListNote
└── widgets/
    ├── profile_header_card.dart  # Komponen header sambutan
    ├── stat_card.dart            # Komponen kartu statistik reusable
    ├── note_input_bar.dart       # Komponen input catatan & tombol Simpan
    └── quick_note_tile.dart      # Komponen item baris catatan
```

Urutan penyampaian di kelas (agar tidak habis waktu mengetik):
1. **Pindahkan halaman dari `main.dart` ke `lib/pages/home_page.dart`** *(2 menit)* — tunjukkan `main.dart` sekarang bersih, hanya mengurus entry point dan konfigurasi `MyApp`.
2. **Buat `StatCard` (`lib/widgets/stat_card.dart`)** *(3 menit)* — contoh paling jelas bahwa 1 widget tersusun dari `Card` → `Row` → `Icon` & `Column`, lalu dipakai **2 kali** di dalam `Row` + `Expanded` (Kartu "Total Catatan" & Kartu "Penyimpanan").
3. **Tunjukkan `ProfileHeaderCard` & `NoteInputBar`** *(3 menit)* — fokus pada komposisi layout serta cara melempar `controller` dan callback `onAdd` dari `HomePage` ke widget anak.
4. **Tunjukkan `QuickNoteTile`** *(2 menit)* — tampilkan bagaimana setiap item pada `List<String>` di-render sebagai `QuickNoteTile(note: ..., onDelete: ...)`.
5. **Checkpoint:** Tekankan bahwa sampai titik ini UI sudah rapi hasil *slicing*, namun daftar catatan masih di memori RAM (status `Memori` — hilang saat aplikasi ditutup).

---

### Segmen 3: Hive Simpel untuk `local_storage` (16:00 – 27:00 | 11 Menit)

#### A. Penjelasan Konsep Singkat (2 Menit)
- **Kenapa Hive?** Database lokal NoSQL ringan berbasis *Key-Value* (`Box`) yang cepat dan berjalan langsung di Dart.
- **Kenapa Pendekatan Simpel (Tanpa `TypeAdapter` / `build_runner`)?**
  - Dalam waktu 30 menit, setup `hive_generator` + `build_runner` berisiko memakan waktu dan memicu error versi.
  - Untuk daftar catatan berbentuk teks (`String`), kita bisa langsung memakai `Box<String>` bawaan Hive.
- **Analogi `Box<String>`:** Anggap `Box` seperti daftar permanen yang tersimpan di penyimpanan perangkat:
  - Tambah catatan baru: `notesBox.add('Isi catatan')`
  - Hapus catatan di indeks tertentu: `notesBox.deleteAt(index)`
  - Baca semua catatan sebagai list: `notesBox.values.toList()`

#### B. Praktik Integrasi Hive ke Hasil Slicing (9 Menit)
1. **Install package (`pubspec.yaml`)** *(1 menit)*:
   ```bash
   flutter pub add hive_flutter
   ```
2. **Inisialisasi di `main()` (`lib/main.dart`)** *(2 menit)*:
   - Ubah `main()` menjadi `Future<void> main() async`.
   - Tambahkan inisialisasi sebelum `runApp`:
     ```dart
     WidgetsFlutterBinding.ensureInitialized();
     await Hive.initFlutter();
     await Hive.openBox<String>('notesBox');
     ```
3. **Hubungkan Daftar Catatan di `HomePage` (`lib/pages/home_page.dart`)** *(4 menit)*:
   - Ambil referensi box di `initState()`:
     ```dart
     late final Box<String> _notesBox;

     @override
     void initState() {
       super.initState();
       _notesBox = Hive.box<String>('notesBox');
     }
     ```
   - Saat tambah catatan: panggil `_notesBox.add(text)`, bersihkan controller, lalu `setState(() {})`.
   - Saat hapus catatan: panggil `_notesBox.deleteAt(index)`, lalu `setState(() {})`.
   - Di `build()`: baca daftar catatan terbaru lewat `final notes = _notesBox.values.toList();` dan perbarui kartu status penyimpanan menjadi `Hive`.
   - *(Catatan: Semua file di `lib/widgets/` — `ProfileHeaderCard`, `StatCard`, `NoteInputBar`, dan `QuickNoteTile` — **tidak perlu diubah sama sekali**! Inilah bukti nyata bahwa Slicing UI memisahkan tampilan dari sumber data.)*
4. **Demo Verifikasi Wajib** *(2 menit)*:
   - Tambahkan 1–2 catatan baru melalui `NoteInputBar`.
   - **Stop aplikasi lalu Run ulang** (jangan hanya Hot Reload) untuk membuktikan catatan tetap tersimpan.
   - Hapus salah satu catatan lalu restart ulang untuk memastikan penghapusan juga persisten.

---

### Segmen 4: Recap, Pertanyaan & Materi Lanjutan (27:00 – 30:00 | 3 Menit)
- **Ringkasan 2 Pilar Hari Ini:**
  1. **Slicing UI:** Pecah halaman menjadi widget kecil di `lib/widgets/`. Komponen menerima data lewat parameter dan mengirim aksi lewat callback.
  2. **Hive Simpel:** `Hive.initFlutter()` → `openBox<String>('notesBox')` → `add()` / `deleteAt()` / `values.toList()`. Karena UI sudah di-slice, mengganti penyimpanan dari memori ke Hive hanya menyentuh `main.dart` dan `home_page.dart`.
- **Next Step (di luar sesi 30 menit):**
  - Jika nanti menyimpan objek kompleks (misal `NoteModel` dengan `title`, `createdAt`, `isDone`), baru gunakan `TypeAdapter` + `hive_generator` atau simpan sebagai JSON/Map.
  - Bisa tingkatkan reaktivitas UI dengan `ValueListenableBuilder(valueListenable: _notesBox.listenable(), ...)`.

---

## 4. Tips untuk Pengajar Agar Tepat 30 Menit

1. **Jangan ketik semua boilerplate dari nol di depan kelas:** Fokus live-coding penuh pada `StatCard` + integrasi `Hive` di `main.dart` & `home_page.dart`, sementara widget pelengkap dijelaskan alur komposisinya.
2. **Tegaskan manfaat arsitektur saat transisi ke Hive:** Tunjukkan lewat `git diff` commit terakhir bahwa file di `lib/widgets/` tidak ada yang diedit saat menambahkan Hive — itu momen *"aha!"* kenapa Slicing UI penting.
3. **Wajib uji Cold Restart:** Banyak pemula mengira `setState` sudah menyimpan data karena mencoba Hot Reload. Pastikan demo menggunakan *Stop & Run* (Cold Restart).
