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

  Future<bool> refreshData(String token) async {
    final userRes = await client.get('me', accessToken: token);
    if (userRes == null) return false;

    Application.auth.onLoggedIn(token, userRes['data']['user']);

    return true;
  }
}
