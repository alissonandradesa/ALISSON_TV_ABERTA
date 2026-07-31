import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../utils/app_theme.dart';

class OrientationsScreen extends StatefulWidget {
  const OrientationsScreen({super.key});

  @override
  State<OrientationsScreen> createState() => _OrientationsScreenState();
}

class _OrientationsScreenState extends State<OrientationsScreen> {
  String _gender = 'menino';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final gender = await SettingsService().getGender();
    if (mounted) {
      setState(() {
        _gender = gender;
      });
    }
  }

  // Lista rica de orientações divididas por meses e cuidados essenciais
  final List<Map<String, dynamic>> _orientationsData = [
    {
      'periodo': '0 a 1 Mês (Recém-Nascido)',
      'icone': Icons.child_care,
      'resumo': 'Cuidados com o coto umbilical, sono irregular e amamentação em livre demanda.',
      'higiene': '• Limpe o coto umbilical a cada troca de fralda com álcool 70% (conforme orientação do pediatra).\n• Banho rápido com água morna (teste no dorso do seu punho).\n• Troque a fralda frequentemente para evitar assaduras; use pomada de barreira a cada troca se houver vermelhidão.',
      'oQueEsperar': '• O bebê dorme de 16 a 18 horas por dia, acordando para mamar.\n• Reage a sons altos com sobressaltos (Reflexo de Moro).\n• Consegue fixar o breve olhar a cerca de 20-30 cm de distância.',
      'dicaOuro': 'Mantenha o ambiente tranquilo e com pouca luz à noite para ajudar o bebê a diferenciar o dia da noite gradualmente.'
    },
    {
      'periodo': '2 a 3 Meses',
      'icone': Icons.sentiment_very_satisfied,
      'resumo': 'Sorriso social, maior sustentação da cabeça e diminuição das cólicas iniciais.',
      'higiene': '• Hidratação da pele com cremes específicos para bebês após o banho.\n• Higiene das dobrinhas (pescoço e coxas) para evitar assaduras por calor ou umidade do leite.\n• Higienização bucal suave com gaze umedecida em água filtrada.',
      'oQueEsperar': '• Surge o tão esperado "sorriso social" (quando ele sorri ao ver ou ouvir você).\n• Começa a emitir pequenos sons (gorgolejos).\n• Consegue erguer a cabeça por alguns instantes quando colocado de bruços (Tummy Time).',
      'dicaOuro': 'O "Tummy Time" (tempo de bruços supervisionado) é fundamental para fortalecer o pescoço e os ombros. Comece com 2 a 3 minutos, algumas vezes ao dia.'
    },
    {
      'periodo': '4 a 6 Meses',
      'icone': Icons.sports_gymnastics,
      'resumo': 'Descoberta das mãos, virar de bruços para costas e início da introdução alimentar (aos 6 meses).',
      'higiene': '• Atenção redobrada na troca de fraldas: o bebê já mexe bastante e tenta rolar.\n• Cuidado com os primeiros dentinhos (se começarem a nascer) e início da coceira na gengiva.\n• Banho divertido, estimulando a interação com brinquedos flutuantes.',
      'oQueEsperar': '• Rola com facilidade da barriga para o lado e vice-versa.\n• Pega objetos com as duas mãos e os leva à boca.\n• Aos 6 meses, inicia-se a introdução alimentar com frutas e papinhas salgadas amassadas (nunca liquidificadas).',
      'dicaOuro': 'Nunca deixe o bebê sozinho nem por um segundo em cima de camas, sofás ou trocadores, pois nessa fase eles aprendem a rolar de repente!'
    },
    {
      'periodo': '7 a 9 Meses',
      'icone': Icons.weekend,
      'resumo': 'Sentar sem apoio, balbucios ("dadada", "mamama") e estranhar pessoas desconhecidas.',
      'higiene': '• Escovação dos primeiros dentinhos com uma escova de cerdas ultra macias e uma gota de creme dental com flúor (tamanho de um grão de arroz).\n• Higiene rigorosa pós-refeições (limpeza de mãos e rostinho devido aos alimentos sólidos).',
      'oQueEsperar': '• Senta-se firme sem apoio e começa a se arrastar ou engatinhar.\n• Reage ao próprio nome e estranha rostos novos (ansiedade de separação).\n• Transfere objetos de uma mão para a outra.',
      'dicaOuro': 'Inicie o processo de "prova de bebês" (babyproofing) na casa: proteja tomadas, retire objetos cortantes e quinas de móveis da altura dele.'
    },
    {
      'periodo': '10 a 12 Meses',
      'icone': Icons.directions_walk,
      'resumo': 'Primeiros passos com apoio, imitação de gestos e primeiras palavrinhas intencionais.',
      'higiene': '• Incentivar o uso de copinho de transição em vez de mamadeira.\n• Manter unhas sempre aparadas para evitar que ele se arranhe ao tentar se apoiar para levantar.\n• Rotina de sono mais consolidada (geralmente duas sonecas diárias).',
      'oQueEsperar': '• Fica em pé apoiado em móveis e pode dar os primeiros passos segurando nas mãos ou sozinho.\n• Imita tchau, palminhas e sons.\n• Compreende comandos simples como "não" ou "dá aqui".',
      'dicaOuro': 'Comemore cada conquista, mas respeite o ritmo da criança: alguns bebês andam com 11 meses, outros com 14 ou 15 meses, e tudo isso está dentro da normalidade.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.getPrimaryColor(_gender);
    final bgColor = AppTheme.getLightBackgroundColor(_gender);
    final cardBg = AppTheme.getCardBackgroundColor(_gender);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Orientações e Desenvolvimento'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _orientationsData.length,
        itemBuilder: (context, index) {
          final item = _orientationsData[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
            ),
            color: cardBg,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withValues(alpha: 0.2),
                child: Icon(item['icone'], color: primaryColor),
              ),
              title: Text(
                item['periodo'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  item['resumo'],
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
              childrenPadding: const EdgeInsets.all(16.0),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('🚼 Higiene, Fraldas & Cuidados', primaryColor),
                const SizedBox(height: 4),
                Text(item['higiene'], style: const TextStyle(fontSize: 13, height: 1.4)),
                const SizedBox(height: 14),

                _buildSectionTitle('🌟 O Que Esperar (Marcos)', primaryColor),
                const SizedBox(height: 4),
                Text(item['oQueEsperar'], style: const TextStyle(fontSize: 13, height: 1.4)),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dica de Ouro:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.amber.shade900, // Cor corrigida
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['dicaOuro'],
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: color,
      ),
    );
  }
}