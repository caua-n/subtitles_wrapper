import 'package:flutter/material.dart';
import 'package:subtitle_wrapper/subtitle_controller.dart';
import 'package:subtitle_wrapper/data/constants/view_keys.dart';
import 'package:subtitle_wrapper/data/models/style/subtitle_style.dart';

class SubtitleTextView extends StatelessWidget {
  const SubtitleTextView({
    required this.subtitleController,
    required this.subtitleStyle,
    super.key,
    this.backgroundColor,
  });

  final SubtitleController subtitleController;
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: subtitleController,
      builder: (context, child) {
        final currentSubtitle = subtitleController.currentSubtitle;
        if (currentSubtitle != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 20),
                child: _TextContent(
                  text: currentSubtitle.text,
                  textStyle: TextStyle(
                    fontSize: subtitleStyle.fontSize,
                    color: subtitleStyle.textColor,
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent({
    required this.textStyle,
    required this.text,
  });

  final TextStyle textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: ViewKeys.subtitleTextContent,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }
}
