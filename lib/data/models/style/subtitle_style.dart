import 'package:flutter/material.dart';

const _defaultFontSize = 16.0;

class SubtitleStyle {
  const SubtitleStyle({
    this.fontSize = _defaultFontSize,
    this.textColor = Colors.yellow,
  });
  final double fontSize;
  final Color textColor;
}
