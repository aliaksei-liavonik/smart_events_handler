import 'package:rxdart/rxdart.dart';
import 'package:smart_events_handler/smart_events_handler.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegate/smart_event_gatherer_delegate.dart';

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
    _behaviorSubject = BehaviorSubject<_LazyEventWrapper?>();
    addDisposable(_behaviorSubject.close);
  }
  late final BehaviorSubject<_LazyEventWrapper?> _behaviorSubject;

  @override
  void add<Event extends GathererEvent>(Event event) {
    _behaviorSubject.add(_LazyEventWrapper(event: event));
  }

  @override
  Stream<Event> getEvents<Event extends GathererEvent>() {
    final initialEventWrapper = _behaviorSubject.valueOrNull;
    final initialEvent = initialEventWrapper?.event;

    if (initialEvent != null && initialEvent is Event) {
      return Rx.merge(
        [
          Stream.value(initialEvent),
          _behaviorSubject.stream.whereType<Event>(),
        ],
      );
    }

    return _behaviorSubject.stream.whereType<Event>();
  }

  @override
  void markAsResolved() {
    _behaviorSubject.valueOrNull?.markAsResolved();
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
