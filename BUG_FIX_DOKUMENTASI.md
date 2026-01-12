# Bug Fix Documentation: InheritedWidget Error pada Dashboard

## 🔴 Masalah yang Dilaporkan

```
dependOnInheritedWidgetOfExactType<_InheritedTheme>() or 
dependOnInheritedElement() was called before DashboardPageState.initState() completed.
```

**Kapan terjadi:** Setelah login berhasil dan navigasi ke halaman Dashboard

---

## 🔍 Root Cause Analysis

### Penyebab Error:
Error ini terjadi ketika widget mencoba mengakses **InheritedWidget** (seperti `Theme`, `MediaQuery`, atau `Navigator`) sebelum widget siap. 

### Lokasi Bug:
File: `lib/screens/dashboard_page.dart`

```dart
// ❌ KODE LAMA - BERMASALAH
class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomePage(),  // ← MASALAH: Memanggil _buildHomePage() di initState()
      EmployeePage(user: widget.user),
      PayrollPage(user: widget.user),
      ProfilePage(user: widget.user),
    ];
  }

  Widget _buildHomePage() {
    final hour = DateTime.now().hour;
    final greeting = GreetingMessage.getGreeting(hour);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(  // ← Theme.of(context) DI INITSTATE!
                    color: AppColors.white70,
                  ),
                ),
                Text(
                  widget.user.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(  // ← Theme.of(context) DI INITSTATE!
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Mengapa Error Terjadi?

1. **initState()** dipanggil ketika widget baru dibuat
2. Di dalam `initState()`, kita memanggil `_buildHomePage()`
3. `_buildHomePage()` menggunakan `Theme.of(context)` (InheritedWidget)
4. Pada saat initState() belum selesai, context belum siap sepenuhnya untuk akses InheritedWidget
5. **Hasil:** `dependOnInheritedWidgetOfExactType()` error

---

## ✅ Solusi: Lazy Building Pages

### Konsep:
Alih-alih membuat semua pages di `initState()`, kita membuat pages **secara lazy** (on-demand) di `build()` method ketika context sudah siap.

### Kode Setelah Diperbaiki:

```dart
// ✅ KODE BARU - DIPERBAIKI
class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // ✅ initState() sekarang hanya melakukan inisialisasi sederhana
    // TIDAK membangun widgets yang membutuhkan context
  }

  // ✅ Lazy build pages - method ini dipanggil dari build()
  List<Widget> _buildPages() {
    return [
      _buildHomePage(),  // Sekarang aman karena context sudah siap
      EmployeePage(user: widget.user),
      PayrollPage(user: widget.user),
      ProfilePage(user: widget.user),
    ];
  }

  Widget _buildHomePage() {
    final hour = DateTime.now().hour;
    final greeting = GreetingMessage.getGreeting(hour);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(  // ✅ Sekarang aman
                    color: AppColors.white70,
                  ),
                ),
                Text(
                  widget.user.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(  // ✅ Sekarang aman
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();  // ✅ Build pages di build() method, bukan initState()
    
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryGradientStart,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppText.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: AppText.employees,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            activeIcon: Icon(Icons.attach_money),
            label: AppText.salary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppText.profile,
          ),
        ],
      ),
    );
  }
}
```

---

## 📊 Perbandingan SEBELUM vs SESUDAH

| Aspek | SEBELUM ❌ | SESUDAH ✅ |
|-------|-----------|---------|
| **Pages dibuat di** | `initState()` | `build()` |
| **Context availability** | Belum siap | Sudah siap |
| **Theme.of(context)** | Diakses di initState | Diakses di build |
| **Lazy evaluation** | Tidak | Ya (on-demand) |
| **Memory usage** | Semua pages di-build langsung | Hanya page aktif yang di-build ulang |
| **Error** | ❌ dependOnInheritedWidgetOfExactType error | ✅ Tidak ada error |

---

## 🔧 Best Practices Flutter Lifecycle

### ✅ Apa yang BOLEH di initState():
- Menginisialisasi state variables
- Menambahkan listeners (seperti StreamController)
- Memanggil methods yang tidak bergantung pada context
- Setup animasi controller

```dart
@override
void initState() {
  super.initState();
  _counter = 0;  // ✅ Inisialisasi simple variable
  _animController = AnimationController(...);  // ✅ Membuat controller
}
```

### ❌ Apa yang TIDAK BOLEH di initState():
- Akses `Theme.of(context)`
- Akses `MediaQuery.of(context)`
- Membaca `InheritedWidget`
- Memanggil `Navigator.push/pop`
- Build widgets yang membutuhkan context

```dart
@override
void initState() {
  super.initState();
  final theme = Theme.of(context);  // ❌ JANGAN
  final pages = [_buildHomePage()];  // ❌ JANGAN
}
```

### ✅ Lokasi yang TEPAT untuk context-dependent operations:

**1. Di `build()` method:**
```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);  // ✅ BOLEH
  final mediaQuery = MediaQuery.of(context);  // ✅ BOLEH
  return ...
}
```

**2. Di `didChangeDependencies()` untuk operations yang jarang:**
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final theme = Theme.of(context);  // ✅ BOLEH
  // Dipanggil saat dependency berubah
}
```

**3. Di event handlers (onPressed, onTap, dll):**
```dart
ElevatedButton(
  onPressed: () {
    final theme = Theme.of(context);  // ✅ BOLEH
    Navigator.of(context).push(...);  // ✅ BOLEH
  },
)
```

---

## 🎯 Ringkasan Perubahan

### File yang diubah:
- `lib/screens/dashboard_page.dart`

### Perubahan spesifik:
1. ✅ Hapus `late List<Widget> _pages;` variable
2. ✅ Kosongkan `initState()` - hanya panggil `super.initState()`
3. ✅ Tambah method `_buildPages()` untuk lazy building
4. ✅ Di `build()`, panggil `final pages = _buildPages();`
5. ✅ Gunakan `pages[_selectedIndex]` alih-alih `_pages[_selectedIndex]`

### Hasil:
- ✅ Error `dependOnInheritedWidgetOfExactType` hilang
- ✅ Dashboard terbuka tanpa crash
- ✅ Mengikuti Flutter best practices
- ✅ Kode lebih maintainable

---

## 🧪 Testing

Untuk memverifikasi fix:

1. **Jalankan login:**
   ```bash
   flutter run
   ```

2. **Login dengan credentials:**
   - Email: `admin@payroll.com`
   - Password: `Admin123!`

3. **Verifikasi:**
   - ✅ Login berhasil
   - ✅ Dashboard terbuka tanpa error
   - ✅ Tab navigation berfungsi normal
   - ✅ Theme dan styling tampil dengan benar

---

## 📚 Referensi

- [Flutter State Lifecycle](https://api.flutter.dev/flutter/widgets/State-class.html)
- [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)
- [Best Practices: When to use Theme.of()](https://flutter.dev/docs/development/best-practices)

---

**Dokumentasi dibuat:** 9 Januari 2026
**Status:** ✅ FIXED
