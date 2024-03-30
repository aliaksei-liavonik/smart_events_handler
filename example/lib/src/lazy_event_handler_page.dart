import 'package:example/src/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smart_events_handler/smart_events_handler.dart';

class LazyEventHandlerPage extends HookWidget {
  const LazyEventHandlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventHandled = useState(false);

    return Scaffold(
      body: SmartEventHandler<Event, Event>(
        onSmartEventReceived: (event) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          eventHandled.value = true;
        },
        child: Center(
          child: eventHandled.value
              ? const Text('Event has been handled!')
              : const Text('Waiting for event...'),
        ),
      ),
    );
  }
}
