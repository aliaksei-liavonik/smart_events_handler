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

Wrap your app (or a part of your app) with `SmartEventGathererProvider` to start gathering events:

```dart
SmartEventGathererProvider<MyEvent>(
  eventStream: myEventStream,
  child: MyApp(),
);
```

### Handling Events

Use `SmartEventHandler` to handle specific events:

```dart
SmartEventHandler<MySpecificEvent, GathererEvent>(
  onSmartEventReceived: (event) {
    // Handle the event
  },
  child: MyWidget(),
);
```

### Dispatching Events

To dispatch events, use your event stream:

```dart
myEventStreamController.add(MySpecificEvent());
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
