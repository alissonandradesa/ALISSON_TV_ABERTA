import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/baby_model.dart';
import '../services/settings_service.dart';
import '../utils/app_theme.dart';

class BabyProfileScreen extends StatefulWidget {
  const BabyProfileScreen({super.key});

  @override
  State<BabyProfileScreen> createState() => _BabyProfileScreenState();
}

class _BabyProfileScreenState extends State<BabyProfileScreen> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedGender = 'menino';
  String? _photoPath; // Armazena o caminho do arquivo local da foto

  @override
  void initState() {
    super.initState();
    _loadBabyData();
  }

  Future<void> _loadBabyData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? babyString = prefs.getString('saved_baby_profile');

    if (babyString != null) {
      final Map<String, dynamic> decoded = jsonDecode(babyString);
      final baby = BabyModel.fromJson(decoded);
      setState(() {
        _nameController.text = baby.name;
        _dateController.text = baby.birthDateString;
        _selectedGender = baby.gender.toLowerCase() == 'menina' ? 'menina' : 'menino';
        _photoPath = decoded['photoPath'] ?? decoded['imagePath'];
      });
    } else {
      setState(() {
        _nameController.text = 'João Miguel';
        _dateController.text = '10/01/2026';
        _selectedGender = 'menino';
      });
    }
  }

  // Função para abrir a galeria e selecionar a foto do dispositivo
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  Future<void> _saveBabyData() async {
    final baby = BabyModel(
      name: _nameController.text.isEmpty ? 'Meu Bebê' : _nameController.text,
      birthDateString: _dateController.text.isEmpty ? '01/01/2026' : _dateController.text,
      gender: _selectedGender,
    );

    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> babyMap = baby.toJson();
    if (_photoPath != null) {
      babyMap['photoPath'] = _photoPath;
    }
    
    await prefs.setString('saved_baby_profile', jsonEncode(babyMap));
    await SettingsService().setGender(_selectedGender);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil do bebê salvo com sucesso!')),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.getPrimaryColor(_selectedGender);
    final isGirl = _selectedGender == 'menina';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Bebê'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withValues(alpha: 0.2),
                    backgroundImage: _photoPath != null && _photoPath!.isNotEmpty
                        ? (kIsWeb
                            ? NetworkImage(_photoPath!) as ImageProvider
                            : FileImage(File(_photoPath!)))
                        : null,
                    child: _photoPath == null || _photoPath!.isEmpty
                        ? Icon(
                            isGirl ? Icons.girl : Icons.boy,
                            size: 60,
                            color: primaryColor,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library, color: primaryColor),
                label: Text(
                  'Escolher foto da galeria',
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Bebê',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento (DD/MM/AAAA)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Sexo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
              ),
              items: const [
                DropdownMenuItem(value: 'menino', child: Text('Menino')),
                DropdownMenuItem(value: 'menina', child: Text('Menina')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGender = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saveBabyData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Salvar Perfil',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}