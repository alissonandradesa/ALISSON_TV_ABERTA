import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vaccine_model.dart';
import '../services/notification_service.dart';

class VaccinesScreen extends StatefulWidget {
  const VaccinesScreen({super.key});

  @override
  State<VaccinesScreen> createState() => _VaccinesScreenState();
}

class _VaccinesScreenState extends State<VaccinesScreen> {
  List<VaccineModel> _vaccines = [];

  @override
  void initState() {
    super.initState();
    _loadVaccines();
  }

  // Carrega as vacinas salvas ou inicializa a lista completa oficial do MS
  Future<void> _loadVaccines() async {
    final prefs = await SharedPreferences.getInstance();
    final String? vaccinesString = prefs.getString('saved_vaccines');

    if (vaccinesString != null) {
      final List decodedList = jsonDecode(vaccinesString);
      setState(() {
        _vaccines = decodedList.map((item) => VaccineModel.fromJson(item)).toList();
      });
    } else {
      setState(() {
        _vaccines = [
          // AO NASCER
          VaccineModel(
            title: 'BCG',
            ageRecommendation: 'Ao nascer',
            description: 'Protege contra as formas graves de tuberculose (miliar e meníngea).',
          ),
          VaccineModel(
            title: 'Hepatite B (1ª Dose)',
            ageRecommendation: 'Ao nascer',
            description: 'Protege contra a infecção pelo vírus da hepatite B.',
          ),
          
          // 2 MESES
          VaccineModel(
            title: 'Pentavalente (1ª Dose)',
            ageRecommendation: '2 meses',
            description: 'Protege contra Difteria, Tétano, Coqueluche, Hepatite B e infecções por Hib.',
          ),
          VaccineModel(
            title: 'VIP / Poliomielite (1ª Dose)',
            ageRecommendation: '2 meses',
            description: 'Vacina Inativada Poliomielite (protege contra a paralisia infantil).',
          ),
          VaccineModel(
            title: 'Pneumocócica 10-valente (1ª Dose)',
            ageRecommendation: '2 meses',
            description: 'Protege contra pneumonia, otite, meningite e outras doenças.',
          ),
          VaccineModel(
            title: 'Rotavírus Humano (1ª Dose)',
            ageRecommendation: '2 meses',
            description: 'Protege contra diarreia grave causada por rotavírus.',
          ),

          // 3 MESES
          VaccineModel(
            title: 'Meningocócica C (1ª Dose)',
            ageRecommendation: '3 meses',
            description: 'Protege contra doença meningocócica do grupo C (meningite grave).',
          ),

          // 4 MESES
          VaccineModel(
            title: 'Pentavalente (2ª Dose)',
            ageRecommendation: '4 meses',
            description: 'Segunda dose contra Difteria, Tétano, Coqueluche, Hepatite B e Hib.',
          ),
          VaccineModel(
            title: 'VIP / Poliomielite (2ª Dose)',
            ageRecommendation: '4 meses',
            description: 'Segunda dose injetável contra a poliomielite.',
          ),
          VaccineModel(
            title: 'Pneumocócica 10-valente (2ª Dose)',
            ageRecommendation: '4 meses',
            description: 'Segunda dose contra infecções pneumocócicas.',
          ),
          VaccineModel(
            title: 'Rotavírus Humano (2ª Dose)',
            ageRecommendation: '4 meses',
            description: 'Segunda dose contra diarreia por rotavírus (limite máximo de idade).',
          ),

          // 5 MESES
          VaccineModel(
            title: 'Meningocócica C (2ª Dose)',
            ageRecommendation: '5 meses',
            description: 'Segunda dose contra a meningite C.',
          ),

          // 6 MESES
          VaccineModel(
            title: 'Pentavalente (3ª Dose)',
            ageRecommendation: '6 meses',
            description: 'Terceira dose contra Difteria, Tétano, Coqueluche, Hepatite B e Hib.',
          ),
          VaccineModel(
            title: 'VIP / Poliomielite (3ª Dose)',
            ageRecommendation: '6 meses',
            description: 'Terceira dose contra a poliomielite.',
          ),
          VaccineModel(
            title: 'Influenza (Gripe - 1ª Dose ou Dose Única)',
            ageRecommendation: '6 meses',
            description: 'Protege contra cepas do vírus da gripe (campanha anual).',
          ),

          // 9 MESES
          VaccineModel(
            title: 'Febre Amarela (1ª Dose)',
            ageRecommendation: '9 meses',
            description: 'Protege contra a febre amarela silvestre e urbana.',
          ),

          // 12 MESES (1 ANO)
          VaccineModel(
            title: 'Tríplice Viral (1ª Dose)',
            ageRecommendation: '12 meses',
            description: 'Protege contra Sarampo, Caxumba e Rubéola.',
          ),
          VaccineModel(
            title: 'Pneumocócica 10-valente (Reforço)',
            ageRecommendation: '12 meses',
            description: 'Dose de reforço contra doenças pneumocócicas.',
          ),
          VaccineModel(
            title: 'Meningocócica C (Reforço)',
            ageRecommendation: '12 meses',
            description: 'Dose de reforço contra a meningite C.',
          ),

          // 15 MESES
          VaccineModel(
            title: 'DTP (Reforço - 1ª Dose)',
            ageRecommendation: '15 meses',
            description: 'Tríplice bacteriana (Difteria, Tétano e Coqueluche).',
          ),
          VaccineModel(
            title: 'VOP / Poliomielite (1º Reforço)',
            ageRecommendation: '15 meses',
            description: 'Vacina Oral Poliomielite (gotinha).',
          ),
          VaccineModel(
            title: 'Hepatite A (Dose Única)',
            ageRecommendation: '15 meses',
            description: 'Protege contra a infecção pelo vírus da hepatite A.',
          ),
          VaccineModel(
            title: 'Tetra Viral ou Varicela',
            ageRecommendation: '15 meses',
            description: 'Protege contra Sarampo, Caxumba, Rubéola e Varicela (catapora).',
          ),
        ];
      });
      _saveVaccines();
    }
  }

  // Salva o estado atual das vacinas no celular
  Future<void> _saveVaccines() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_vaccines.map((v) => v.toJson()).toList());
    await prefs.setString('saved_vaccines', encodedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Vacinação'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: _vaccines.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _vaccines.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final vaccine = _vaccines[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: CheckboxListTile(
                    title: Text(
                      vaccine.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Idade recomendada: ${vaccine.ageRecommendation}',
                          style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vaccine.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    value: vaccine.isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        vaccine.isCompleted = value ?? false;
                      });
                      _saveVaccines(); // Salva alteração localmente
                    },
                    secondary: IconButton(
                      icon: const Icon(Icons.notifications_active, color: Colors.blue),
                      onPressed: () {
                        NotificationService().showInstantNotification(
                          id: index,
                          title: 'Lembrete de Vacina: ${vaccine.title}',
                          body: 'Chegou a hora da dose (${vaccine.ageRecommendation})! Não deixe de imunizar seu bebê.',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lembrete configurado para ${vaccine.title}!')),
                        );
                      },
                      tooltip: 'Agendar lembrete',
                    ),
                  ),
                );
              },
            ),
    );
  }
}