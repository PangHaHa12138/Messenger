import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

import 'interceptor.dart';
import 'options.dart';

class HttpRequest {
  // 单例模式使用Http类，
  static final HttpRequest _instance = HttpRequest._internal();

  factory HttpRequest() => _instance;

  static late final Dio dio;

  /// 内部构造方法
  HttpRequest._internal() {
    /// 初始化dio
    BaseOptions options = BaseOptions(
      connectTimeout: HttpOptions.connectTimeout,
      receiveTimeout: HttpOptions.receiveTimeout,
      sendTimeout: HttpOptions.sendTimeout,
      baseUrl: HttpOptions.baseUrl,
    );

    dio = Dio(options);

    /// 添加各种拦截器
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true));
  }

  /// 封装request方法
  Future request({
    required String path, //接口地址
    required HttpMethod method, //请求方式
    dynamic data, //数据
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool showLoading = true, //是否显示loading
    bool showErrorMessage = true, //是否显示 报错toast
  }) async {
    const Map methodValues = {
      HttpMethod.get: 'get',
      HttpMethod.post: 'post',
      HttpMethod.put: 'put',
      HttpMethod.delete: 'delete',
      HttpMethod.patch: 'patch',
      HttpMethod.head: 'head'
    };

    Options options = Options(
      method: methodValues[method],
      headers: headers,
    );

    try {
      if (showLoading) {
        EasyLoading.instance
          ..indicatorWidget = Lottie.asset(
            'assets/loading.json',
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          )
          ..contentPadding = const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          )
          ..loadingStyle = EasyLoadingStyle.custom
          ..boxShadow = <BoxShadow>[]
          ..textColor = Colors.white
          ..indicatorColor = Colors.white
          ..backgroundColor = Colors.white;

        EasyLoading.show();
      }
      Response response = await HttpRequest.dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      HttpException httpException = error.error;
      if (showErrorMessage) {
        String msg = httpException.toString();
        EasyLoading.instance
          ..loadingStyle = EasyLoadingStyle.dark
          ..contentPadding = const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          );
        EasyLoading.showToast(msg);
      }
    } finally {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    }
  }
}

enum HttpMethod {
  get,
  post,
  delete,
  put,
  patch,
  head,
}
