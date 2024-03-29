import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:smart_events_handler/src/utils/disposable.dart';

typedef OnSmartEventReceived<Event> = Future<void> Function(
  Event event,
);

final class SmartEventGatherer<Event extends Object> with Disposable {
  Future<void> init(Stream<Event> deeplinkStream) async {
    addDisposable(
      deeplinkStream.listen(behaviorSubject.add).cancel,
    );
  }

  Stream<T> onType<T extends Event>() {
    return behaviorSubject.whereType<T>();
  }

  void markAsResolved() => behaviorSubject.add(null);

  final behaviorSubject = BehaviorSubject<Event?>();
  Event? get lastEvent => behaviorSubject.valueOrNull;
}
