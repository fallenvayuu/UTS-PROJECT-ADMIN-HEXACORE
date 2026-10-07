import 'package:flutter/material.dart';

void main() => runApp(const HexacoreApp());

// ---------- Model & dummy data ----------
class Part {
  final String tanggal, nama, kategori, supplier;
  final int jumlah, harga;
  Part(this.tanggal, this.nama, this.kategori, this.jumlah, this.supplier, this.harga);
}

final List<Part> daftarPart = [
  Part('2025-10-01', 'LCD Samsung A12', 'LCD', 10, 'PT Mitra Seluler', 185000),
  Part('2025-10-02', 'Baterai iPhone 11', 'Baterai', 4, 'CV Apel Jaya', 210000),
  Part('2025-10-03', 'Flexible Charger Redmi Note 10', 'Konektor', 25, 'PT Mitra Seluler', 28000),
  Part('2025-10-04', 'Kamera Belakang Oppo A5s', 'Kamera', 3, 'Sinar Part', 65000),
  Part('2025-10-05', 'LCD Vivo Y12', 'LCD', 8, 'Sinar Part', 170000),
];
const kategoriList = ['LCD', 'Baterai', 'Konektor', 'Kamera', 'Speaker', 'Casing', 'Lainnya'];

class HexacoreApp extends StatelessWidget {
  const HexacoreApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Hexacore Sparepart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: const Color(0xFF0F766E), useMaterial3: true),
        home: const LoginPage(),
      );
}

// ---------- Login (simulasi) ----------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _key,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.hexagon_outlined, size: 64),
                const SizedBox(height: 8),
                const Text('Hexacore Sparepart', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Masuk sebagai staf gudang'),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _user,
                  decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Username wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.length < 6) ? 'Password minimal 6 karakter' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                      }
                    },
                    child: const Text('Masuk'),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
}

// ---------- Home dengan 3 tab: Beranda, Input, Riwayat ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  void _simpan(Part p) {
    setState(() {
      daftarPart.insert(0, p);
      _tab = 2;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Barang masuk disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [const _Beranda(), _InputForm(onSave: _simpan), const _Riwayat()];
    final judul = ['Beranda', 'Input barang masuk', 'Riwayat barang masuk'];
    return Scaffold(
      appBar: AppBar(
        title: Text(judul[_tab]),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
          ),
        ],
      ),
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), label: 'Input'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Riwayat'),
        ],
      ),
    );
  }
}

Widget _partTile(Part p) => ListTile(
      leading: CircleAvatar(child: Text(p.kategori[0])),
      title: Text(p.nama),
      subtitle: Text('${p.tanggal} • ${p.supplier}'),
      trailing: Text('${p.jumlah} unit', style: TextStyle(fontWeight: FontWeight.bold, color: p.jumlah < 5 ? Colors.orange.shade800 : null)),
    );

class _Beranda extends StatelessWidget {
  const _Beranda();
  @override
  Widget build(BuildContext context) {
    final total = daftarPart.fold<int>(0, (s, p) => s + p.jumlah);
    final menipis = daftarPart.where((p) => p.jumlah < 5).length;
    Widget kartu(String l, String v) => Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        );
    return ListView(padding: const EdgeInsets.all(12), children: [
      Row(children: [kartu('Jenis part', '${daftarPart.length}'), kartu('Total unit', '$total'), kartu('Menipis', '$menipis')]),
      const Padding(padding: EdgeInsets.fromLTRB(4, 16, 4, 4), child: Text('Baru datang', style: TextStyle(fontWeight: FontWeight.bold))),
      ...daftarPart.take(5).map(_partTile),
    ]);
  }
}

class _Riwayat extends StatelessWidget {
  const _Riwayat();
  @override
  Widget build(BuildContext context) => daftarPart.isEmpty
      ? const Center(child: Text('Belum ada data. Buka tab Input untuk menambah.'))
      : ListView(children: daftarPart.map(_partTile).toList());
}

class _InputForm extends StatefulWidget {
  final void Function(Part) onSave;
  const _InputForm({required this.onSave});
  @override
  State<_InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  final _key = GlobalKey<FormState>();
  final _nama = TextEditingController(), _jumlah = TextEditingController();
  final _supplier = TextEditingController(), _harga = TextEditingController();
  String _kategori = kategoriList.first;

  String? _wajib(String? v, String label) => (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  @override
  Widget build(BuildContext context) => Form(
        key: _key,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(controller: _nama, decoration: const InputDecoration(labelText: 'Nama part', border: OutlineInputBorder()), validator: (v) => _wajib(v, 'Nama part')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _kategori,
            decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
            items: kategoriList.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (v) => setState(() => _kategori = v!),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _jumlah,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Jumlah', border: OutlineInputBorder()),
            validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : 'Jumlah harus angka lebih dari 0',
          ),
          const SizedBox(height: 12),
          TextFormField(controller: _supplier, decoration: const InputDecoration(labelText: 'Supplier', border: OutlineInputBorder()), validator: (v) => _wajib(v, 'Supplier')),
          const SizedBox(height: 12),
          TextFormField(
            controller: _harga,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Harga beli (Rp)', border: OutlineInputBorder()),
            validator: (v) => (int.tryParse(v ?? '') ?? -1) >= 0 ? null : 'Harga harus angka, tidak boleh negatif',
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (!_key.currentState!.validate()) return;
              final n = DateTime.now();
              final tgl = '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
              widget.onSave(Part(tgl, _nama.text.trim(), _kategori, int.parse(_jumlah.text), _supplier.text.trim(), int.parse(_harga.text)));
              _nama.clear(); _jumlah.clear(); _supplier.clear(); _harga.clear();
            },
            child: const Text('Simpan barang masuk'),
          ),
        ]),
      );
}
