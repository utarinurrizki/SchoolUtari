import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final String apiUrl = 'https://praktikum-cpanel-unbin.com/kelompok_rio/api.php?endpoint=agenda';

  TextEditingController judulController = TextEditingController();
  TextEditingController isiController = TextEditingController();
  TextEditingController tglAgendaController = TextEditingController();
  TextEditingController tglPostController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController petugasController = TextEditingController();

  Future<List<dynamic>> fetchAgendaData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal memuat data agenda');
    }
  }

  Future<void> createAgenda() async {
    if (!validateInputs()) return;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'judul_agenda': judulController.text,
        'isi_agenda': isiController.text,
        'tgl_agenda': tglAgendaController.text,
        'tgl_post_agenda': tglPostController.text,
        'status_agenda': statusController.text,
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

  Future<void> updateAgenda(String id) async {
    if (!validateInputs()) return;

    final response = await http.put(
      Uri.parse('$apiUrl&kd_agenda=$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'kd_agenda': id,
        'judul_agenda': judulController.text,
        'isi_agenda': isiController.text,
        'tgl_agenda': tglAgendaController.text,
        'tgl_post_agenda': tglPostController.text,
        'status_agenda': statusController.text,
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

  Future<void> deleteAgenda(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl&kd_agenda=$id'),
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
        tglAgendaController.text.isEmpty ||
        tglPostController.text.isEmpty ||
        statusController.text.isEmpty ||
        petugasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua kolom.')),
      );
      return false;
    }

    try {
      DateTime.parse(tglAgendaController.text);
      DateTime.parse(tglPostController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Format tanggal tidak valid. Gunakan YYYY-MM-DD.')),
      );
      return false;
    }

    return true;
  }

  void showAgendaDialog({String? id, bool isEdit = false}) async {
    if (isEdit) {
      final response = await http.get(Uri.parse('$apiUrl&kd_agenda=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          judulController.text = data['judul_agenda'];
          isiController.text = data['isi_agenda'];
          tglAgendaController.text = data['tgl_agenda'];
          tglPostController.text = data['tgl_post_agenda'];
          statusController.text = data['status_agenda'];
          petugasController.text = data['kd_petugas'];
        });
      } else {
        throw Exception('Gagal memuat data agenda untuk pembaruan');
      }
    } else {
      judulController.clear();
      isiController.clear();
      tglAgendaController.clear();
      tglPostController.clear();
      statusController.clear();
      petugasController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Perbarui Agenda' : 'Tambah Agenda Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(labelText: 'Judul Agenda'),
                ),
                TextField(
                  controller: isiController,
                  decoration: InputDecoration(labelText: 'Isi Agenda'),
                ),
                TextField(
                  controller: tglAgendaController,
                  decoration: InputDecoration(labelText: 'Tanggal Agenda (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: tglPostController,
                  decoration: InputDecoration(labelText: 'Tanggal Posting (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Status Agenda'),
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
                  updateAgenda(id!);
                } else {
                  createAgenda();
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
        title: const Text('Agenda'),
        backgroundColor: const Color(0xFF00A4D4),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAgendaDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchAgendaData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak Ada Agenda Tersedia'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var agenda = snapshot.data![index];

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
                          agenda['judul_agenda'],
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          agenda['isi_agenda'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tanggal Agenda: ${formatDate(agenda['tgl_agenda'])}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Diposting: ${formatDate(agenda['tgl_post_agenda'])}',
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
                                showAgendaDialog(id: agenda['kd_agenda'], isEdit: true);
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
                                      content: Text('Apakah Anda yakin ingin menghapus agenda ini?'),
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
                                            deleteAgenda(agenda['kd_agenda']);
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