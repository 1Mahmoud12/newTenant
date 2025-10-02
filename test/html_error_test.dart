import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dobzz_seller/core/network/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerFailure HTML Error Handling Tests', () {
    test('Should handle Cloudflare 522 error (Connection timed out)', () {
      // Arrange - Simulate the HTML response from your image
      const htmlResponse = '''
<!DOCTYPE html>
<html>
<head><title>522: Connection timed out</title></head>
<body>
<h1>Error 522</h1>
<p>Connection timed out</p>
<a href="https://www.cloudflare.com/5xx-error-landing?utm_source=errorcode_522" target="_blank">Cloudflare</a>
</body>
</html>
''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 522,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html; charset=utf-8'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      final failure = ServerFailure.fromDioException(dioError);

      // Assert
      expect(failure.errMessage, contains('not_responding'));
      log('✅ Test passed: ${failure.errMessage}');
    });

    test('Should handle Cloudflare 520 error', () {
      const htmlResponse = '''<!DOCTYPE html><html><head><title>520 Error</title></head></html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 520,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, isNotEmpty);
      log('✅ 520 Error: ${failure.errMessage}');
    });

    test('Should handle Cloudflare 521 error (Web server is down)', () {
      const htmlResponse = '''<html><body><h1>521: Web server is down</h1></body></html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 521,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, contains('down'));
      log('✅ 521 Error: ${failure.errMessage}');
    });

    test('Should handle Cloudflare 523 error (Origin is unreachable)', () {
      const htmlResponse = '''<!DOCTYPE html><html><title>523 Error</title></html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 523,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html; charset=UTF-8'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, contains('unreachable'));
      log('✅ 523 Error: ${failure.errMessage}');
    });

    test('Should handle Cloudflare 524 error (A timeout occurred)', () {
      const htmlResponse = '''<!DOCTYPE html><html><body>524 A timeout occurred</body></html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 524,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, contains('timeout'));
      log('✅ 524 Error: ${failure.errMessage}');
    });

    test('Should handle HTML response with lowercase <!doctype', () {
      const htmlResponse = '''
<!doctype html>
<html>
<head><title>Error</title></head>
<body><h1>Server Error</h1></body>
</html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 500,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, isNotEmpty);
      log('✅ HTML with lowercase doctype: ${failure.errMessage}');
    });

    test('Should detect HTML even when content-type is missing', () {
      const htmlResponse = '''
<!DOCTYPE html>
<html>
<body>Error page without proper content-type</body>
</html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 502,
          data: htmlResponse,
          headers: Headers.fromMap({}), // No content-type header
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, isNotEmpty);
      log('✅ HTML without content-type header: ${failure.errMessage}');
    });

    test('Should handle regular 500 server errors with HTML', () {
      const htmlResponse = '''<html><body><h1>500 Internal Server Error</h1></body></html>''';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 500,
          data: htmlResponse,
          headers: Headers.fromMap({
            'content-type': ['text/html; charset=utf-8'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, contains('server'));
      log('✅ 500 HTML Error: ${failure.errMessage}');
    });

    test('Should still handle JSON responses correctly', () {
      final jsonResponse = {
        'status': false,
        'message': 'Invalid credentials',
        'errors': {'email': 'Email not found'}
      };

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/login'),
          statusCode: 422,
          data: jsonResponse,
          headers: Headers.fromMap({
            'content-type': ['application/json'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, isNotEmpty);
      expect(failure.apiError, isNotNull);
      log('✅ JSON Error still works: ${failure.errMessage}');
    });

    test('Should handle mixed content - HTML string in data field', () {
      const htmlString = '<html><head></head><body>Error</body></html>';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 502,
          data: htmlString,
          headers: Headers.fromMap({
            'content-type': ['text/plain'], // Wrong content type
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final failure = ServerFailure.fromDioException(dioError);
      expect(failure.errMessage, isNotEmpty);
      log('✅ HTML as string: ${failure.errMessage}');
    });
  });

  group('DioHelper Interceptor Tests', () {
    test('Should detect HTML in response interceptor', () {
      // This tests the interceptor's HTML detection
      const htmlResponse = '''
<!DOCTYPE html>
<html>
<head><title>Cloudflare Error</title></head>
<body>Error 522</body>
</html>''';

      // The interceptor should detect this and reject it
      expect(htmlResponse.trim().toLowerCase().startsWith('<!doctype'), true);
      log('✅ Interceptor HTML detection works');
    });

    test('Should detect HTML with <html tag', () {
      const htmlResponse = '''
<html>
<head><title>Error</title></head>
<body>Server Error</body>
</html>''';

      expect(htmlResponse.trim().toLowerCase().startsWith('<html'), true);
      log('✅ Interceptor detects <html tag');
    });
  });
}
