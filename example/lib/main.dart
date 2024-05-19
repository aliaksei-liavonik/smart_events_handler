import 'package:example/src/events.dart';
import 'package:example/src/lazy_event_handler_page.dart';
import 'package:example/src/trigger_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smart_events_handler/smart_events_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final streamController = useStreamController<Event>();
    final currentIndex = useState(0);

    final pages = <Widget>[
      TriggerPage(streamController: streamController),
      const LazyEventHandlerPage(),
    ];

    return SmartEventGathererProvider<Event>(
      eventStream: streamController.stream,
      delegate: LazySmartEventGathererDelegate(),
      child: MaterialApp(
        home: Scaffold(
          body: pages[currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.send),
                label: 'Trigger Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available),
                label: 'Handle Event',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
