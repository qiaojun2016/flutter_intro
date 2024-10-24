import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class GroupUsage extends StatelessWidget {
  const GroupUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(right: 100),
        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (index) => IntroStepBuilder(
                    order: index,
                    text: 'group: default, order: $index',
                    builder: (context, key) {
                      return Text(
                        'group: default, order: $index',
                        key: key,
                      );
                    },
                  ),
                ).toList(),
              ),
              const SizedBox(
                height: 32,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (index) => IntroStepBuilder(
                    group: 'other',
                    order: index,
                    text: 'group: other, order: $index',
                    builder: (context, key) {
                      return Text(
                        'group: other, order: $index',
                        key: key,
                      );
                    },
                  ),
                ).toList(),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Intro.of(context).start();
                    },
                    child: const Text('Group: default'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Intro.of(context).start(
                        group: 'other',
                      );
                    },
                    child: const Text('Group: other'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
