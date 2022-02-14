import 'package:dio/dio.dart';

abstract class Service {

	String get baseUrl;
	
	Dio get http {
		Dio dio = new Dio();

		dio.options.baseUrl = baseUrl;
		dio.options.connectTimeout = 20000;
		dio.options.receiveTimeout = 20000;

		return dio;
	}
}