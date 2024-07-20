part of 'flutter_intro.dart';

/// Button [Widget] underneath intro text, using [text] as its content and
/// [onPressed] as its action.
///
/// Customize with [width] (default null), [height] (default 28), [fontSize]
/// (default 12), and [color] (default white).
class IntroButton extends StatelessWidget {
  static const double defaultHeight = 28;
  static const Color defaultColor = Colors.white;
  static const double defaultFontSize = 12;

  final String text;
  final double? width;
  final double height;
  final double fontSize;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  /// Constructor for [IntroButton] with required [text] and optional
  /// parameters.
  const IntroButton({
    super.key,
    required this.text,
    this.width,
    this.height = defaultHeight,
    this.fontSize = defaultFontSize,
    this.onPressed,
    this.style,
  });

  /// Named constructor for creating an [IntroButton] from an [IntroButtonConfig].
  IntroButton.fromConfig({
    super.key,
    required IntroButtonConfig config,
    this.onPressed,
  })  : text = config.text,
        width = config.width,
        height = config.height ?? defaultHeight,
        fontSize = config.fontSize ?? defaultFontSize,
        style = config.style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: defaultColor,
          shape: const StadiumBorder(),
          side:
              onPressed == null ? null : const BorderSide(color: defaultColor),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        ).merge(style),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
