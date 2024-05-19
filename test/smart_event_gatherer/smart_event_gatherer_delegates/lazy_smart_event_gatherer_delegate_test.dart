import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegates/smart_event_gatherer_delegates.dart';

import '../../data.dart';

void main() {
  group('SmartEventGatherer', () {
    late LazySmartEventGathererDelegate<TestEvent> delegate;

    setUp(() {
      delegate = LazySmartEventGathererDelegate<TestEvent>();
    });

    tearDown(() async {
      await delegate.dispose();
    });

    test('Correctly receives and processes events from stream', () async {
      final expectedEvent = Test1Event();

      unawaited(
        expectLater(
          delegate.getEvents<Test1Event>(),
          emitsInOrder([expectedEvent]),
        ),
      );

      delegate.add(expectedEvent);
    });

    test('Correctly processes last event from with post registering', () async {
      final expectedEvent = Test1Event();

      delegate.add(expectedEvent);

      unawaited(
        expectLater(
          delegate.getEvents<Test1Event>(),
          emitsInOrder([expectedEvent]),
        ),
      );
    });

    test('Ignores the last event if it has been resolved', () async {
      final expectedEvent = Test1Event();

      delegate
        ..add(expectedEvent)
        ..markAsResolved();

      unawaited(
        expectLater(
          delegate.getEvents<Test1Event>(),
          emitsInOrder([]),
        ),
      );
    });

    test('Correctly filters events by type', () async {
      final irrelevantEvent = Test2Event();
      final relevantEvent = Test1Event();

      unawaited(
        expectLater(
          delegate.getEvents<Test1Event>(),
          emitsInOrder([relevantEvent]),
        ),
      );

      delegate
        ..add(irrelevantEvent)
        ..add(relevantEvent);
    });

    test('Correctly disposes resources', () async {
      expect(delegate.isDisposed, false);
      expect(delegate.behaviorSubject.isClosed, false);

      await delegate.dispose();

      expect(delegate.isDisposed, true);
      expect(delegate.behaviorSubject.isClosed, true);
    });
  });
}
