import 'dart:async';

import 'package:smart_events_handler/src/utils/disposable.dart';

/// Defines an interface for event gatherer delegates.
///
/// This interface specifies methods for managing a stream of events of type [GathererEvent].
/// Implementations of this interface determine how events are added, filtered for unhandled events,
/// and marked as resolved.
///
/// - [getEvents]: Retrieves a stream of events with specific type.
/// - [add]: Adds an event to be processed.
/// - [markAsResolved]: Marks the event or events as resolved, if applicable.
abstract class ISmartEventGathererDelegate<GathererEvent extends Object>
    with Disposable {
  /// Retrieves a stream of events.
  ///
  /// This method allows subscribers to listen for specific types of events that have not yet
  /// been marked as resolved. It is useful for filtering and processing events based on their type.
  Stream<T> getEvents<T extends GathererEvent>();

  /// Adds an event of type [Event] to the delegate's management.
  ///
  /// This method is responsible for introducing new events into the event stream, making them
  /// available for processing by any listeners subscribed through `getEvents`.
  void add<Event extends GathererEvent>(Event event);

  /// Marks the currently processed event or events as resolved.
  ///
  /// Implementations can decide the behavior of this method, whether it marks only the current
  /// event, a specific event, or all events as resolved. Marking an event as resolved typically
  /// means it should no longer be considered for processing by subscribers.
  void markAsResolved();
}
