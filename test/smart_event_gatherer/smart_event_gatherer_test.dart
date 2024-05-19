import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer.dart';
import 'package:smart_events_handler/src/smart_event_gatherer/smart_event_gatherer_delegates/smart_event_gatherer_delegates.dart';

import '../data.dart';

void main() {
  group('SmartEventGatherer', () {
    late StreamController<TestEvent> eventStreamController;
    late SmartEventGatherer<TestEvent> eventGatherer;
    late SmartEventGathererDelegate<TestEvent> delegate;

    setUp(() {
      eventStreamController = StreamController<TestEvent>.broadcast();
      delegate = SmartEventGathererDelegate();
      eventGatherer = SmartEventGatherer<TestEvent>(
        eventStreamController.stream,
        delegate: delegate,
      );
    });

    tearDown(() async {
      await eventStreamController.close();
      await eventGatherer.dispose();
    });

    test('Correctly disposes resources', () async {
      expect(eventGatherer.isDisposed, false);
      expect(delegate.isDisposed, false);
      expect(eventStreamController.hasListener, true);

      await eventGatherer.dispose();

      expect(eventGatherer.isDisposed, true);
      expect(delegate.isDisposed, true);
      expect(eventStreamController.hasListener, false);
    });
  });
}
