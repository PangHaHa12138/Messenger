import 'http.dart';

/// 调用底层的request，重新提供get，post等方便方法

class HttpUtils {
  static HttpRequest httpRequest = HttpRequest();

  /// get
  static Future get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.get,
      queryParameters: queryParameters,
      headers: headers,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }

  /// post
  static Future post({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.post,
      data: data,
      headers: headers,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }

  static Future delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.delete,
      data: data,
      headers: headers,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }

  static Future put({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.put,
      data: data,
      headers: headers,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }

  static Future patch({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.patch,
      data: data,
      headers: headers,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }

  static Future head({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.head,
      data: data,
      headers: headers,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }
}
