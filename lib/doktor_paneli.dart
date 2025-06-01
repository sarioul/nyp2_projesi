import 'package:flutter/material.dart';
import 'database_helper.dart';

class DoktorPaneli extends StatefulWidget {
  const DoktorPaneli({Key? key}) : super(key: key);

  @override
  _DoktorPaneliState createState() => _DoktorPaneliState();
}

class _DoktorPaneliState extends State<DoktorPaneli> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _randevular = [];

  @override
  void initState() {
    super.initState();
    _randevulariYukle();
  }

  Future<void> _randevulariYukle() async {
    final randevular = await _dbHelper.hastalariGetir();
    setState(() {
      _randevular = randevular;
    });
  }

  String _durumMetni(int durum) {
    switch (durum) {
      case 1:
        return 'Onaylandı';
      case 2:
        return 'Reddedildi';
      default:
        return 'Onay Bekliyor';
    }
  }

  Color _durumRengi(int durum) {
    switch (durum) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _randevuSil(int id) async {
    await _dbHelper.randevuSil(
      id,
    ); // Bu fonksiyonun DatabaseHelper'da mevcut olduğundan emin olun
    _randevulariYukle();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Randevu silindi'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Doktor Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _randevulariYukle,
          ),
        ],
      ),
      body:
          _randevular.isEmpty
              ? const Center(
                child: Text(
                  'Kayıtlı randevu bulunamadı',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _randevular.length,
                itemBuilder: (context, index) {
                  final randevu = _randevular[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${randevu['name']} ${randevu['surname']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Şikayet: ${randevu['complaint']}'),
                          Text('Klinik: ${randevu['clinic']}'),
                          Text('Doktor: ${randevu['doctor']}'),
                          Text(
                            'Durum: ${_durumMetni(randevu['isConfirmed'])}',
                            style: TextStyle(
                              color: _durumRengi(randevu['isConfirmed']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (randevu['isConfirmed'] == 0) ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Reddet'),
                                  onPressed: () async {
                                    await _dbHelper.reddet(randevu['id']);
                                    _randevulariYukle();
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Onayla'),
                                  onPressed: () async {
                                    await _dbHelper.onayla(randevu['id']);
                                    _randevulariYukle();
                                  },
                                ),
                              ],
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.grey,
                                onPressed: () => _randevuSil(randevu['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
