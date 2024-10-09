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
  double _sliderValue = 0.0;

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
    _vlcPlayerController.addListener(() {
      setState(() {
        _sliderValue = _vlcPlayerController.value.position.inSeconds.toDouble();
      });
    });
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

  void _increaseSubtitleDelay() {
    _subtitleController.addSubtitleDelay(0.1);
  }

  void _decreaseSubtitleDelay() {
    _subtitleController.removeSubtitleDelay(0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              VlcPlayer(
                controller: _vlcPlayerController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
              Container(
                color: Colors.black,
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                child: SubtitleWrapper(
                  videoPlayerController: _vlcPlayerController,
                  subtitleController: _subtitleController,
                  styleKey: 1,
                  subtitleStyle: const SubtitleStyle(
                    fontSize: 16,
                    textColor: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Position ${_vlcPlayerController.value.position}'),
                  SizedBox(width: 10),
                  Text(
                      'Duration ${_vlcPlayerController.value.duration.toString()}'),
                ],
              ),
              Text('Delay ${_subtitleController.subtitleDelay.toString()}'),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    overlayShape: SliderComponentShape.noThumb,
                    valueIndicatorColor: Colors.red,
                    activeTrackColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade200,
                    secondaryActiveTrackColor: Colors.green,
                    thumbColor: Colors.amber,
                    trackHeight: 4.0,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: _vlcPlayerController.value.duration.inSeconds
                        .toDouble(),
                    value: _sliderValue,
                    secondaryTrackValue:
                        _vlcPlayerController.value.bufferPercent.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      final position = Duration(seconds: value.toInt());
                      _vlcPlayerController.setTime(position.inMilliseconds);
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _increaseSubtitleDelay,
                  tooltip: 'Increase Subtitle Delay',
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _decreaseSubtitleDelay,
                  tooltip: 'Decrease Subtitle Delay',
                  child: Icon(Icons.remove),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _togglePlayPause,
                  tooltip: _isPlaying ? 'Pause' : 'Play',
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
