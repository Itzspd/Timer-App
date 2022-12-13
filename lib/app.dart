import 'package:flutter/material.dart';

import 'timer/view/timer_page.dart';

class App extends MaterialApp {
  const App({super.key})
      : super(
          home: const TimerPage(),
          debugShowCheckedModeBanner: true,
        );
}
