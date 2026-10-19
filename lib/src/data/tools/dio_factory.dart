import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:logarte/logarte.dart';

import '../../config/constants/env_constant.dart';

Dio getDio(String baseUrl, {Logarte? logarte}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  if (EnvConstants.showHttpLogs) {
    dio.interceptors.add(AwesomeDioInterceptor());
    if (logarte != null) {
      dio.interceptors.add(LogarteDioInterceptor(logarte));
    }
  }

  return dio;
}
