import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:smart_events_handler/src/utils/disposable.dart';

/// Callback definition for handling received events of type [Event].
///
/// This callback function is used to define actions that should be taken
/// when an event is received. It must be implemented to handle the event.
typedef OnSmartEventReceived<Event> = Future<void> Function(
  Event event,
);

/// A class responsible for gathering and managing events of type [Event].
///
/// This class listens to a provided [Stream<Event>] and allows consumers
/// to listen to and handle specific types of events. It also implements
/// the [Disposable] mixin for resource management.
///
/// Use [onType<T>] to listen for events of a specific type. The
/// [markAsResolved] method can be used to clear the current event state.
final class SmartEventGatherer<Event extends Object> with Disposable {
  /// Initializes the event gatherer with the provided [eventsStream].
  ///
  /// The [eventsStream] is listened to, and events are dispatched to
  /// the [_behaviorSubject] for further consumption. The stream subscription
  /// is managed as a disposable resource.
  SmartEventGatherer(Stream<Event> eventsStream) {
    addDisposable(
      eventsStream.listen(_behaviorSubject.add).cancel,
    );
  }

  /// A [BehaviorSubject] from `rxdart` that manages the stream of events.
  ///
  /// This subject acts as the central hub for all events of type [Event] that the gatherer is keeping.
  /// It retains the last event, allowing new subscribers to immediately receive the current state upon subscription.
  /// Use [onType] to filter events by specific types, and [markAsResolved] to reset the current event state.
  final _behaviorSubject = BehaviorSubject<Event?>();

  /// Gets the last event of type [Event] that was dispatched to the gatherer.
  ///
  /// If no event has been dispatched or if the last event has been marked as resolved,
  /// this returns `null`.
  Event? get lastEvent => _behaviorSubject.valueOrNull;

  /// Returns a stream of events of type [T], allowing for type-specific event handling.
  ///
  /// This method filters events by type [T], enabling consumers to subscribe to
  /// and handle only the events of interest.
  Stream<T> onType<T extends Event>() {
    return _behaviorSubject.whereType<T>();
  }

  /// Marks the current event as resolved, clearing the state.
  ///
  /// This method can be used to reset the event state, effectively marking
  /// the current event as handled and preventing further actions on it.
  void markAsResolved() => _behaviorSubject.add(null);
}
