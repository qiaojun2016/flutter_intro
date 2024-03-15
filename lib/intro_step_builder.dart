part of 'flutter_intro.dart';

class IntroStepBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    GlobalKey key,
  ) builder;

  /// Set the group of this step, default is 'default'
  final String group;

  /// Establish a running sequence where lower values take precedence for execution.
  final int order;

  /// The method of generating the content of the guide page,
  /// which will be called internally by [Intro] when the guide page appears.
  /// And will pass in some parameters on the current page through [StepWidgetParams]
  final Widget Function(StepWidgetParams params)? overlayBuilder;

  /// When highlight widget is tapped
  final VoidCallback? onHighlightWidgetTap;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry? borderRadius;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets? padding;

  final String? text;

  /// When widget loaded (means the key is add to context)
  final VoidCallback? onWidgetLoad;

  const IntroStepBuilder({
    super.key,
    required this.order,
    required this.builder,
    this.text,
    this.overlayBuilder,
    this.borderRadius,
    this.onHighlightWidgetTap,
    this.padding,
    this.onWidgetLoad,
    this.group = 'default',
  }) : assert(text != null || overlayBuilder != null);

  GlobalKey get _key => GlobalStringKey('${group}_$order');

  @override
  State<IntroStepBuilder> createState() => _IntroStepBuilderState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IntroStepBuilder(group: $group, order: $order)';
  }
}

class _IntroStepBuilderState extends State<IntroStepBuilder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Intro flutterIntro = Intro.of(context);
      flutterIntro._introStepBuilderListMap[widget.group] ??= [];
      if (!flutterIntro._introStepBuilderListMap[widget.group]!
          .contains(widget)) {
        flutterIntro._introStepBuilderListMap[widget.group]!.add(widget);
        widget.onWidgetLoad?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget._key);
  }
}
