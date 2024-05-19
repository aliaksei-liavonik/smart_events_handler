import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer.dart';

/// A widget that listens to events of type [Event], using a [SmartEventGatherer].
///
/// This widget is designed to integrate with the `smart_events_handler` package, providing a way
/// to reactively listen for specific types of events within the widget tree. When an event of type [Event]
/// is received, the widget rebuilds, allowing for dynamic UI updates based on the event data.
///
/// The [builder] function is called to build the widget tree. This function receives the most recent
/// event of type [Event], or `null` if no such event has been received. This enables conditional rendering
/// based on the presence or absence of an event.
///
/// Usage example:
/// ```dart
/// SmartEventListener<MyEvent>(
///   builder: (event) {
///     return Text(event != null ? 'Event received: ${event.description}' : 'No event yet');
///   },
/// )
/// ```
///
/// [Event] is the specific event type you are interested in listening to.
/// [GathererEvent] is the broader event type that [SmartEventGatherer] handles, from which [Event] is derived.
final class SmartEventListener<Event extends GathererEvent,
    GathererEvent extends Object> extends HookWidget {
  /// Creates an instance of [SmartEventListener].
  const SmartEventListener({super.key, required this.builder});

  /// The builder function that defines the UI based on the received event.
  ///
  /// This function is called every time the widget needs to be rebuilt, which includes
  /// when an event of type [Event] is received. It provides the event data to the builder function,
  /// allowing for UI updates based on the event's content.
  final Widget Function(Event? event) builder;

  @override
  Widget build(BuildContext context) {
    final gatherer = context.read<SmartEventGatherer<GathererEvent>>();

    final event = useState<Event?>(null);

    useEffect(
      () => gatherer.getEvents<Event>().listen((e) => event.value = e).cancel,
      [],
    );

    return builder(event.value);
  }
}
