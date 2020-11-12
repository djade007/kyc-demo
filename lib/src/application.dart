import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kyc_demo/src/components/auth/login_page.dart';
import 'package:kyc_demo/src/controllers/auth/auth_controller.dart';
import 'package:kyc_demo/src/init.dart';

class Application {
  static Box box;

  static AuthController get auth => Get.find();

  static Future<void> initialize() async {
    await Hive.initFlutter();
    box = await Hive.openBox('default');
  }

  static void logout() async {
    await Application.box.clear();
    Application.auth.clear();
    Get.offAllNamed(LoginPage.routeName);
  }
}
