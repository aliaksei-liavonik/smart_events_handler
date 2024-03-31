import 'dart:async';

import 'package:meta/meta.dart';

/// Callback that used by [Disposable] to store function to dispose resources,
/// when the [Disposable.dispose] method is called.
@internal
typedef DisposableCallback = FutureOr<void> Function();

/// Mixin that helps to dispose resources.
@internal
mixin Disposable {
  final List<DisposableCallback> _disposableCallbacks = [];

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @protected
  void addDisposable(DisposableCallback disposableCallback) =>
      _disposableCallbacks.add(disposableCallback);

  @mustCallSuper
  Future<void> dispose() async {
    final future =
        Future.wait(_disposableCallbacks.map((e) async => await e()));
    _disposableCallbacks.clear();
    await future;
    _isDisposed = true;
  }
}
