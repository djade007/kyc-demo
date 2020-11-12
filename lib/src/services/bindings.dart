import 'package:get/get.dart';
import 'package:kyc_demo/src/controllers/auth/auth_controller.dart';

class AppBindings implements Bindings {
  @override
  dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
