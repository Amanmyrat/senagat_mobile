import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:senagat_mobile/src/core/networking/interceptors/account_blocked_interceptor.dart';
import 'networking/interceptors/refresh_token_interceptor.dart';
import 'networking/api_endpoint.dart';
import 'networking/api_service.dart';
import 'networking/dio_service.dart';
import 'networking/interceptors/api_interceptor.dart';
import 'networking/interceptors/logging_interceptor.dart';
import 'dart:io';

class Configs {
  const Configs._();

  static const host = 'senagatbank.com.tm';
  static const baseUrl = "https://$host/api/v1";
  static const baseImageUrl = "https://$host/";

  static const bool OTPEnabled = false;

}

class ApiServices {
  const ApiServices._();

  static const _cache = ApiServices._();

  factory ApiServices() => _cache;

  static final _baseOptions = BaseOptions(
    baseUrl: ApiEndpoint.baseUrl,
  );

  static final _dio = Dio(_baseOptions)
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();

        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {

          // Only apply to your domain
          if (host != Configs.host) return false;

          // Convert certificate DER to SHA256 fingerprint
          final bytes = cert.der;
          final sha256Result = sha256.convert(bytes).toString().toUpperCase();

          const expectedFingerprint =
              "7B4F46E8D9EC05D63D3EB360D462231C2171A59C0140B438DB71FBB5617EE387";

          return sha256Result == expectedFingerprint.toUpperCase();
        };

        return client;
      },
    );


  static final _dioService = DioService(
    dioClient: _dio,
    interceptors: [
      ApiInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
      RefreshTokenInterceptor(dioClient: _dio),
      AccountBlockedInterceptor(dioClient: _dio),
    ],
  );
  static final apiService = ApiService(_dioService);
}
