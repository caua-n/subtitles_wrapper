import 'package:subtitle_wrapper/bloc/subtitle/subtitle_bloc.dart';
import 'dart:ui';
import 'dart:async';

final List<VoidCallback> globalListeners = [];

void addGlobalListener(VoidCallback listener) {
  globalListeners.add(listener);
}

void removeGlobalListener(VoidCallback listener) {
  globalListeners.remove(listener);
}

class UniversalSubtitleController {
  UniversalSubtitleController({
    required this.subtitleUrl,
    this.subtitlesContent,
    this.subtitleDecoder,
    this.subtitleType = SubtitleType.webvtt,
  });
  String? subtitlesContent;
  String subtitleUrl;

  SubtitleDecoder? subtitleDecoder;
  SubtitleType subtitleType;
  bool _attached = false;
  SubtitleBloc? _subtitleBloc;
  double _subtitleDelay = 0;
  Timer? _throttleTimer;

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

  void addSubtitleDelay(double milliseconds) {
    _subtitleDelay += milliseconds;
    _throttleNotifyDelayChange();
  }

  void removeSubtitleDelay(double milliseconds) {
    _subtitleDelay -= milliseconds;
    _throttleNotifyDelayChange();
  }

  double get subtitleDelay => _subtitleDelay;

  void _throttleNotifyDelayChange() {
    if (_throttleTimer?.isActive ?? false) return;

    _throttleTimer = Timer(Duration(milliseconds: 100), () {
      _notifyDelayChange();
    });
  }

  void _notifyDelayChange() {
    if (_attached) {
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    }
    for (final listener in globalListeners) {
      listener();
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
