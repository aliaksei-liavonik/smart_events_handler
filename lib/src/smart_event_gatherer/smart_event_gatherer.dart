import 'dart:async';

import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegate/smart_event_gatherer_delegate.dart';
import 'package:smart_events_handler/src/utils/disposable.dart';

/// Callback definition for handling received events of type [Event].
///
/// This callback function is used to define actions that should be taken
/// when an event is received. It must be implemented to handle the event.
typedef OnSmartEventReceived<Event> = Future<void> Function(
  Event event,
);

/// Manages event gathering and delegation for events of type [GathererEvent].
///
/// This class is responsible for listening to an incoming [Stream<GathererEvent>]
/// and forwarding those events to a specified delegate. The [ISmartEventGathererDelegate]
/// is used to manage how events are processed or handled. If no delegate is provided
/// upon initialization, a default [SmartEventGathererDelegate] instance is used.
///
/// Usage of a delegate allows for customizable event handling strategies, such as
/// filtering, modification, or aggregation of events before they reach their final destination.
///
/// This class implements [Disposable] to ensure proper cleanup of resources, particularly
/// the stream subscription, when the gatherer is no longer needed.
final class SmartEventGatherer<GathererEvent extends Object> with Disposable {
  /// Constructs a [SmartEventGatherer] with the given [eventsStream] and an optional [delegate].
  ///
  /// - [eventsStream]: The stream of events this gatherer should listen to.
  /// - [delegate]: An optional delegate for custom event handling. If not provided,
  ///   a default [SmartEventGathererDelegate] is utilized.
  SmartEventGatherer(
    Stream<GathererEvent> eventsStream, {
    ISmartEventGathererDelegate<GathererEvent>? delegate,
  }) {
    this.delegate = delegate ?? SmartEventGathererDelegate<GathererEvent>();

    addDisposable(
      eventsStream.listen(this.delegate.add).cancel,
    );
    addDisposable(() async => await delegate?.dispose());
  }

  /// The delegate responsible for handling the events.
  ///
  /// This delegate can be customized to alter how events are processed
  /// and handled within the application. It provides a layer of flexibility
  /// in event management, allowing for sophisticated event handling strategies.
  late final ISmartEventGathererDelegate<GathererEvent> delegate;
}
