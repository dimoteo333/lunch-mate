import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class for debouncing function calls.
/// Useful for delaying execution until a pause in rapid events.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  /// Cancels any pending action and schedules a new one.
  /// After [delay] milliseconds with no new calls, [action] will execute.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Immediately executes and cancels any pending action.
  void flush() {
    _timer?.cancel();
    _timer = null;
  }

  /// Cancels any pending action without executing.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes the debouncer and releases resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
