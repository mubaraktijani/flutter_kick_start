import 'dart:convert';

import 'package:dio/dio.dart';

class AppHttpInterceptor extends Interceptor {

	@override
	Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
		print('REQUEST[${options.method}] => PATH: ${options.path}?${options.data}');
		return super.onRequest(options, handler);
	}

	@override
	Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {

		if (response.statusCode! >= 400) {
			throw DioError(
				requestOptions: response.requestOptions, 
				response: response,
				type: DioErrorType.response,
				error: response.data
			);
		}

		print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
		return super.onResponse(response, handler);
	}
	
	@override
	void onError(DioError dioError, ErrorInterceptorHandler handler) {
		print('ERROR[${dioError.response?.statusCode}] => PATH: ${dioError.error}');

		switch (dioError.type) {
			case DioErrorType.cancel:
				dioError.error = "Request to API server was cancelled";
				break;

			case DioErrorType.connectTimeout:
				dioError.error = "Connection timeout with API server";
				break;

			case DioErrorType.other:
				dioError.error = "Connection to API server failed due to internet connection";
				break;

			case DioErrorType.receiveTimeout:
				dioError.error = "Receive timeout in connection with API server";
				break;

			case DioErrorType.response: 
				break;

			case DioErrorType.sendTimeout:
				dioError.error = "Request timeout with API server";
				break;
		}

		return super.onError(dioError, handler);
	}
}