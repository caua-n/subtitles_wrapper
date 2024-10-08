import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:subtitle_wrapper/data/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper/subtitle_controller.dart';
import 'package:subtitle_wrapper/subtitle_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VLC Player Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'VLC Player in Stack'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VlcPlayerController _vlcPlayerController;
  late SubtitleController _subtitleController;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _vlcPlayerController = VlcPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    _subtitleController = SubtitleController(
      subtitleUrl:
          'https://opensubtitles.playflix.space/tt0371746_Iron.Man.2008.1080p.BluRay.DTS.x264-ESiR.srt',
      subtitleType: SubtitleType.srt,
      subtitleDecoder: SubtitleDecoder.utf8,
    );
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _vlcPlayerController.pause();
      } else {
        _vlcPlayerController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: VlcPlayer(
              controller: _vlcPlayerController,
              aspectRatio: 16 / 9,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
          Center(
            child: SubtitleWrapper(
              videoPlayerController: _vlcPlayerController,
              subtitleController: _subtitleController,
              styleKey: 1,
              subtitleStyle: const SubtitleStyle(
                fontSize: 16,
                textColor: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _togglePlayPause,
              tooltip: _isPlaying ? 'Pause' : 'Play',
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}
