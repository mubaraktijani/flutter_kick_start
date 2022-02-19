import 'package:dio/dio.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';

import 'interceptor.dart';

abstract class AppService {
	
	Dio get http {
		Dio dio = new Dio();

		FlutterKickStart config = getIt<FlutterKickStart>();

		if (config.baseUrl != null) {
			dio.options.baseUrl = config.baseUrl!;
		}

		dio.options.connectTimeout = config.connectTimeout;
		dio.options.receiveTimeout = config.receiveTimeout;

		dio.interceptors.add(AppHttpInterceptor());
		

		return dio;
	}
}