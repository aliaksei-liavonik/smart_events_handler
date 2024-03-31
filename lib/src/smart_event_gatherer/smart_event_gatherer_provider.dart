import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegate/smart_event_gatherer_delegate.dart';

/// Provides a [SmartEventGatherer] to the widget tree using a [Provider].
///
/// Designed to be instantiated at a high level within the widget tree, this
/// widget ensures the availability of a [SmartEventGatherer] for widgets deeper
/// in the hierarchy. It initializes the [SmartEventGatherer] with a given
/// stream of events, [eventStream], and optionally an [ISmartEventGathererDelegate],
/// making it available to descendant widgets via [Provider]. This setup
/// facilitates a centralized approach to event handling, offering customizable
/// processing and handling of events through the delegate.
///
/// By default, if no delegate is provided, [SmartEventGatherer] uses the
/// [SmartEventGathererDelegate], which processes events as they arrive without
/// additional logic. For more sophisticated event handling strategies, such as
/// lazily handling events or filtering, or lazy deeplink handling, a custom
/// delegate like [LazySmartEventGathererDelegate]
/// can be provided.
///
/// Usage:
/// ```dart
/// SmartEventGathererProvider<MyEvent>(
///   eventStream: myEventStream,
///   delegate: myCustomDelegate, // Optional, for custom event handling.
///   child: MyApp(),
/// );
/// ```
///
/// To use a lazy delegate for handling events lazily:
/// ```dart
/// SmartEventGathererProvider<MyEvent>(
///   eventStream: myEventStream,
///   delegate: LazySmartEventGathererDelegate(),
///   child: MyApp(),
/// );
/// ```
///
/// This lazy delegate ensures that events can be handled even after they have
/// been emitted, supporting scenarios where an event needs to be processed
/// after a delay or conditionally based on the app state.

class SmartEventGathererProvider<GathererEvent extends Object>
    extends StatelessWidget {
  /// Create new instance of [SmartEventGathererProvider].
  const SmartEventGathererProvider({
    super.key,
    required this.eventStream,
    this.delegate,
    required this.child,
  });

  /// Stream of the events to gather by [SmartEventGatherer].
  final Stream<GathererEvent> eventStream;

  /// The delegate responsible for handling the events.
  ///
  /// This delegate can be customized to alter how events are processed
  /// and handled within the application. It provides a layer of flexibility
  /// in event management, allowing for sophisticated event handling strategies.
  final ISmartEventGathererDelegate<GathererEvent>? delegate;

  // ignore: public_member_api_docs
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<SmartEventGatherer<GathererEvent>>(
      lazy: false,
      create: (_) => SmartEventGatherer<GathererEvent>(
        eventStream,
        delegate: delegate,
      ),
      dispose: (_, service) => service.dispose(),
      child: child,
    );
  }
}
