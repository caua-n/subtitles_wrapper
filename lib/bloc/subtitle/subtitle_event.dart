part of 'subtitle_bloc.dart';

abstract class SubtitleEvent extends Equatable {
  const SubtitleEvent();
  @override
  List<Object> get props => [];
}

class InitSubtitles extends SubtitleEvent {
  InitSubtitles({required this.subtitleController});
  final SubtitleController subtitleController;
}

class LoadSubtitle extends SubtitleEvent {}

class UpdateLoadedSubtitle extends SubtitleEvent {
  UpdateLoadedSubtitle({this.subtitle});
  final Subtitle? subtitle;
}

class CompletedShowingSubtitles extends SubtitleEvent {}

class UpdateSubtitleDelay extends SubtitleEvent {
  final Duration delay;

  const UpdateSubtitleDelay(this.delay);

  @override
  List<Object> get props => [delay];
}
