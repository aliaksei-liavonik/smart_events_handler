/// Extends objects with the ability to apply a function to themselves and return a result.
extension ApplyEx<T extends Object> on T {
  /// Applies the [func] function to this object and returns the result.
  U apply<U>(U Function(T) func) {
    return func(this);
  }
}
