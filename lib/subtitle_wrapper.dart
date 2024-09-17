import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:subtitle_wrapper/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper/subtitle_wrapper_package.dart';

class SubtitleWrapper extends StatelessWidget {
  const SubtitleWrapper({
    required this.subtitleController,
    required this.videoPlayerController,
    required this.styleKey,
    super.key,
    this.backgroundColor,
  });

  final SubtitleController subtitleController;
  final VlcPlayerController videoPlayerController;
  final int styleKey;
  final Color? backgroundColor;

  SubtitleStyle get subtitleStyle {
    switch (styleKey) {
      case 1:
        return SubtitleStyle.smallStyle;
      case 2:
        return SubtitleStyle.largeStyle;
      default:
        return SubtitleStyle.mediumStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 30,
      left: 0,
      right: 0,
      child: BlocProvider(
        create: (context) => SubtitleBloc(
          videoPlayerController: videoPlayerController,
          subtitleRepository: SubtitleDataRepository(
            subtitleController: subtitleController,
          ),
          subtitleController: subtitleController,
        )..add(
            InitSubtitles(
              subtitleController: subtitleController,
            ),
          ),
        child: SubtitleTextView(
          subtitleStyle: subtitleStyle,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
