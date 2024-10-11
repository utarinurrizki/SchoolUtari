import 'package:flutter/material.dart';

void main() => runApp(SistemSekolahApp());

class SistemSekolahApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Informasi Sekolah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/dataSiswa': (context) => DataSiswaPage(),
        '/jadwalPelajaran': (context) => JadwalPelajaranPage(),
        '/absensi': (context) => AbsensiPage(),
        '/nilai': (context) => NilaiPage(),
        '/pengumuman': (context) => PengumumanPage(),
        '/pengaturan': (context) => PengaturanPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistem Informasi Sekolah'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildMenuItem(context, Icons.school, 'Data Siswa', Colors.orange, '/dataSiswa'),
            _buildMenuItem(context, Icons.schedule, 'Jadwal Pelajaran', Colors.blue, '/jadwalPelajaran'),
            _buildMenuItem(context, Icons.check_circle, 'Absensi', Colors.green, '/absensi'),
            _buildMenuItem(context, Icons.grade, 'Nilai', Colors.red, '/nilai'),
            _buildMenuItem(context, Icons.announcement, 'Pengumuman', Colors.purple, '/pengumuman'),
            _buildMenuItem(context, Icons.settings, 'Pengaturan', Colors.grey, '/pengaturan'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Color color, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50.0, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman untuk Data Siswa
class DataSiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Siswa'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'Halaman Data Siswa',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Halaman untuk Jadwal Pelajaran
class JadwalPelajaranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Pelajaran'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Halaman Jadwal Pelajaran',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Halaman untuk Absensi
class AbsensiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Halaman Absensi',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Halaman untuk Nilai
class NilaiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nilai'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          'Halaman Nilai',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Halaman untuk Pengumuman
class PengumumanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text(
          'Halaman Pengumuman',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Halaman untuk Pengaturan
class PengaturanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Text(
          'Halaman Pengaturan',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
