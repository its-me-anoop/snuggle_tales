import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:snuggle_tales/Utils/warning.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          SizedBox(
            height: 400,
            width: 400,
            child: Stack(
              children: [
                const SizedBox(
                    height: 400,
                    width: 400,
                    child: RiveAnimation.asset('loader.riv')),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.black,
                    height: 80,
                    width: 200,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 400.0,
            height: 200.0,
            child: Center(
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                child: AnimatedTextKit(
                  isRepeatingAnimation: true,
                  totalRepeatCount: 10,
                  animatedTexts: [
                    FadeAnimatedText('Unraveling tales...'),
                    FadeAnimatedText('Crafting stories...'),
                    FadeAnimatedText('In the creative forge...'),
                  ],
                ),
              ),
            ),
          ),
          const Warning()
        ],
      )),
    );
  }
}
