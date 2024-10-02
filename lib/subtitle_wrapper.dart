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
    this.subtitleStyle = const SubtitleStyle(),
    this.backgroundColor,
  });

  final SubtitleController subtitleController;
  final VlcPlayerController videoPlayerController;
  final int styleKey;
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubtitleBloc, SubtitleState>(
      builder: (context, state) {
        if (state is LoadedSubtitle && state.subtitle != null) {
          final currentPosition = videoPlayerController.value.position;
          final adjustedPosition =
              currentPosition - subtitleController.subtitleDelay;

          if (adjustedPosition >= state.subtitle!.startTime &&
              adjustedPosition <= state.subtitle!.endTime) {
            return Text(
              state.subtitle!.text,
              textAlign: TextAlign.center,
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
