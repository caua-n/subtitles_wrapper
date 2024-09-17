import 'package:flutter/material.dart';

class SubtitleStyle {
  const SubtitleStyle({
    this.fontSize = 24.0,
    this.textColor = Colors.white,
  });

  final double fontSize;
  final Color textColor;

  static const SubtitleStyle mediumStyle = SubtitleStyle();

  static const SubtitleStyle smallStyle = SubtitleStyle(
    fontSize: 16.0,
    textColor: Colors.yellow,
  );

  static const SubtitleStyle largeStyle = SubtitleStyle(
    fontSize: 32.0,
  );
}
