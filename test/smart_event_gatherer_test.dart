import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_events_handler/src/smart_event_gatherer.dart';

import 'data.dart';

void main() {
  group('SmartEventGatherer Tests', () {
    late StreamController<TestEvent> eventStreamController;
    late SmartEventGatherer<TestEvent> eventGatherer;

    setUp(() {
      eventStreamController = StreamController<TestEvent>.broadcast();
      eventGatherer =
          SmartEventGatherer<TestEvent>(eventStreamController.stream);
    });

    tearDown(() async {
      await eventStreamController.close();
      await eventGatherer.dispose();
    });

    test('Correctly receives and processes events from stream', () async {
      final expectedEvent = Test1Event();
      unawaited(
        expectLater(
          eventGatherer.onType<Test1Event>(),
          emitsInOrder([expectedEvent]),
        ),
      );

      eventStreamController.add(expectedEvent);
    });

    test('Correctly filters events by type', () async {
      final irrelevantEvent = Test2Event();
      final relevantEvent = Test1Event();

      unawaited(
        expectLater(
          eventGatherer.onType<Test1Event>(),
          emitsInOrder([relevantEvent]),
        ),
      );

      eventStreamController
        ..add(irrelevantEvent)
        ..add(relevantEvent);
    });
  });
}
