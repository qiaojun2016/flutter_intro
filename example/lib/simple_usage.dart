import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class SimpleUsage extends StatelessWidget {
  const SimpleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    Intro intro = Intro.of(context);

    return ValueListenableBuilder(
      valueListenable: intro.statusNotifier,
      builder: (context, value, child) {
        return PopScope(
          canPop: !value.isOpen,
          onPopInvoked: (didPop) {
            if (!didPop) {
              intro.dispose();
            }
          },
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(
                16,
              ),
              child: Center(
                child: Column(
                  children: [
                    IntroStepBuilder(
                      order: 2,
                      text:
                          'Use IntroStepBuilder to wrap the widget you need to guide.'
                          ' Add the necessary order to it, and then add the key in the builder method to the widget.',
                      builder: (context, key) => Text(
                        'Tap the floatingActionButton to start.',
                        key: key,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    IntroStepBuilder(
                      order: 3,
                      text:
                          'If you need more configuration, please refer to Advanced Usage.',
                      builder: (context, key) => Text(
                        'And you can use `buttonBuilder` to customize the button.',
                        key: key,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: IntroStepBuilder(
              order: 1,
              text: 'OK, let\'s start.',
              builder: (context, key) => FloatingActionButton(
                key: key,
                child: const Icon(
                  Icons.play_arrow,
                ),
                onPressed: () {
                  Intro.of(context).start(
                    reset: true,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
