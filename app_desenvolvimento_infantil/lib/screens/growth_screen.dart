import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/growth_model.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  List<GrowthRecord> _records = [];

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('saved_growth_records');

    if (dataString != null) {
      final List decoded = jsonDecode(dataString);
      setState(() {
        _records = decoded.map((e) => GrowthRecord.fromJson(e)).toList();
      });
    } else {
      setState(() {
        _records = [
          GrowthRecord(date: '10/01/2026', weight: 3.2, height: 0.49, ageInMonths: 0),
          GrowthRecord(date: '10/02/2026', weight: 4.5, height: 0.54, ageInMonths: 1),
        ];
      });
      _saveRecords();
    }
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_records.map((e) => e.toJson()).toList());
    await prefs.setString('saved_growth_records', encoded);
  }

  void _deleteRecord(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir medição'),
        content: const Text('Deseja realmente apagar este registro de crescimento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _records.removeAt(index);
              });
              _saveRecords();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registro apagado com sucesso!')),
              );
            },
            child: const Text('Apagar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addNewRecordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Medição'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Peso (kg) ex: 6.5'),
                ),
                TextField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Altura em metros ex: 0.62'),
                ),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Idade em meses ex: 3'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0;
                final height = double.tryParse(_heightController.text.replaceAll(',', '.')) ?? 0;
                final age = int.tryParse(_ageController.text) ?? 0;

                if (weight > 0 && height > 0) {
                  final now = DateTime.now();
                  final dateStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                  
                  setState(() {
                    _records.add(GrowthRecord(
                      date: dateStr,
                      weight: weight,
                      height: height,
                      ageInMonths: age,
                    ));
                  });
                  _saveRecords();
                  _weightController.clear();
                  _heightController.clear();
                  _ageController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crescimento e IMC (OMS)'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              color: Colors.green.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.show_chart, size: 40, color: Colors.green),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Acompanhamento Antropométrico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('O IMC infantil é adaptado para os primeiros meses de vida. Toque na lixeira para apagar registros.', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _records.isEmpty
                  ? const Center(child: Text('Nenhum registro encontrado.'))
                  : ListView.builder(
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        final isAdequate = record.imcClassification.contains('adequado');
                        
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isAdequate ? Colors.green.shade200 : Colors.orange.shade200,
                              child: Text('${record.ageInMonths}m', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            title: Text('Peso: ${record.weight} kg  |  Altura: ${record.height} m', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Data: ${record.date}'),
                                Text('IMC: ${record.imc.toStringAsFixed(1)} - ${record.imcClassification}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isAdequate ? Colors.green.shade800 : Colors.orange.shade800,
                                    )),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteRecord(index),
                              tooltip: 'Apagar registro',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRecordDialog,
        backgroundColor: Colors.green,
        tooltip: 'Adicionar Medição',
        child: const Icon(Icons.add, color: Colors.white), // Movido para o final
      ),
    );
  }
}