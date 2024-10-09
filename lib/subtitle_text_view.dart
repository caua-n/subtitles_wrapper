import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper/data/constants/view_keys.dart';

import 'package:subtitle_wrapper/data/models/style/subtitle_style.dart';

class SubtitleTextView extends StatelessWidget {
  const SubtitleTextView({
    required this.subtitleStyle,
    super.key,
    this.backgroundColor,
  });
  final SubtitleStyle subtitleStyle;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final subtitleBloc = BlocProvider.of<SubtitleBloc>(context);

    void subtitleBlocListener(BuildContext _, SubtitleState state) {
      if (state is SubtitleInitialized) {
        subtitleBloc.add(LoadSubtitle());
      }
    }

    return BlocConsumer<SubtitleBloc, SubtitleState>(
      listener: subtitleBlocListener,
      builder: (context, state) {
        if (state is LoadedSubtitle && state.subtitle != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 20),
                child: _TextContent(
                  text: state.subtitle!.text,
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
