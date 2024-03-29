import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_events_handler/smart_events_handler.dart';

import 'data.dart';

void main() {
  group('SmartEventHandler Widget Tests', () {
    late StreamController<TestEvent> eventsStreamController;
    late List<String> handledEvents;

    setUp(() {
      eventsStreamController = StreamController<TestEvent>.broadcast();
      handledEvents = [];
    });

    tearDown(() {
      eventsStreamController.close();
    });

    testWidgets('Ensure each SmartEventHandler handles its own event type',
        (WidgetTester tester) async {
      // Setup the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: SmartEventGathererProvider<TestEvent>(
            eventStream: eventsStreamController.stream,
            child: Column(
              children: [
                SmartEventHandler<Test1Event, TestEvent>(
                  onSmartEventReceived: (event) async {
                    handledEvents.add('Test1Event');
                  },
                  child: const SizedBox(),
                ),
                SmartEventHandler<Test2Event, TestEvent>(
                  onSmartEventReceived: (event) async {
                    handledEvents.add('Test2Event');
                  },
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      // Dispatch different types of events
      eventsStreamController.add(Test1Event());
      eventsStreamController.add(Test2Event());

      // Wait for the events to be handled
      await tester.pumpAndSettle();

      // Verify that each event was handled by its corresponding handler
      expect(handledEvents, contains('Test1Event'));
      expect(handledEvents, contains('Test2Event'));
      expect(handledEvents.length, 2);
    });
  });
}
