import 'package:dio/dio.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/services/api_client.dart';

class UserRepository {
  final client = ApiClient();

  UserRepository._();

  static UserRepository get it => UserRepository._();

  Future<bool> register(Map<String, dynamic> data) async {
    final res = await client.post('register', data);
    return res != null;
  }

  Future<bool> login(Map<String, dynamic> data) async {
    final res = await client.post('login', data);
    if (res == null) return false;

    final token = res['data']['accessToken'];
    final userRes = await client.get('me', accessToken: token);
    if (userRes == null) return false;
    return refreshData(token);
  }

  Future<bool> updateBVN(Map<String, dynamic> data) async {
    final auth = Application.auth;

    final res = await client.post(
      'verify-bvn',
      data,
      accessToken: auth.token,
    );

    if (res == null) return false;

    // update local data
    auth.updateUser(res['data']['user']);
    return true;
  }

  Future<bool> refreshData(String token) async {
    final userRes = await client.get('me', accessToken: token);
    if (userRes == null) return false;

    Application.auth.onLoggedIn(token, userRes['data']['user']);

    return true;
  }

  Future<bool> uploadPassport(String passport) async {
    final formData = FormData.fromMap({
      "passport": await MultipartFile.fromFile(passport),
    });
    final res = await client.postFormData(
      "/passport-verification",
      formData,
      accessToken: Application.auth.token,
    );

    if (res == null) return false;

    // update local data
    Application.auth.updateUser(res['data']['user']);
    return true;
  }
}

