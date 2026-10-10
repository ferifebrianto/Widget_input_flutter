import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';

class FormMahasiswaPage extends StatefulWidget {
  final Mahasiswa? mahasiswa;
  final Set<String> nimTerpakai;

  const FormMahasiswaPage({
    super.key,
    this.mahasiswa,
    required this.nimTerpakai,
  });

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late final TextEditingController _nim;
  late final TextEditingController _nama;
  late final TextEditingController _namaPanggilan;
  late final TextEditingController _email;
  late final TextEditingController _noHp;
  late final TextEditingController _password;
  late final TextEditingController _tempatLahir;
  late final TextEditingController _prodi;
  late final TextEditingController _alamat;

  // State Variables untuk Widget Tambahan
  String _jenisKelamin = 'Laki-laki';
  DateTime? _tanggalLahir;
  String? _agama;
  int _semester = 1;
  String _kelas = 'A';
  String _statusMahasiswa = 'Aktif';
  double _ipk = 3.50;
  bool _penerimaBeasiswa = false;
  bool _bersediaMagang = false;
  final Set<String> _minat = {};
  String? _provinsi;
  String? _kota;
  Color _warnaProfil = Colors.indigo;
  bool _persetujuanData = false;

  // Opsi Pilihan
  final List<String> _opsiAgama = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  final List<String> _opsiProdi = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Manajemen',
    'Teknik Rekayasa Multimedia',
  ];
  final List<String> _opsiMinat = ['Mobile', 'Web', 'AI', 'UI/UX', 'Data'];
  final List<String> _opsiProvinsi = [
    'Jawa Barat',
    'Jawa Tengah',
    'Jawa Timur',
    'DKI Jakarta',
  ];
  final List<String> _opsiKota = ['Bogor', 'Depok', 'Bandung', 'Jakarta'];
  final List<Color> _opsiWarna = [
    Colors.indigo,
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    _nim = TextEditingController(text: widget.mahasiswa?.nim);
    _nama = TextEditingController(text: widget.mahasiswa?.nama);
    _namaPanggilan = TextEditingController();
    _email = TextEditingController();
    _noHp = TextEditingController();
    _password = TextEditingController();
    _tempatLahir = TextEditingController();
    _prodi = TextEditingController(text: widget.mahasiswa?.prodi);
    _alamat = TextEditingController();
  }

  @override
  void dispose() {
    _nim.dispose();
    _nama.dispose();
    _namaPanggilan.dispose();
    _email.dispose();
    _noHp.dispose();
    _password.dispose();
    _tempatLahir.dispose();
    _prodi.dispose();
    _alamat.dispose();
    super.dispose();
  }

  String? _wajib(String? value, String label) {
    return value == null || value.trim().isEmpty
        ? '$label tidak boleh kosong'
        : null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    if (!_persetujuanData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui persetujuan data'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      Mahasiswa(
        nim: _nim.text.trim(),
        nama: _nama.text.trim(),
        prodi: _prodi.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mahasiswa == null ? 'Tambah Mahasiswa' : 'Edit Mahasiswa',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // 1. CircleAvatar (Foto Profil)
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: _warnaProfil.withOpacity(0.2),
                        child: Icon(Icons.person, size: 48, color: _warnaProfil),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Pilih Foto Profil'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. NIM
                TextFormField(
                  controller: _nim,
                  decoration: const InputDecoration(labelText: 'NIM'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final error = _wajib(value, 'NIM');
                    if (error != null) return error;
                    if (widget.nimTerpakai.contains(
                      value!.trim().toLowerCase(),
                    )) {
                      return 'NIM sudah digunakan';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Nama Lengkap
                TextFormField(
                  controller: _nama,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _wajib(value, 'Nama'),
                ),
                const SizedBox(height: 16),

                // 4. Nama Panggilan
                TextFormField(
                  controller: _namaPanggilan,
                  decoration: const InputDecoration(labelText: 'Nama Panggilan'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // 5. Email
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // 6. No. HP
                TextFormField(
                  controller: _noHp,
                  decoration: const InputDecoration(labelText: 'No. HP'),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // 7. Password Portal
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Password Portal'),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                // 8. Jenis Kelamin (RadioListTile)
                Text(
                  'Jenis Kelamin',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                RadioListTile<String>(
                  title: const Text('Laki-laki'),
                  value: 'Laki-laki',
                  groupValue: _jenisKelamin,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _jenisKelamin = val!),
                ),
                RadioListTile<String>(
                  title: const Text('Perempuan'),
                  value: 'Perempuan',
                  groupValue: _jenisKelamin,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _jenisKelamin = val!),
                ),
                const SizedBox(height: 12),

                // 9. Tanggal Lahir (showDatePicker)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tanggal Lahir'),
                  subtitle: Text(
                    _tanggalLahir == null
                        ? 'Belum dipilih'
                        : '${_tanggalLahir!.day}/${_tanggalLahir!.month}/${_tanggalLahir!.year}',
                  ),
                  trailing: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2002),
                        firstDate: DateTime(1980),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _tanggalLahir = picked);
                    },
                    child: const Text('Pilih'),
                  ),
                ),
                const SizedBox(height: 16),

                // 10. Tempat Lahir
                TextFormField(
                  controller: _tempatLahir,
                  decoration: const InputDecoration(labelText: 'Tempat Lahir'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // 11. Agama (DropdownButtonFormField)
                DropdownButtonFormField<String>(
                  value: _agama,
                  decoration: const InputDecoration(labelText: 'Agama'),
                  items: _opsiAgama
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _agama = val),
                ),
                const SizedBox(height: 16),

                // 12. Program Studi (DropdownButtonFormField)
                DropdownButtonFormField<String>(
                  value: _opsiProdi.contains(_prodi.text) ? _prodi.text : null,
                  decoration: const InputDecoration(labelText: 'Program Studi'),
                  items: _opsiProdi
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _prodi.text = val);
                  },
                  validator: (value) => _wajib(value, 'Program studi'),
                ),
                const SizedBox(height: 16),

                // 13. Semester (DropdownButtonFormField<int>)
                DropdownButtonFormField<int>(
                  value: _semester,
                  decoration: const InputDecoration(labelText: 'Semester'),
                  items: List.generate(8, (i) => i + 1)
                      .map((i) => DropdownMenuItem(
                            value: i,
                            child: Text('Semester $i'),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _semester = val!),
                ),
                const SizedBox(height: 20),

                // 14. Kelas (SegmentedButton)
                Text(
                  'Kelas',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'A', label: Text('Kelas A')),
                    ButtonSegment(value: 'B', label: Text('Kelas B')),
                    ButtonSegment(value: 'C', label: Text('Kelas C')),
                  ],
                  selected: {_kelas},
                  onSelectionChanged: (val) => setState(() => _kelas = val.first),
                ),
                const SizedBox(height: 20),

                // 15. Status Mahasiswa (ChoiceChip)
                Text(
                  'Status Mahasiswa',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Aktif', 'Cuti', 'Lulus'].map((status) {
                    return ChoiceChip(
                      label: Text(status),
                      selected: _statusMahasiswa == status,
                      onSelected: (selected) {
                        if (selected) setState(() => _statusMahasiswa = status);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 16. IPK (Slider)
                Text(
                  'IPK: ${_ipk.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Slider(
                  value: _ipk,
                  min: 0.0,
                  max: 4.0,
                  divisions: 40,
                  label: _ipk.toStringAsFixed(2),
                  onChanged: (val) => setState(() => _ipk = val),
                ),

                // 17. Penerima Beasiswa (SwitchListTile)
                SwitchListTile(
                  title: const Text('Penerima Beasiswa'),
                  contentPadding: EdgeInsets.zero,
                  value: _penerimaBeasiswa,
                  onChanged: (val) => setState(() => _penerimaBeasiswa = val),
                ),

                // 18. Bersedia Magang (CheckboxListTile)
                CheckboxListTile(
                  title: const Text('Bersedia Magang'),
                  contentPadding: EdgeInsets.zero,
                  value: _bersediaMagang,
                  onChanged: (val) => setState(() => _bersediaMagang = val ?? false),
                ),
                const SizedBox(height: 12),

                // 19. Minat (FilterChip)
                Text(
                  'Minat / Keahlian',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _opsiMinat.map((minat) {
                    final selected = _minat.contains(minat);
                    return FilterChip(
                      label: Text(minat),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _minat.add(minat);
                          } else {
                            _minat.remove(minat);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 20. Alamat Lengkap (multiline TextFormField)
                TextFormField(
                  controller: _alamat,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Lengkap',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // 21. Provinsi & Kota
                DropdownButtonFormField<String>(
                  value: _provinsi,
                  decoration: const InputDecoration(labelText: 'Provinsi'),
                  items: _opsiProvinsi
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _provinsi = val),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _kota,
                  decoration: const InputDecoration(labelText: 'Kota/Kabupaten'),
                  items: _opsiKota
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _kota = val),
                ),
                const SizedBox(height: 20),

                // 22. Dokumen / KTM
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Pilih File Dokumen / KTM'),
                ),
                const SizedBox(height: 20),

                // 23. Warna Profil (Custom Wrap + Container)
                Text(
                  'Warna Tema Profil',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: _opsiWarna.map((color) {
                    final isSelected = _warnaProfil == color;
                    return GestureDetector(
                      onTap: () => setState(() => _warnaProfil = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 24. Persetujuan Data (Checkbox)
                Row(
                  children: [
                    Checkbox(
                      value: _persetujuanData,
                      onChanged: (val) =>
                          setState(() => _persetujuanData = val ?? false),
                    ),
                    const Expanded(
                      child: Text('Saya menyatakan data yang diisi adalah benar.'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tombol Simpan bawaan awal Anda
                FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}