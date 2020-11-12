import 'package:dio/dio.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/init.dart';

class ApiClient {
  final Dio _dio;

  ApiClient([Dio dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://us-central1-kyc-damo.cloudfunctions.net/api/',
              ),
            );

  Future<Map> get(String path, {String accessToken}) async {
    Options options;

    if (accessToken != null) {
      print(accessToken);
      options = Options(headers: {'Access-Token': accessToken});
    }

    try {
      final res = await _dio.get(path, options: options);
      print(res.data);
      return res.data;
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  Future<Map> post(String path, Map<String, dynamic> data) async {
    print(data);
    try {
      final res = await _dio.post(path, data: data);
      print(res.data);
      return res.data;
    } on DioError catch (e) {
      return _handleError(e);
    }
  }
}

dynamic _handleError(DioError e) {
  print(e);
  print(StackTrace.current);

  String message = 'An error occurred. Please try again later';

  if (e.response == null) {
    message = 'Could not establish secure connection to our servers. '
        'Please check your internet connection an try again.';
    Utils.error(message);
    return null;
  }

  if (e.response.statusCode == 401) {
    Application.logout();
    return null;
  }

  if (e.response.data is Map && e.response.data['message'] != null) {
    message = e.response.data['message'];
  }

  Utils.error(message);
  return null;
}
