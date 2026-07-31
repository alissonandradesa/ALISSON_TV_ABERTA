import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/milestone_model.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  List<MilestoneModel> _milestones = [];

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  // Carrega os marcos salvos ou inicializa a lista padrão
  Future<void> _loadMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? milestonesString = prefs.getString('saved_milestones');

    if (milestonesString != null) {
      final List decodedList = jsonDecode(milestonesString);
      setState(() {
        _milestones = decodedList.map((item) => MilestoneModel.fromJson(item)).toList();
      });
    } else {
      setState(() {
        _milestones = [
          MilestoneModel(
            ageGroup: '2 meses',
            category: 'Motor',
            description: 'Sustenta brevemente a cabeça quando colocado de bruços.',
          ),
          MilestoneModel(
            ageGroup: '2 meses',
            category: 'Social/Emocional',
            description: 'Reage à voz humana e sorri quando alguém fala com ele.',
          ),
          MilestoneModel(
            ageGroup: '2 meses',
            category: 'Linguagem',
            description: 'Emite sons vogais (como "gugu" ou balbúcios leves).',
          ),
          MilestoneModel(
            ageGroup: '4 meses',
            category: 'Motor',
            description: 'Rola da barriga para o lado e consegue firmar a cabeça ao ser puxado para sentar.',
          ),
          MilestoneModel(
            ageGroup: '4 meses',
            category: 'Cognitivo',
            description: 'Leva as mãos aos brinquedos e tenta agarrá-los.',
          ),
          MilestoneModel(
            ageGroup: '4 meses',
            category: 'Social/Emocional',
            description: 'Ri alto e demonstra alegria ao ver pessoas familiares.',
          ),
          MilestoneModel(
            ageGroup: '6 meses',
            category: 'Motor',
            description: 'Senta-se com apoio das mãos e, em breve, sem apoio por alguns instantes.',
          ),
          MilestoneModel(
            ageGroup: '6 meses',
            category: 'Cognitivo',
            description: 'Passa objetos de uma mão para a outra e leva tudo à boca para explorar.',
          ),
          MilestoneModel(
            ageGroup: '6 meses',
            category: 'Linguagem',
            description: 'Emite sílabas consoantes repetidas (ex: "ba-ba", "da-da").',
          ),
          MilestoneModel(
            ageGroup: '9 meses',
            category: 'Motor',
            description: 'Fica em pé com apoio e começa a engatinhar ou arrastar-se.',
          ),
          MilestoneModel(
            ageGroup: '9 meses',
            category: 'Social/Emocional',
            description: 'Estranha pessoas desconhecidas (ansiedade de separação) e responde ao próprio nome.',
          ),
          MilestoneModel(
            ageGroup: '9 meses',
            category: 'Linguagem',
            description: 'Imita sons e entonações de conversas dos adultos.',
          ),
          MilestoneModel(
            ageGroup: '12 meses',
            category: 'Motor',
            description: 'Dá primeiros passos com apoio (ou sozinho) e fica em pé sem ajuda.',
          ),
          MilestoneModel(
            ageGroup: '12 meses',
            category: 'Linguagem',
            description: 'Fala palavras simples com significado (como "mamãe", "papai", "au-au").',
          ),
          MilestoneModel(
            ageGroup: '12 meses',
            category: 'Cognitivo',
            description: 'Aponta para o que quer e compreende ordens simples e gestuais ("dá tchau").',
          ),
        ];
      });
      _saveMilestones();
    }
  }

  // Salva o estado atual no celular
  Future<void> _saveMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_milestones.map((m) => m.toJson()).toList());
    await prefs.setString('saved_milestones', encodedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcos do Desenvolvimento'),
        backgroundColor: Colors.orange.shade100,
      ),
      body: _milestones.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _milestones.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final milestone = _milestones[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: CheckboxListTile(
                    title: Text(
                      '${milestone.ageGroup} - ${milestone.category}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        milestone.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    value: milestone.isAchieved,
                    onChanged: (bool? value) {
                      setState(() {
                        milestone.isAchieved = value ?? false;
                      });
                      _saveMilestones(); // Salva automaticamente ao alterar
                    },
                    secondary: CircleAvatar(
                      backgroundColor: milestone.isAchieved ? Colors.green : Colors.orangeAccent,
                      child: Icon(
                        milestone.isAchieved ? Icons.check : Icons.child_care,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}