library flutter_intro;

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

part 'delay_rendered_widget.dart';
part 'flutter_intro_exception.dart';
part 'global_keys.dart';
part 'intro_button.dart';
part 'intro_status.dart';
part 'intro_step_builder.dart';
part 'overlay_position.dart';
part 'step_widget_builder.dart';
part 'step_widget_params.dart';
part 'throttling.dart';

class Intro extends InheritedWidget {
  static String _group = 'default';
  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;
  static bool _removed = false;
  static Size _screenSize = const Size(0, 0);
  static Widget _overlayWidget = const SizedBox.shrink();
  static IntroStepBuilder? _currentStep;
  static Size _widgetSize = const Size(0, 0);
  static Offset _widgetOffset = const Offset(0, 0);

  final List<String> _finishedGroups = [];

  final _th = _Throttling(duration: const Duration(milliseconds: 500));

  /// All steps that need to be displayed
  final Map<String, List<IntroStepBuilder>> _stepsMap = {
    "default": [],
  };

  late final Duration _animationDuration;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets padding;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry borderRadius;

  /// The mask color of step page
  final Color maskColor;

  /// No animation
  final bool noAnimation;

  /// Click on whether the mask is allowed to be closed.
  final bool maskClosable;

  final ValueNotifier<IntroStatus> statusNotifier = ValueNotifier(
    IntroStatus(isOpen: false),
  );

  /// [order] order
  final String Function(
    int order,
  )? buttonTextBuilder;

  Intro({
    super.key,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.maskColor = const Color.fromRGBO(0, 0, 0, .6),
    this.noAnimation = false,
    this.maskClosable = false,
    this.buttonTextBuilder,
    required super.child,
  }) {
    _animationDuration =
        noAnimation ? Duration.zero : const Duration(milliseconds: 300);
  }

  IntroStatus get status => statusNotifier.value;

  List<IntroStepBuilder> _getSteps() {
    return (_stepsMap[_group] ?? [])..sort((a, b) => a.order - b.order);
  }

  bool get hasNextStep =>
      _currentStep == null ||
      _getSteps().where((e) => e.order > _currentStep!.order).isNotEmpty;

  bool get hasPrevStep =>
      _currentStep != null &&
      _getSteps().firstWhereOrNull((e) => e.order < _currentStep!.order) !=
          null;

  IntroStepBuilder? _getNextStep({
    bool isUpdate = false,
  }) {
    if (isUpdate) {
      return _currentStep;
    }

    var steps = _getSteps();

    if (_currentStep == null) return steps.firstOrNull;

    return _getSteps().firstWhereOrNull(
      (e) => e.order > _currentStep!.order,
    );
  }

  IntroStepBuilder? _getPrevStep({
    bool isUpdate = false,
  }) {
    if (isUpdate) {
      return _currentStep;
    }

    if (_currentStep == null) return null;

    return _getSteps().lastWhereOrNull(
      (e) => e.order < _currentStep!.order,
    );
  }

  void _setOverlay(OverlayEntry? overlayEntry) {
    _overlayEntry = overlayEntry;
    statusNotifier.value = IntroStatus(isOpen: overlayEntry != null);
  }

  Widget _widgetBuilder({
    double? width,
    double? height,
    BlendMode? backgroundBlendMode,
    required double left,
    required double top,
    double? bottom,
    double? right,
    BorderRadiusGeometry? borderRadiusGeometry,
    Widget? child,
    VoidCallback? onTap,
  }) {
    final decoration = BoxDecoration(
      color: Colors.white,
      backgroundBlendMode: backgroundBlendMode,
      borderRadius: borderRadiusGeometry,
    );
    return AnimatedPositioned(
      duration: _animationDuration,
      left: left,
      top: top,
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          padding: padding,
          decoration: decoration,
          width: width,
          height: height,
          duration: _animationDuration,
          child: child,
        ),
      ),
    );
  }

  void _onFinish() {
    if (_overlayEntry == null) return;

    _removed = true;
    _overlayEntry?.markNeedsBuild();

    Timer(_animationDuration, () {
      if (_overlayEntry == null) return;

      _finishedGroups.add(_group);
      _currentStep = null;
      _overlayEntry?.remove();
      _removed = false;
      _setOverlay(null);
    });
  }

  void _render({
    bool isUpdate = false,
    bool reverse = false,
  }) {
    IntroStepBuilder? step = reverse
        ? _getPrevStep(isUpdate: isUpdate)
        : _getNextStep(isUpdate: isUpdate);
    _currentStep = step;

    if (step == null) {
      _onFinish();
      return;
    }

    BuildContext? currentContext = step._key.currentContext;

    if (currentContext == null) {
      throw FlutterIntroException(
        'The current context is null, because there is no widget in the tree that matches this global key.'
        ' Please check whether the key in IntroStepBuilder(group: ${step.group}, order: ${step.order}) has forgotten to bind.'
        ' If you are already bound, it means you have encountered a bug, please let me know.',
      );
    }

    RenderBox renderBox = currentContext.findRenderObject() as RenderBox;

    _screenSize = MediaQuery.of(_context!).size;
    _widgetSize = Size(
      renderBox.size.width + (step.padding?.horizontal ?? padding.horizontal),
      renderBox.size.height + (step.padding?.vertical ?? padding.vertical),
    );
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx -
          (step.padding?.left ?? padding.left),
      renderBox.localToGlobal(Offset.zero).dy -
          (step.padding?.top ?? padding.top),
    );

    OverlayPosition position = _StepWidgetBuilder.getOverlayPosition(
      screenSize: _screenSize,
      size: _widgetSize,
      offset: _widgetOffset,
    );

    if (step.overlayBuilder != null) {
      _overlayWidget = Stack(
        children: [
          Positioned(
            width: position.width,
            left: position.left,
            top: position.top,
            bottom: position.bottom,
            right: position.right,
            child: SizedBox(
              child: step.overlayBuilder!(
                StepWidgetParams(
                  group: step.group,
                  order: step.order,
                  onNext: hasNextStep ? _render : null,
                  onPrev: hasPrevStep
                      ? () {
                          _render(reverse: true);
                        }
                      : null,
                  onFinish: _onFinish,
                  screenSize: _screenSize,
                  size: _widgetSize,
                  offset: _widgetOffset,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (step.text != null) {
      _overlayWidget = Stack(
        children: [
          Positioned(
            left: position.left,
            top: position.top,
            bottom: position.bottom,
            right: position.right,
            child: SizedBox(
              width: position.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: position.crossAxisAlignment,
                children: [
                  Text(
                    step.text!,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  IntroButton(
                    text: buttonTextBuilder == null
                        ? 'Next'
                        : buttonTextBuilder!(step.order),
                    onPressed: _render,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_overlayEntry == null) {
      _createOverlay();
    } else {
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _createOverlay() {
    _setOverlay(OverlayEntry(
      builder: (BuildContext context) {
        Size currentScreenSize = MediaQuery.of(context).size;

        if (_screenSize.width != currentScreenSize.width ||
            _screenSize.height != currentScreenSize.height) {
          _screenSize = currentScreenSize;

          _th.throttle(() {
            _render(
              isUpdate: true,
            );
          });
        }

        return _DelayRenderedWidget(
          removed: _removed,
          childPersist: true,
          duration: _animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    maskColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      _widgetBuilder(
                        backgroundBlendMode: BlendMode.dstOut,
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        onTap: maskClosable
                            ? () {
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  _render,
                                );
                              }
                            : null,
                      ),
                      _widgetBuilder(
                        width: _widgetSize.width,
                        height: _widgetSize.height,
                        left: _widgetOffset.dx,
                        top: _widgetOffset.dy,
                        borderRadiusGeometry:
                            _currentStep?.borderRadius ?? borderRadius,
                        onTap: _currentStep?.onHighlightWidgetTap,
                      ),
                    ],
                  ),
                ),
                _DelayRenderedWidget(
                  duration: _animationDuration,
                  child: _overlayWidget,
                ),
              ],
            ),
          ),
        );
      },
    ));
    Overlay.of(_context!).insert(_overlayEntry!);
  }

  void start({
    String group = 'default',
    bool reset = false,
  }) {
    if (_finishedGroups.contains(group)) {
      if (!reset) {
        throw FlutterIntroException(
          'The group $group has already been completed, if you want to start again, please call the start method with reset = true.',
        );
      } else {
        _finishedGroups.remove(group);
      }
    }
    _group = group;
    _render();
  }

  void refresh() {
    _render(
      isUpdate: true,
    );
  }

  static Intro of(BuildContext context) {
    _context = context;
    Intro? intro = context.dependOnInheritedWidgetOfExactType<Intro>();
    if (intro == null) {
      throw FlutterIntroException(
        'The context does not contain an Intro widget.',
      );
    }
    return intro;
  }

  void dispose() {
    _onFinish();
  }

  @override
  bool updateShouldNotify(Intro oldWidget) {
    return false;
  }
}
