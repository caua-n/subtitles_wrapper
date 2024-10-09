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
          'https://www.opensubtitles.com/download/359337817118D0D29462290D222E3E1DDBF21F0A57BC1518F57249E10AC87A62F0E29F57632274F8A2D21D53833D9F90E45384C9794C3A3CBEA85DC1004048EEF9A336BE0F81C5966B69BE3B4C2DD8820439AAA9FEFDC0CABEBEFDF84DCC33376AA394EFFF28E9D01C953DD2D410BC42603D352E09976055F85CBAFA6F5DE49FFFF3F5087BEFE91976E8E49A5C81A0DCCC50BBCCA465CA5EC5D1D04C3BB8A11D442F0BEC99B82F0FD56CB121B78313B003D53CFDA583DF70BCEB9B8303556FF14F29135CF24F877261B9F40AF0FDB4F1B5B39BAE1799AD6933B652ADAB720A9F2728F21850E41C1E2472C4C5A7EA1DC2D08958C8D84F8A3A/subfile/Iron%20Man.2008.1080p.BluRay.DTS.srt',
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
        backgroundColor: Colors.amber,
        title: Text('Subtitles for VLC'),
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
                  backgroundColor: Colors.amber,
                  onPressed: _increaseSubtitleDelay,
                  tooltip: 'Increase Subtitle Delay',
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.amber,
                  onPressed: _decreaseSubtitleDelay,
                  tooltip: 'Decrease Subtitle Delay',
                  child: Icon(Icons.remove),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.amber,
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
