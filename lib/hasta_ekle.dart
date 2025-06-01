import 'package:flutter/material.dart';
import 'database_helper.dart';

class HastaEkle extends StatefulWidget {
  const HastaEkle({Key? key}) : super(key: key);

  @override
  _HastaEkleState createState() => _HastaEkleState();
}

// Kalıtım (Inheritance)
class _HastaEkleState extends State<HastaEkle> {
  // StatelessWidget'tan kalıtım
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _sikayetController = TextEditingController();
  String? _selectedKlinik;
  String? _selectedDoktor;

  final List<String> _klinikler = [
    'Dahiliye',
    'Kardiyoloji',
    'Nöroloji',
    'Ortopedi',
    'Göz Hastalıkları',
  ];

  final List<String> _doktorlar = [
    'Dr. Ahmet Yılmaz',
    'Dr. Ayşe Demir',
    'Dr. Mehmet Kaya',
    'Dr. Fatma Şahin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Hasta Kayıt Formu'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _hastaKaydet),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _adController,
                  label: 'Hasta Adı',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen hasta adını giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _soyadController,
                  label: 'Hasta Soyadı',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen hasta soyadını giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _sikayetController,
                  label: 'Şikayet',
                  icon: Icons.medical_services,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şikayeti giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownFormField(
                  value: _selectedKlinik,
                  label: 'Klinik Seçiniz',
                  items: _klinikler,
                  onChanged: (value) {
                    setState(() {
                      _selectedKlinik = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Lütfen klinik seçiniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownFormField(
                  value: _selectedDoktor,
                  label: 'Doktor Seçiniz',
                  items: _doktorlar,
                  onChanged: (value) {
                    setState(() {
                      _selectedDoktor = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Lütfen doktor seçiniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _hastaKaydet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Randevuyu Kaydet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdownFormField({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).primaryColor,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Future<void> _hastaKaydet() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dbHelper = DatabaseHelper();
        await dbHelper.hastaEkle({
          'name': _adController.text,
          'surname': _soyadController.text,
          'complaint': _sikayetController.text,
          'clinic': _selectedKlinik!,
          'doctor': _selectedDoktor!,
          'isConfirmed': 0,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Randevu başarıyla kaydedildi!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _sikayetController.dispose();
    super.dispose();
  }
}
