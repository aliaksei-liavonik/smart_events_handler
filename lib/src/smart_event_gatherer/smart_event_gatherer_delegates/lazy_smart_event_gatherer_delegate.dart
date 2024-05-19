import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_events_handler/smart_events_handler.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegates/smart_event_gatherer_delegate_interface.dart';

/// A delegate that implements lazy event handling logic for [GathererEvent]s.
///
/// This delegate extends [ISmartEventGathererDelegate] to provide functionality
/// for handling events lazily. It maintains a stream of events and ensures that
/// events can be processed even after they have been emitted, supporting scenarios
/// where the last emitted event needs to be handled after some delay or conditionally.
class LazySmartEventGathererDelegate<GathererEvent extends Object>
    extends ISmartEventGathererDelegate<GathererEvent> {
  /// Creates new instance of [LazySmartEventGathererDelegate].
  LazySmartEventGathererDelegate() {
    behaviorSubject = BehaviorSubject<_LazyEventWrapper<GathererEvent>?>();
    addDisposable(behaviorSubject.close);
  }

  /// [BehaviorSubject] to manage the stream of events
  @visibleForTesting
  late final BehaviorSubject<_LazyEventWrapper<GathererEvent>?> behaviorSubject;

  @override
  void add<Event extends GathererEvent>(Event event) {
    behaviorSubject.add(_LazyEventWrapper<Event>(event: event));
  }

  @override
  Stream<Event> getEvents<Event extends GathererEvent>() {
    final initialEventWrapper = behaviorSubject.valueOrNull;
    final initialEvent = initialEventWrapper?.event;

    if (initialEventWrapper != null &&
        !initialEventWrapper.handled &&
        initialEvent != null &&
        initialEvent is Event) {
      return Rx.merge(
        [
          Stream.value(initialEvent),
          behaviorSubject.stream
              .whereType<_LazyEventWrapper<Event>>()
              .map((event) => event.event),
        ],
      );
    }

    return behaviorSubject.stream
        .whereType<_LazyEventWrapper<Event>>()
        .map((event) => event.event);
  }

  @override
  void markAsResolved() {
    behaviorSubject.valueOrNull?.markAsResolved();
  }
}

class _LazyEventWrapper<Event extends Object> {
  _LazyEventWrapper({
    required this.event,
    this.handled = false,
  });

  final Event event;
  bool handled;

  void markAsResolved() => handled = true;
}
