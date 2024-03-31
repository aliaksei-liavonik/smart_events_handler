# Smart Events Handler

A Flutter package designed to simplify event handling across your entire app. `smart_events_handler` allows you to manage and respond to events in a decoupled and efficient manner, making your code cleaner and more maintainable.

## Features

- **Type-Safe Event Handling**: Work with any event type with compile-time checks.
- **Flexible Event Listening**: Easily listen for and handle specific events anywhere in your widget tree.
- **Automatic Event Disposal**: Events are automatically cleaned up to prevent memory leaks.
- **Support for Multiple Event Types**: Handle different types of events with the same handler, allowing for flexible event management strategies.

## Installation

Add `smart_events_handler` to your `pubspec.yaml` file:

```yaml
dependencies:
  smart_events_handler: ^1.0.0
```

Then run `flutter pub get` to install the package.

## Usage

### Setting up the Event Gatherer

Wrap your app (or a part of your app) with `SmartEventGathererProvider` to start gathering events. You can optionally specify a delegate for custom event handling strategies, including lazy event handling:

```dart
SmartEventGathererProvider<MyEvent>(
  eventStream: myEventStream,
  // Optional: Provide a custom delegate for advanced event handling.
  // For lazy event handling, you can use LazySmartEventGathererDelegate.
  delegate: MyCustomEventDelegate(),
  child: MyApp(),
);
```

### Handling Events

Use `SmartEventHandler` within your widget tree to listen for and handle specific events. This widget will react to events of the type specified and allow you to define custom handling logic:

```dart
SmartEventHandler<MySpecificEvent, GathererEvent>(
  onSmartEventReceived: (event) {
    // Custom logic to handle the event
  },
  child: MyWidget(),
);
```

### Dispatching Events

Events can be dispatched using the event stream provided to the `SmartEventGathererProvider`. This allows any part of your app to emit events that can be handled by registered event handlers:

```dart
myEventStreamController.add(MySpecificEvent());
```

### Customizing Event Handling with Delegates

The package supports custom event-handling strategies through delegates. You can implement your delegate by extending `ISmartEventGathererDelegate` or use `LazySmartEventGathererDelegate` for lazy event handling:

```dart
class MyCustomEventDelegate extends ISmartEventGathererDelegate<MyEvent> {
  @override
  void add(MyEvent event) {
    // Custom logic to add events
  }

  @override
  Stream<T> getEvents<T extends MyEvent>() {
    // Custom logic to filter and provide events
  }

  @override
  void markAsResolved() {
    // Custom logic to mark events as resolved
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
