import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final String apiUrl = 'https://praktikum-cpanel-unbin.com/kelompok_rio/api.php?endpoint=informasi';

  TextEditingController judulController = TextEditingController();
  TextEditingController isiController = TextEditingController();
  TextEditingController tglController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController petugasController = TextEditingController();

  Future<List<dynamic>> fetchInfoData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal memuat data info');
    }
  }

  Future<void> createInfo() async {
    if (!validateInputs()) return;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'judul_info': judulController.text,
        'isi_info': isiController.text,
        'tgl_post_info': tglController.text,
        'status_info': statusController.text,
        'kd_petugas': petugasController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json.decode(response.body)['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: ${response.body}')),
      );
    }
  }

  Future<void> updateInfo(String id) async {
    if (!validateInputs()) return;

    final response = await http.put(
      Uri.parse('$apiUrl&kd_info=$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'kd_info': id,
        'judul_info': judulController.text,
        'isi_info': isiController.text,
        'tgl_post_info': tglController.text,
        'status_info': statusController.text,
        'kd_petugas': petugasController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json.decode(response.body)['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data')),
      );
    }
  }

  Future<void> deleteInfo(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl&kd_info=$id'),
    );

    if (response.statusCode == 200) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json.decode(response.body)['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

  bool validateInputs() {
    if (judulController.text.isEmpty ||
        isiController.text.isEmpty ||
        tglController.text.isEmpty ||
        statusController.text.isEmpty ||
        petugasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua kolom.')),
      );
      return false;
    }

    try {
      DateTime.parse(tglController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Format tanggal tidak valid. Gunakan YYYY-MM-DD.')),
      );
      return false;
    }

    return true;
  }

  void showInfoDialog({String? id, bool isEdit = false}) async {
    if (isEdit) {
      final response = await http.get(Uri.parse('$apiUrl&kd_info=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          judulController.text = data['judul_info'];
          isiController.text = data['isi_info'];
          tglController.text = data['tgl_post_info'];
          statusController.text = data['status_info'];
          petugasController.text = data['kd_petugas'];
        });
      } else {
        throw Exception('Gagal memuat data info untuk pembaruan');
      }
    } else {
      judulController.clear();
      isiController.clear();
      tglController.clear();
      statusController.clear();
      petugasController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Perbarui Info' : 'Tambah Info Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(labelText: 'Judul Info'),
                ),
                TextField(
                  controller: isiController,
                  decoration: InputDecoration(labelText: 'Isi Info'),
                ),
                TextField(
                  controller: tglController,
                  decoration: InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Status Info'),
                ),
                TextField(
                  controller: petugasController,
                  decoration: InputDecoration(labelText: 'Kode Petugas'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isEdit ? 'Perbarui' : 'Tambah'),
              onPressed: () {
                if (isEdit) {
                  updateInfo(id!);
                } else {
                  createInfo();
                }
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
      appBar: AppBar(
        title: const Text('Info'),
        backgroundColor: const Color(0xFF00A4D4),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showInfoDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchInfoData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak Ada Info Tersedia'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var info = snapshot.data![index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info['judul_info'],
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          info['isi_info'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.post_add,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Diposting: ${formatDate(info['tgl_post_info'])}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showInfoDialog(id: info['kd_info'], isEdit: true);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text('Apakah Anda yakin ingin menghapus info ini?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Batal'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Hapus'),
                                          onPressed: () {
                                            deleteInfo(info['kd_info']);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}