import 'package:smart_events_handler/src/utils/disposable.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Disposable',
    () {
      test('disposes all added disposables after dispose is called', () async {
        var counter = 0;
        final disposable = _DisposableClass(
          disposeCallbacks: [
            () {
              counter += 1;
            },
            () {
              counter += 1;
            }
          ],
        );
        expect(counter, 0);
        expect(disposable.isDisposed, false);
        await disposable.dispose();
        expect(counter, 2);
        expect(disposable.isDisposed, true);
      });

      test('second call of dispose does nothing', () async {
        var counter = 0;
        final disposable = _DisposableClass(
          disposeCallbacks: [
            () {
              counter += 1;
            },
          ],
        );
        expect(counter, 0);
        expect(disposable.isDisposed, false);
        await disposable.dispose();
        expect(counter, 1);
        expect(disposable.isDisposed, true);
        await disposable.dispose();
        expect(counter, 1);
        expect(disposable.isDisposed, true);
      });
    },
  );
}

class _DisposableClass with Disposable {
  _DisposableClass({
    required List<DisposableCallback> disposeCallbacks,
  }) {
    disposeCallbacks.forEach(addDisposable);
  }
}
