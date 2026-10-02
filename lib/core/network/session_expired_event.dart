import "dart:async";

/// Broadcast stream that emits a single event whenever the auth session
/// expires (refresh token invalid / revoked).
final class SessionExpiredEvent {
  SessionExpiredEvent._();

  static final _controller = StreamController<void>.broadcast();

  static Stream<void> get stream => _controller.stream;

  static void emit() => _controller.add(null);
}
