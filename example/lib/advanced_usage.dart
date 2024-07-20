import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class AdvancedUsage extends StatefulWidget {
  const AdvancedUsage({super.key});

  @override
  State<AdvancedUsage> createState() => _AdvancedUsageState();
}

class _AdvancedUsageState extends State<AdvancedUsage> {
  bool rendered = false;

  @override
  Widget build(BuildContext context) {
    Intro intro = Intro.of(context);

    return ValueListenableBuilder(
      valueListenable: intro.statusNotifier,
      builder: (context, value, child) {
        return PopScope(
          canPop: !value.isOpen,

          /// If the user clicks the return button, the guide will end early
          onPopInvoked: (didPop) {
            if (!didPop) {
              intro.dispose();
            }
          },
          child: Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntroStepBuilder(
                      /// 2nd guide
                      order: 2,
                      overlayBuilder: (params) {
                        return Container(
                          color: Colors.teal,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              params.onNext == null
                                  ? const Column(
                                      children: [
                                        Text(
                                          'Of course, you can also render what you want through overlayBuilder.',
                                          style: TextStyle(height: 1.6),
                                        ),
                                        Text(
                                          'In addition, we can finally add new guide widget dynamically.',
                                          style: TextStyle(height: 1.6),
                                        ),
                                        Text(
                                          'Click highlight area to add new widget.',
                                          style: TextStyle(height: 1.6),
                                        )
                                      ],
                                    )
                                  : const Text(
                                      'As you can see, you can move on to the next step',
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                ),
                                child: Row(
                                  children: [
                                    IntroButton(
                                      text: 'Prev',
                                      onPressed: params.onPrev,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    IntroButton(
                                      text: 'Next',
                                      onPressed: params.onNext,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onHighlightWidgetTap: () {
                        setState(() {
                          rendered = true;
                        });
                      },
                      builder: (context, key) => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Placeholder(
                            key: key,
                            fallbackWidth: 100,
                            fallbackHeight: 100,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    rendered
                        ? IntroStepBuilder(
                            order: 3,
                            onWidgetLoad: () {
                              Intro.of(context).refresh();
                            },
                            overlayBuilder: (params) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.teal,
                                child: Column(
                                  children: [
                                    const Text(
                                      'That\'s it, hopefully version 3.0 makes you feel better than 2.0',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          IntroButton(
                                            onPressed: params.onPrev,
                                            text: 'Prev',
                                          ),
                                          const SizedBox(width: 4),
                                          IntroButton(
                                            onPressed: params.onNext,
                                            text: 'Next',
                                          ),
                                          const SizedBox(width: 4),
                                          IntroButton(
                                            onPressed: params.onFinish,
                                            text: 'Finish',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            builder: (context, key) => Text(
                              'I am a delay render widget.',
                              key: key,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            floatingActionButton: IntroStepBuilder(
              /// 1st guide
              order: 1,
              text:
                  'Some properties on IntroStepBuilder like `borderRadius` `padding`'
                  ' allow you to configure the configuration of this step.',
              padding: const EdgeInsets.symmetric(
                vertical: -5,
                horizontal: -5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(64)),
              builder: (context, key) => FloatingActionButton(
                key: key,
                child: const Icon(
                  Icons.play_arrow,
                ),
                onPressed: () {
                  Intro.of(context).start();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
