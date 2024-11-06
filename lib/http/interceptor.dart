import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    /// 根据DioError创建HttpException
    HttpException httpException = HttpException.create(err);

    /// dio默认的错误实例，如果是没有网络，只能得到一个未知错误，无法精准的得知是否是无网络的情况
    /// 这里对于断网的情况，给一个特殊的code和msg
    if (err.type == DioErrorType.other) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        httpException = HttpException(code: -100, msg: 'None Network.');
      }
    }

    /// 将自定义的HttpException
    err.error = httpException;

    /// 调用父类，回到dio框架
    super.onError(err, handler);
  }
}

//
class HttpException implements Exception {
  final int code;
  final String msg;

  HttpException({
    this.code = -1,
    this.msg = 'unKnow error',
  });

  @override
  String toString() {
    return 'Error (code: $code): $msg';
  }

  factory HttpException.create(DioError error) {
    /// dio异常
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return HttpException(code: -1, msg: 'request cancel');
        }
      case DioErrorType.connectTimeout:
        {
          return HttpException(code: -1, msg: 'connect timeout');
        }
      case DioErrorType.sendTimeout:
        {
          return HttpException(code: -1, msg: 'send timeout');
        }
      case DioErrorType.receiveTimeout:
        {
          return HttpException(code: -1, msg: 'receive timeout');
        }
      case DioErrorType.response:
        {
          try {
            int statusCode = error.response?.statusCode ?? 0;
            switch (statusCode) {
              case 400:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'Request syntax error');
                }
              case 401:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'Without permission');
                }
              case 403:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'Server rejects execution');
                }
              case 404:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'Unable to connect to server');
                }
              case 405:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'The request method is disabled');
                }
              case 500:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'Server internal error');
                }
              case 502:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'Invalid request');
                }
              case 503:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'The server is down.');
                }
              case 505:
                {
                  if (error.response?.data is Map<String, dynamic>) {
                    Map<String, dynamic>? data = error.response?.data;
                    if (data != null) {
                      if (data['errorMessage'] != null) {
                        String msg = data['errorMessage'];
                        return HttpException(code: statusCode, msg: msg);
                      }
                    }
                  }
                  return HttpException(
                      code: statusCode, msg: 'HTTP requests are not supported');
                }
              default:
                {
                  return HttpException(
                      code: statusCode,
                      msg: error.response?.statusMessage ?? 'unKnow error');
                }
            }
          } on Exception catch (_) {
            return HttpException(code: -1, msg: 'unKnow error');
          }
        }
      default:
        {
          return HttpException(code: -1, msg: error.message);
        }
    }
  }
}
