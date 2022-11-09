import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'model/timer.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building MyHomePage');
    return Scaffold(
      appBar: AppBar(title: const Text('My Timer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            TimerTextWidget(),
            SizedBox(height: 20),
            ButtonsContainer(),
          ],
        ),
      ),
    );
  }
}

class TimerTextWidget extends HookWidget {
  const TimerTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeLeft = useProvider(timerProvider).timeLeft;
    print('building TimerTextWidget $timeLeft');
    return Text(
      timeLeft,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}

class ButtonsContainer extends HookWidget {
  const ButtonsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building ButtonsContainer');
    final state = useProvider(timerProvider).buttonState;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state == ButtonState.initial) ...[
          const StartButton(),
        ],
        if (state == ButtonState.started) ...[
          const PauseButton(),
          const SizedBox(width: 20),
          const ResetButton(),
        ],
        if (state == ButtonState.paused) ...[
          const StartButton(),
          const SizedBox(width: 20),
          const ResetButton(),
        ],
        if (state == ButtonState.finished) ...[
          const ResetButton(),
        ],
      ],
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).start();
      },
      child: const Icon(Icons.play_arrow),
    );
  }
}

class PauseButton extends StatelessWidget {
  const PauseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).pause();
      },
      child: const Icon(Icons.pause),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).reset();
      },
      child: const Icon(Icons.replay),
    );
  }
}
