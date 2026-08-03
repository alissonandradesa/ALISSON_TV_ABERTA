import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const TvAbertaApp());
}

class TvAbertaApp extends StatelessWidget {
  const TvAbertaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alisson TV Aberta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class Channel {
  final String name;
  final String category;
  final String url;

  Channel({required this.name, required this.category, required this.url});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Player _player;
  late final VideoController _controller;

  // Lista selecionada com os melhores canais extraídos da sua lista
  final List<Channel> channels = [
    Channel(
      name: 'TV Sergipe (Globo HD)', 
      category: 'Local / Globo', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/3768.m3u8',
    ),
    Channel(
      name: 'Globo SP HD', 
      category: 'Rede Globo', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/1701.m3u8',
    ),
    Channel(
      name: 'Globo News HD', 
      category: 'Notícias', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/1460.m3u8',
    ),
    Channel(
      name: 'Fox Sports 2 HD', 
      category: 'Esportes', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/13673.m3u8',
    ),
    Channel(
      name: 'FX HD', 
      category: 'Filmes e Séries', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/7083.m3u8',
    ),
    Channel(
      name: 'Galinha Pintadinha 24hs', 
      category: 'Infantil', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/13503.m3u8',
    ),
    Channel(
      name: 'Futura HD', 
      category: 'Educação', 
      url: 'http://udq.me:80/live/7SyrYN0fMy/3772288787/13193.m3u8',
    ),
    Channel(
      name: 'TV Aperipê', 
      category: 'Educativa', 
      url: 'http://cdn-br-002938543.comets.com.br/tvaperipe/aovivo/chunklist_w1894049196.m3u8',
    ),
    Channel(
      name: 'TV Brasil', 
      category: 'Pública', 
      url: 'http://tvbrasil.live.bcast.tensai.com.br/hls/tvbrasil/tvbrasil.m3u8',
    ),
    Channel(
      name: 'TV Senado', 
      category: 'Legislativa', 
      url: 'https://video01.senado.leg.br/live/smil:tvsenado.smil/playlist.m3u8',
    ),
    Channel(
      name: 'TV Justiça', 
      category: 'Pública', 
      url: 'https://stream.live.tvjustica.jus.br/tvjustica/tvjustica.m3u8',
    ),
    Channel(
      name: 'Canção Nova', 
      category: 'Religiosa', 
      url: 'http://186.219.52.187:80/cancao_nova/index.m3u8',
    ),
    Channel(
      name: 'TV Cultura', 
      category: 'Educação', 
      url: 'http://186.219.52.187:80/cultura/index.m3u8',
    ),
    Channel(
      name: 'Rede Família', 
      category: 'Variedades', 
      url: 'http://srv9.zoeweb.tv:1935/zw901/smil:zw901.smil/playlist.m3u8',
    ),
  ];

  Channel? currentChannel;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    
    if (channels.isNotEmpty) {
      _changeChannel(channels[0]);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _changeChannel(Channel channel) {
    setState(() {
      currentChannel = channel;
    });
    _player.open(Media(channel.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // PAINEL LATERAL DE CANAIS
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Alisson TV',
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: channels.length,
                      itemBuilder: (context, index) {
                        final channel = channels[index];
                        final isSelected = currentChannel?.name == channel.name;

                        return Focus(
                          child: Builder(
                            builder: (context) {
                              final hasFocus = Focus.of(context).hasFocus;
                              return InkWell(
                                autofocus: index == 0,
                                onTap: () => _changeChannel(channel),
                                child: Container(
                                  color: hasFocus 
                                      ? Colors.blue.withValues(alpha: 0.8) 
                                      : (isSelected ? Colors.white12 : Colors.transparent),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.tv, color: Colors.white, size: 20),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              channel.name,
                                              style: const TextStyle(fontSize: 16, color: Colors.white),
                                            ),
                                            Text(
                                              channel.category,
                                              style: const TextStyle(fontSize: 12, color: Colors.white54),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // PLAYER DE VÍDEO PRINCIPAL
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: Center(
                child: currentChannel != null
                    ? Video(controller: _controller)
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}