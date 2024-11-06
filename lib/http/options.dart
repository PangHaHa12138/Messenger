// 超时时间
class HttpOptions {
  //地址域名前缀
  //static const String baseUrl = 'http://35.78.148.99:8080';
  //static const String baseUrl = 'http://8.140.253.71:21260';
  static const String baseUrl = 'http://whale-api-ecs-app-alb-stg-1913568722.ap-northeast-1.elb.amazonaws.com';


  //单位时间是ms
  static const int connectTimeout = 120000;
  static const int receiveTimeout = 120000;
  static const int sendTimeout = 120000;
}
