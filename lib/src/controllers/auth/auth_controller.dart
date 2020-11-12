import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/models/user.dart';

class AuthController extends GetxController {
  final _token = ''.obs;
  final _user = User().obs;

  String get token => _token.string;

  bool get logged => token.isNotEmpty;

  User get user => _user.value;

  @override
  void onInit() {
    super.onInit();

    _token.value = Application.box.get(Keys.token, defaultValue: '');
    _user.value = User.fromMap(Application.box.get(Keys.user));
  }

  void onLoggedIn(String newToken, Map<String, dynamic> newUser) {
    _token.value = newToken;
    _user.value = User.fromMap(newUser);

    Application.box.put(Keys.token, newToken);
    Application.box.put(Keys.user, newUser);
  }

  void clear() {
    _user.value = User();
    _token.value = '';
  }
}
