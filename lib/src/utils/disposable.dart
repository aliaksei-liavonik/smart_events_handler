import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef DisposableCallback = FutureOr<void> Function();

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

T useDisposable<T extends Disposable>(T Function() valueBuilder) {
  final value = useMemoized(valueBuilder);

  useEffect(() => value.dispose, []);

  return value;
}
