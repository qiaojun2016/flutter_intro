part of 'flutter_intro.dart';

class IntroButtonConfig {
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;
  final ButtonStyle? style;

  const IntroButtonConfig({
    required this.text,
    this.style,
    this.width,
    this.height,
    this.fontSize,
  });
}
