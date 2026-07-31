import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_service.dart';
import '../utils/app_theme.dart';
import 'vaccines_screen.dart';
import 'growth_screen.dart';
import 'milestones_screen.dart';
import 'orientations_screen.dart';
import 'baby_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _gender = 'menino';
  String? _babyPhotoPath;
  String _babyName = '';

  @override
  void initState() {
    super.initState();
    _loadSettingsAndProfile();
  }

  // Atualiza o tema, o nome e a foto toda vez que voltar para a tela principal
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSettingsAndProfile();
  }

  Future<void> _loadSettingsAndProfile() async {
    final gender = await SettingsService().getGender();
    
    // Busca os dados do perfil salvos
    final prefs = await SharedPreferences.getInstance();
    final String? localBabyString = prefs.getString('saved_baby_profile');
    
    String? photoPath;
    String name = '';
    if (localBabyString != null) {
      final Map<String, dynamic> decoded = jsonDecode(localBabyString);
      photoPath = decoded['photoPath'] ?? decoded['imagePath'];
      name = decoded['name'] ?? '';
    }

    if (mounted) {
      setState(() {
        _gender = gender;
        _babyPhotoPath = photoPath;
        _babyName = name;
      });
    }
  }

  void _openBabyProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BabyProfileScreen()),
    );
    // Recarrega os dados ao retornar
    _loadSettingsAndProfile();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.getPrimaryColor(_gender);
    final bgColor = AppTheme.getLightBackgroundColor(_gender);
    final cardBg = AppTheme.getCardBackgroundColor(_gender);

    // Define o texto do título dinamicamente com o nome da criança se houver
    final titleText = _babyName.isNotEmpty
        ? 'Desenvolvimento de $_babyName'
        : (_gender == 'menino' ? 'Desenvolvimento do Príncipe 💙' : 'Desenvolvimento da Princesa 💖');

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botão no topo com a foto do bebê (ou ícone padrão se não houver foto)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: _openBabyProfile,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: _babyPhotoPath != null && _babyPhotoPath!.isNotEmpty
                    ? (kIsWeb 
                        ? NetworkImage(_babyPhotoPath!) as ImageProvider
                        : FileImage(File(_babyPhotoPath!)))
                    : null,
                child: _babyPhotoPath == null || _babyPhotoPath!.isEmpty
                    ? Icon(
                        _gender == 'menino' ? Icons.boy : Icons.girl,
                        color: primaryColor,
                        size: 24,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Moderno de Boas-Vindas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor.withValues(alpha: 0.2),
                    child: Icon(
                      _gender == 'menino' ? Icons.child_care : Icons.face_3,
                      color: primaryColor,
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Acompanhamento Infantil',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Toque na foto do perfil no canto superior para gerenciar os dados e a foto da criança.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Menu Principal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            
            // Grid de Atalhos Modernos
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildModernCard(
                    context,
                    title: 'Vacinas',
                    icon: Icons.vaccines,
                    color: primaryColor,
                    bgColor: cardBg,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VaccinesScreen()),
                      );
                    },
                  ),
                  _buildModernCard(
                    context,
                    title: 'Crescimento & IMC',
                    icon: Icons.show_chart,
                    color: primaryColor,
                    bgColor: cardBg,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GrowthScreen()),
                      );
                    },
                  ),
                  _buildModernCard(
                    context,
                    title: 'Marcos do Desenvolvimento',
                    icon: Icons.star,
                    color: primaryColor,
                    bgColor: cardBg,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MilestonesScreen()),
                      );
                    },
                  ),
                  _buildModernCard(
                    context,
                    title: 'Orientações',
                    icon: Icons.menu_book,
                    color: primaryColor,
                    bgColor: cardBg,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrientationsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, {required String title, required IconData icon, required Color color, required Color bgColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}