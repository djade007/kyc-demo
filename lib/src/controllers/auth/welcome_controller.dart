import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/components/auth/register_page.dart';
import 'package:kyc_demo/src/components/profile/profile_page.dart';
import 'package:kyc_demo/src/init.dart';

class WelcomeController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    if (Application.auth.logged)
      Get.toNamed(ProfilePage.routeName);
    else
      Get.toNamed(RegisterPage.routeName);
  }
}
