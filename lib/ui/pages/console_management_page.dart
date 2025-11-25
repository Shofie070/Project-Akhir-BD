import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/models/console_model.dart';

class ConsoleManagementPage extends StatefulWidget {
  const ConsoleManagementPage({super.key});

  @override
  State<ConsoleManagementPage> createState() => _ConsoleManagementPageState();
}

class _ConsoleManagementPageState extends State<ConsoleManagementPage> {
  final ApiService api = ApiService();

  // Data consoles dari API
  List<ConsoleModel> _consoles = [];
  bool _loading = true;

  // Controller untuk Form Input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedType = 'PS5';
  String _selectedStatus = 'Tersedia';

  @override
  void initState() {
    super.initState();
    _loadConsoles();
  }

  Future<void> _loadConsoles() async {
    setState(() => _loading = true);
    try {
      final data = await api.fetchConsoles();
      setState(() => _consoles = data);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load consoles: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  // Helper Reset Form
  void _resetForm() {
    _nameController.clear();
    _priceController.clear();
    _selectedType = 'PS5';
    _selectedStatus = 'Tersedia';
  }

  // 1. Tambah / Simpan Console (create or update)
  Future<void> _saveConsole({String? id}) async {
    if (_nameController.text.isEmpty) return;

    final model = ConsoleModel(
      id: id == null ? 0 : int.tryParse(id) ?? 0,
      jenisConsole: _selectedType,
      nomorUnit: _nameController.text,
      status: _selectedStatus,
      pricePerHour: double.tryParse(_priceController.text),
    );

    try {
      if (id == null) {
        final created = await api.createConsole(model);
        setState(() => _consoles.insert(0, created));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Console Berhasil Ditambahkan'), backgroundColor: Colors.green));
      } else {
        final updated = await api.updateConsole(model);
        final idx = _consoles.indexWhere((c) => c.id == updated.id);
        if (idx != -1) setState(() => _consoles[idx] = updated);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Console Berhasil Diupdate'), backgroundColor: Colors.green));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.redAccent));
    } finally {
      Navigator.pop(context);
      _resetForm();
    }
  }

  // 2. Hapus Console
  void _deleteConsole(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF001530),
        title: const Text('Hapus Console?', style: TextStyle(color: Colors.white)),
        content: const Text('Data yang dihapus tidak bisa dikembalikan.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              try {
                await api.deleteConsole(int.parse(id));
                setState(() => _consoles.removeWhere((c) => c.id.toString() == id));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Console dihapus'), backgroundColor: Colors.redAccent));
              } catch (e) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // Helper Tampilkan Form Dialog
  void _showFormDialog({ConsoleModel? console}) {
    // Jika mode edit, isi form dengan data lama
    if (console != null) {
      _nameController.text = console.nomorUnit;
      _priceController.text = console.pricePerHour?.toStringAsFixed(0) ?? '';
      _selectedType = console.jenisConsole;
      _selectedStatus = console.status;
    } else {
      _resetForm();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder( // StatefulBuilder biar Dropdown bisa update state di dalam dialog
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF001530),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                console == null ? 'Tambah Console Baru' : 'Edit Console',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInput(_nameController, 'Nama Console (ex: PS5-03)', TextInputType.text),
                    const SizedBox(height: 16),
                    _buildInput(_priceController, 'Harga per Jam (Rp)', TextInputType.number),
                    const SizedBox(height: 16),

                    // Dropdown Tipe
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      dropdownColor: const Color(0xFF000E29),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Tipe Console'),
                      items: ['PS3', 'PS4', 'PS5'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (val) => setStateDialog(() => _selectedType = val!),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Status
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      dropdownColor: const Color(0xFF000E29),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Status Awal'),
                      items: ['Tersedia', 'Dipakai', 'Rusak'].map((status) {
                        return DropdownMenuItem(value: status, child: Text(status));
                      }).toList(),
                      onChanged: (val) => setStateDialog(() => _selectedStatus = val!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () => _saveConsole(id: console?.id.toString()),
                  child: Text(console == null ? 'Simpan' : 'Update', style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000E29),
      appBar: AppBar(
        title: const Text('Manage Consoles', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 1.5,
                  colors: [Color(0xFF1A237E), Color(0xFF000000)],
                ),
              ),
            ),
          ),

          // List Console
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _consoles.isEmpty
                  ? const Center(child: Text('Belum ada data console.', style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _consoles.length,
                      itemBuilder: (context, index) {
                        final item = _consoles[index];
                        return _buildConsoleItem(item);
                      },
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Console', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Widget Item List
  Widget _buildConsoleItem(ConsoleModel item) {
    final bool available = item.status.toLowerCase() == 'tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: available ? Colors.blueAccent.withOpacity(0.2) : Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.gamepad,
                    color: available ? Colors.blueAccent : Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.nomorUnit, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${item.jenisConsole} • Rp ${item.pricePerHour?.toStringAsFixed(0) ?? '-'} /jam', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: available ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            color: available ? Colors.green : Colors.redAccent,
                            fontSize: 10, fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                      onPressed: () => _showFormDialog(console: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteConsole(item.id.toString()),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper Input
  Widget _buildInput(TextEditingController ctrl, String label, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    );
  }
}

