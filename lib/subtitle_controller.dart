import 'package:subtitle_wrapper/bloc/subtitle/subtitle_bloc.dart';

class UniversalSubtitleController {
  UniversalSubtitleController({
    this.subtitleUrl,
    this.subtitlesContent,
    this.subtitleDecoder,
    this.subtitleType = SubtitleType.webvtt,
  });
  String? subtitlesContent;
  String? subtitleUrl;

  SubtitleDecoder? subtitleDecoder;
  SubtitleType subtitleType;
  bool _attached = false;
  SubtitleBloc? _subtitleBloc;

  void attach(SubtitleBloc subtitleBloc) {
    _subtitleBloc = subtitleBloc;
    _attached = true;
  }

  void detach() {
    _attached = false;
    _subtitleBloc = null;
  }

  void updateSubtitleUrl({
    required String url,
  }) {
    if (_attached) {
      subtitleUrl = url;
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    } else {
      throw Exception('Seems that the controller is not correctly attached.');
    }
  }

  void updateSubtitleContent({
    required String content,
  }) {
    if (_attached) {
      subtitlesContent = content;
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    } else {
      throw Exception('Seems that the controller is not correctly attached.');
    }
  }
}

enum SubtitleDecoder {
  utf8,
  latin1,
}

enum SubtitleType {
  webvtt,
  srt,
}
