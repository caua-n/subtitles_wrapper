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
    on<UpdateSubtitleDelay>((event, emit) {
      _subtitleDelay = event.delay;
      loadSubtitle(emit: emit);
    });
  }

  final VlcPlayerController videoPlayerController;
  final SubtitleRepository subtitleRepository;
  final SubtitleController subtitleController;

  late Subtitles subtitles;
  Subtitle? _currentSubtitle;
  Duration _subtitleDelay = Duration.zero;

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
        final adjustedPosition = videoPlayerPosition - _subtitleDelay;
        if (subtitles.subtitles.isNotEmpty &&
            adjustedPosition.inMilliseconds >
                subtitles.subtitles.last.endTime.inMilliseconds) {
          add(CompletedShowingSubtitles());
        }
        for (final subtitleItem in subtitles.subtitles) {
          final validStartTime = adjustedPosition.inMilliseconds >
              subtitleItem.startTime.inMilliseconds;
          final validEndTime = adjustedPosition.inMilliseconds <
              subtitleItem.endTime.inMilliseconds;
          final subtitle = validStartTime && validEndTime ? subtitleItem : null;
          if (validStartTime && validEndTime && subtitle != _currentSubtitle) {
            _currentSubtitle = subtitle;
          } else if (!_currentSubtitleIsValid(
            videoPlayerPosition: adjustedPosition.inMilliseconds,
          )) {
            _currentSubtitle = null;
          }
          add(
            UpdateLoadedSubtitle(
              subtitle: _currentSubtitle,
            ),
          );
        }
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
