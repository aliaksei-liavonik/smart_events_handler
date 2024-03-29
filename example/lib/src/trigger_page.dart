import 'dart:async';

import 'package:example/src/events.dart';
import 'package:flutter/material.dart';

class TriggerPage extends StatelessWidget {
  const TriggerPage({super.key, required this.streamController});

  final StreamController<Event> streamController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => streamController.add(Event()),
        child: const Text('Trigger Lazy Event'),
      ),
    );
  }
}
