import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:smart_events_handler/src/smart_event_gatherer.dart';

final class SmartEventListener<Event extends GathererEvent,
    GathererEvent extends Object> extends HookWidget {
  const SmartEventListener({super.key, required this.builder});

  final Widget Function(Event? deeplink) builder;

  @override
  Widget build(BuildContext context) {
    final gatherer = context.read<SmartEventGatherer<GathererEvent>>();

    final lastEvent = gatherer.lastEvent;
    final deeplink = useState(lastEvent is Event ? lastEvent : null);

    useEffect(
      () => gatherer
          .onType<Event>()
          .listen((event) => deeplink.value = event)
          .cancel,
      [gatherer.lastEvent],
    );

    return builder(deeplink.value);
  }
}
