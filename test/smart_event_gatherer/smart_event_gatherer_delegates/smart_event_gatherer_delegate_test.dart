import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegates/smart_event_gatherer_delegate.dart';

import '../../data.dart';

void main() {
  group('SmartEventGatherer', () {
    late SmartEventGathererDelegate<TestEvent> delegate;

    setUp(() {
      delegate = SmartEventGathererDelegate<TestEvent>();
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

      delegate.eventsController.add(expectedEvent);
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

      delegate.eventsController
        ..add(irrelevantEvent)
        ..add(relevantEvent);
    });

    test('Correctly disposes resources', () async {
      expect(delegate.isDisposed, false);
      expect(delegate.eventsController.isClosed, false);

      await delegate.dispose();

      expect(delegate.isDisposed, true);
      expect(delegate.eventsController.isClosed, true);
    });
  });
}
