import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:subtitle_wrapper/subtitle_wrapper_package.dart';

part 'subtitle_event.dart';
part 'subtitle_state.dart';

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleState> {
  SubtitleBloc({
    required this.videoPlayerController,
    required this.subtitleRepository,
    required this.subtitleController,
  }) : super(SubtitleInitial()) {
    subtitleController.attach(this);
    on<LoadSubtitle>((event, emit) => loadSubtitle(emit: emit));
    on<InitSubtitles>((event, emit) => initSubtitles(emit: emit));
    on<UpdateLoadedSubtitle>(
      (event, emit) => emit(LoadedSubtitle(event.subtitle)),
    );
    on<CompletedShowingSubtitles>(
      (event, emit) => emit(CompletedSubtitle()),
    );
  }

  final VlcPlayerController videoPlayerController;
  final SubtitleRepository subtitleRepository;
  final SubtitleController subtitleController;

  late Subtitles subtitles;
  Subtitle? _currentSubtitle;
  int _lastSubtitleIndex = 0;

  Future<void> initSubtitles({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(SubtitleInitializing());
    subtitles = await subtitleRepository.getSubtitles();
    emit(SubtitleInitialized());
  }

  Future<void> loadSubtitle({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(LoadingSubtitle());
    videoPlayerController.addListener(
      () {
        final videoPlayerPosition = videoPlayerController.value.position;
        if (subtitles.subtitles.isNotEmpty &&
            videoPlayerPosition.inMilliseconds >
                subtitles.subtitles.last.endTime.inMilliseconds) {
          add(CompletedShowingSubtitles());
        }

        for (var i = _lastSubtitleIndex; i < subtitles.subtitles.length; i++) {
          final subtitleItem = subtitles.subtitles[i];
          final adjustedStartTime = subtitleItem.startTime.inMilliseconds +
              subtitleController.subtitleDelay;
          final adjustedEndTime = subtitleItem.endTime.inMilliseconds +
              subtitleController.subtitleDelay;

          final validStartTime =
              videoPlayerPosition.inMilliseconds > adjustedStartTime;
          final validEndTime =
              videoPlayerPosition.inMilliseconds < adjustedEndTime;
          final subtitle = validStartTime && validEndTime ? subtitleItem : null;

          if (validStartTime && validEndTime && subtitle != _currentSubtitle) {
            _currentSubtitle = subtitle;
            _lastSubtitleIndex = i;
            break;
          } else if (!_currentSubtitleIsValid(
            videoPlayerPosition: videoPlayerPosition.inMilliseconds,
          )) {
            _currentSubtitle = null;
          }
        }

        add(
          UpdateLoadedSubtitle(
            subtitle: _currentSubtitle,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    subtitleController.detach();

    return super.close();
  }

  bool _currentSubtitleIsValid({required int videoPlayerPosition}) {
    if (_currentSubtitle == null) return false;
    final validStartTime =
        videoPlayerPosition > _currentSubtitle!.startTime.inMilliseconds;
    final validEndTime =
        videoPlayerPosition < _currentSubtitle!.endTime.inMilliseconds;

    return validStartTime && validEndTime;
  }
}
