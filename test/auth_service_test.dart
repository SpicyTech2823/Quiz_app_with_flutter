import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/services/auth_service.dart';

void main() {
  test('login returns a friendly message when the request fails', () async {
    final service = AuthService(
      requestExecutor:
          (Uri uri, {Map<String, String>? headers, Object? body}) async {
            throw const SocketException('Connection refused');
          },
    );

    final result = await service.login(
      email: 'test@example.com',
      password: 'password123',
    );

    expect(result['success'], isFalse);
    expect(result['message'], contains('Unable to connect'));
  });
}
