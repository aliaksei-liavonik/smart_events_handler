import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_events_handler/src/smart_event_gatherer.dart';

/// Facilitates the provisioning of a [SmartEventGatherer] to the widget tree
/// through a [Provider].
///
/// Designed to be instantiated at a high level within the widget tree, this
/// widget ensures the availability of a [SmartEventGatherer] for widgets deeper
///  in the hierarchy. It initializes the [SmartEventGatherer] with a given
/// stream of events, [eventStream], and subsequently avails it to descendant
/// widgets via [Provider], facilitating a centralized approach to event
/// handling.
///
/// Usage:
/// ```
/// SmartEventGathererProvider<MyEvent>(
///   eventStream: myEventStream,
///   child: MyApp(),
/// );
/// ```
///
/// When the [SmartEventGathererProvider] is dismantled from the widget tree,
/// the associated [SmartEventGatherer] is also automatically disposed of,
/// ensuring a clean and leak-free implementation. This setup enables a
/// structured and efficient mechanism for event distribution and management,
/// accommodating diverse event types and handling requirements within the
/// application.

class SmartEventGathererProvider<Event extends Object> extends StatelessWidget {
  /// Create new instance of [SmartEventGathererProvider].
  const SmartEventGathererProvider({
    super.key,
    required this.eventStream,
    required this.child,
  });

  /// Stream of the events to gather by [SmartEventGatherer].
  final Stream<Event> eventStream;

  // ignore: public_member_api_docs
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<SmartEventGatherer<Event>>(
      lazy: false,
      create: (_) => SmartEventGatherer<Event>(eventStream),
      dispose: (_, service) => service.dispose(),
      child: child,
    );
  }
}
