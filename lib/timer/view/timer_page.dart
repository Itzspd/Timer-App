import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/timer/bloc/timer_state.dart';
import '../../ticker.dart';
import '../bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(ticker: Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          TimerText(),
          Action(),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final hourstr =
        ((duration / 3600) % 3600).floor().toString().padLeft(2, '0');
    final minutesstr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsstr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$hourstr:$minutesstr:$secondsstr',
      style: Theme.of(context).textTheme.headline1!.copyWith(
            fontSize: 100,
          ),
    );
  }
}

class Action extends StatelessWidget {
  const Action({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (state is TimerInitial) ...[
                GestureDetector(
                  onTap: () => context.read<TimerBloc>().add(
                        TimerStarted(duration: state.duration),
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(
                          50,
                        )),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.play_arrow,
                    ),
                  ),
                ),
              ],
              if (state is TimerRunInProgress) ...[
                GestureDetector(
                  onTap: () => context.read<TimerBloc>().add(
                        const TimerPaused(),
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(
                          50,
                        )),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.pause,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(
                          50,
                        )),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.replay,
                    ),
                  ),
                ),
              ],
              if (state is TimerRunPaused) ...[
                GestureDetector(
                  onTap: () =>
                      context.read<TimerBloc>().add(const TimerResumed()),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(
                          50,
                        )),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.play_arrow,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(
                          50,
                        )),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.replay,
                    ),
                  ),
                ),
              ],
              if (state is TimerRunComplete) ...[
                GestureDetector(
                  onTap: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(
                          50,
                        )),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.replay,
                    ),
                  ),
                ),
              ]
            ],
          );
        });
  }
}
