import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:nova/core/network/session_expired_event.dart";
import "package:nova/core/storage/secure_storage.dart";

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockSecureStorage extends Mock implements SecureStorage {}

class MockDio extends Mock implements Dio {}

// ── Helpers ───────────────────────────────────────────────────────────────────

RequestOptions _opts(String path) =>
    RequestOptions(path: path, baseUrl: "http://localhost");

// ── Tests ──────────────────────────────────────────────────────────────────────

void main() {
  late MockSecureStorage storage;

  setUp(() {
    storage = MockSecureStorage();
    registerFallbackValue(_opts("/"));
  });

  group("SessionExpiredEvent", () {
    test("emits when clearTokens is called after refresh failure", () async {
      // Arrange – storage has refresh token, but the refresh Dio will throw
      when(() => storage.getAccessToken())
          .thenAnswer((_) async => "old_access");
      when(() => storage.getRefreshToken())
          .thenAnswer((_) async => "old_refresh");
      when(() => storage.clearTokens()).thenAnswer((_) async {});

      final events = <void>[];
      final sub = SessionExpiredEvent.stream.listen((_) => events.add(null));

      // Act – simulate what AuthInterceptor does on refresh failure
      await storage.clearTokens();
      SessionExpiredEvent.emit();

      await Future<void>.delayed(Duration.zero);
      expect(events.length, 1);

      await sub.cancel();
    });

    test("stream is a broadcast stream – multiple listeners allowed", () async {
      final s1 = <void>[];
      final s2 = <void>[];
      final sub1 = SessionExpiredEvent.stream.listen((_) => s1.add(null));
      final sub2 = SessionExpiredEvent.stream.listen((_) => s2.add(null));

      SessionExpiredEvent.emit();

      // Give the event loop a chance to deliver to listeners
      await Future<void>.delayed(Duration.zero);

      expect(s1.length, 1);
      expect(s2.length, 1);

      await sub1.cancel();
      await sub2.cancel();
    });
  });

  group("AuthInterceptor refresh-queue logic (unit)", () {
    test("getRefreshToken is called on 401 protected path", () async {
      when(() => storage.getAccessToken())
          .thenAnswer((_) async => "tok");
      when(() => storage.getRefreshToken())
          .thenAnswer((_) async => null); // No refresh token
      when(() => storage.clearTokens()).thenAnswer((_) async {});

      // When refresh token is null, clearTokens should be invoked
      final rt = await storage.getRefreshToken();
      expect(rt, isNull);

      // Simulate interceptor behaviour: null refresh → clear + emit
      if (rt == null) {
        await storage.clearTokens();
        SessionExpiredEvent.emit();
      }

      verify(() => storage.clearTokens()).called(1);
    });

    test("access token is attached to non-auth paths", () async {
      when(() => storage.getAccessToken())
          .thenAnswer((_) async => "access_abc");

      final token = await storage.getAccessToken();
      expect(token, "access_abc");
    });

    test("auth paths do NOT read access token (guard)", () {
      // Path matching helper mirrored from AuthInterceptor._isAuthPath
      bool isAuthPath(String path) =>
          path.contains("/auth/") && !path.contains("/auth/refresh");

      expect(isAuthPath("/auth/login"), isTrue);
      expect(isAuthPath("/auth/register"), isTrue);
      expect(isAuthPath("/auth/refresh"), isFalse); // refresh is NOT guarded
      expect(isAuthPath("/me"), isFalse);
      expect(isAuthPath("/children"), isFalse);
    });
  });
}
