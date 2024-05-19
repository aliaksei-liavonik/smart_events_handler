import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegates/smart_event_gatherer_delegate_interface.dart';

/// A default implementation of [ISmartEventGathererDelegate].
///
/// This class uses a [StreamController] to manage the stream of events. It allows for
/// adding events to the stream and retrieving a stream of unhandled events of a specific type.
/// The [markAsResolved] method in this default implementation is left empty, providing a
/// placeholder for custom logic in subclasses or alternative implementations.
class SmartEventGathererDelegate<GathererEvent extends Object>
    extends ISmartEventGathererDelegate<GathererEvent> {
  /// Creates new instance of [SmartEventGathererDelegate] with broadcasted
  /// [eventsController].
  SmartEventGathererDelegate() {
    eventsController = StreamController<GathererEvent?>.broadcast();
    addDisposable(eventsController.close);
  }

  /// [StreamController] to manage the stream of events
  @visibleForTesting
  late final StreamController<GathererEvent?> eventsController;

  @override
  void add<Event extends GathererEvent>(Event event) {
    eventsController.add(event);
  }

  @override
  Stream<Event> getEvents<Event extends GathererEvent>() {
    return eventsController.stream.whereType<Event>();
  }

  @override
  void markAsResolved() {}
}
