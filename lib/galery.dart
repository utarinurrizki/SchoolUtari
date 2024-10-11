import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GaleryScreen extends StatefulWidget {
  const GaleryScreen({super.key});

  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  List<dynamic> galeryData = [];
  bool isLoading = true;
  final String apiUrl = 'https://praktikum-cpanel-unbin.com/kelompok_rio/api.php?endpoint=galery';

  TextEditingController judulController = TextEditingController();
  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGaleryData();
  }

  Future<void> fetchGaleryData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        galeryData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Gagal memuat data galeri');
    }
  }

  Future<void> createGalery() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'judul_galery': judulController.text,
        'isi_galery': isiController.text,
      }),
    );

    if (response.statusCode == 200) {
      fetchGaleryData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data galeri berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data galeri')),
      );
    }
  }

  Future<void> updateGalery(String id) async {
    final response = await http.put(
      Uri.parse('$apiUrl&kd_galery=$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'judul_galery': judulController.text,
        'isi_galery': isiController.text,
      }),
    );

    if (response.statusCode == 200) {
      fetchGaleryData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data galeri berhasil diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data galeri')),
      );
    }
  }

  Future<void> deleteGalery(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl&kd_galery=$id'),
    );

    if (response.statusCode == 200) {
      fetchGaleryData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data galeri berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data galeri')),
      );
    }
  }

  void showAddGaleryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Data Galeri'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(labelText: 'Judul Galeri'),
              ),
              TextField(
                controller: isiController,
                decoration: InputDecoration(labelText: 'URL Gambar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                createGalery();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: galeryData.length,
              itemBuilder: (context, index) {
                final item = galeryData[index];
                return Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          item['isi_galery'] ?? '',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['judul_galery'] ?? 'Tidak Ada Judul',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['isi_galery'] ?? 'Tidak Ada Deskripsi',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddGaleryDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}