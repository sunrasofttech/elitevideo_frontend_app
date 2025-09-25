import 'dart:math';
import 'package:dio/dio.dart';
import 'package:elite/constant/app_urls.dart';

/*To Call the Base Url With Dio */
class Repository {
  Dio dio = Dio();
  init() {
    dio.options.baseUrl = AppUrls.baseUrl;
    log(
      dio.options.hashCode,
    );
  }

  Dio get sendRequest => dio;
}
