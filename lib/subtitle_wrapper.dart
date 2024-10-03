import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:subtitle_wrapper/subtitle_controller.dart';
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
    return AnimatedBuilder(
      animation: subtitleController,
      builder: (context, child) {
        final currentSubtitle = subtitleController.currentSubtitle;
        if (currentSubtitle != null) {
          final currentPosition = videoPlayerController.value.position;
          final adjustedPosition =
              currentPosition - subtitleController.subtitleDelay;

          if (adjustedPosition >= currentSubtitle.startTime &&
              adjustedPosition <= currentSubtitle.endTime) {
            return Text(
              currentSubtitle.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subtitleStyle.fontSize,
                color: subtitleStyle.textColor,
              ),
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
