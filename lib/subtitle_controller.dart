import 'package:flutter/foundation.dart';
import 'package:subtitle_wrapper/data/models/subtitle.dart';

class SubtitleController extends ChangeNotifier {
  SubtitleController({
    this.subtitleUrl,
    this.subtitlesContent,
    this.subtitleDecoder,
    this.subtitleType = SubtitleType.webvtt,
  });

  String? subtitlesContent;
  String? subtitleUrl;
  Duration _subtitleDelay = Duration.zero;
  SubtitleDecoder? subtitleDecoder;
  SubtitleType subtitleType;
  Subtitle? _currentSubtitle;

  Subtitle? get currentSubtitle => _currentSubtitle;
  Duration get subtitleDelay => _subtitleDelay;

  void setSubtitleDelay(Duration delay) {
    _subtitleDelay = delay;
    notifyListeners();
  }

  void updateCurrentSubtitle(Subtitle? subtitle) {
    if (subtitle != _currentSubtitle) {
      _currentSubtitle = subtitle;
      notifyListeners();
    }
  }

  void updateSubtitleUrl(String url) {
    subtitleUrl = url;
    notifyListeners();
  }

  void updateSubtitleContent(String content) {
    subtitlesContent = content;
    notifyListeners();
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
