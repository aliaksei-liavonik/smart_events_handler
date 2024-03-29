import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:smart_events_handler/src/smart_event_gatherer.dart';
import 'package:smart_events_handler/src/smart_event_listener.dart';

/// A widget that responds to specific smart events of type [Event],
/// performing predefined actions as dictated by the [onSmartEventReceived]
/// callback.
///
/// Usage:
/// ```
/// SmartEventHandler<MyEvent, GathererEvent>(
///   onSmartEventReceived: (event) {
///     // Action to perform on event reception
///   },
///   child: MyWidget(),
/// );
/// ```
///
/// The type [GathererEvent] is explicitly required to ensure compatibility
/// with the corresponding [SmartEventGatherer] in the widget tree. This design
/// allows for multiple [SmartEventGathererProvider]s coexisting in the tree,
/// each catering to different event types. It's imperative to enclose
/// [SmartEventHandler] within a widget tree that includes a
/// [SmartEventGathererProvider] for the necessary [SmartEventGatherer],
/// facilitating precise and effective event handling across diverse contexts.

final class SmartEventHandler<Event extends GathererEvent,
    GathererEvent extends Object> extends HookWidget {
  const SmartEventHandler({
    super.key,
    required this.onSmartEventReceived,
    required this.child,
  });

  final Widget child;
  final OnSmartEventReceived<Event> onSmartEventReceived;

  @override
  Widget build(BuildContext context) {
    return SmartEventListener<Event, GathererEvent>(
      builder: (event) {
        useEffect(
          () {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (event != null) {
                  onSmartEventReceived(event);
                  context
                      .read<SmartEventGatherer<GathererEvent>>()
                      .markAsResolved();
                }
              },
            );
            return null;
          },
          [event],
        );

        return child;
      },
    );
  }
}
