import 'package:flutter/material.dart';
import 'hasta_ekle.dart';
import 'doktor_paneli.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hasta ve Randevu Yönetim Sistemi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Hasta ve Randevu Yönetim Sistemi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Çok Biçimlilik (Polymorphism)
              //Aynı fonksiyon farklı sayfalara yönlendirme yapabiliyor
              _buildMenuButton(
                context,
                icon: Icons.person_add,
                label: 'Yeni Hasta Ekle',
                onPressed: () => _navigateTo(context, const HastaEkle()),
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                icon: Icons.medical_services,
                label: 'Doktor Paneli',
                onPressed: () => _navigateTo(context, const DoktorPaneli()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
