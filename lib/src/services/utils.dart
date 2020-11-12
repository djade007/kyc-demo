import 'package:get/get.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/components/profile/views/bvn_modal.dart';
import 'package:kyc_demo/src/components/profile/views/passport_modal.dart';
import 'package:kyc_demo/src/init.dart';

class Utils {
  static double height([double division = 1, double max]) {
    final height = Get.height / division;
    if (max != null && height > max) {
      return max;
    }
    return height;
  }

  static double width([double division = 1, double max]) {
    final width = Get.width / division;
    if (max != null && width > max) {
      return max;
    }
    return width;
  }

  static void error(message) {
    Get.snackbar(
      null,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void success(message) {
    Get.snackbar(
      null,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  static InputDecoration decoration(
    String label, {
    bool disabled: false,
    Widget prefix,
    Widget suffix,
    String hint,
    bool long: false,
  }) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: Colors.black.withOpacity(.2),
      ),
      borderRadius: BorderRadius.circular(7),
    );

    return InputDecoration(
      labelText: label,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: Get.theme.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: disabled ? Colors.grey.withOpacity(.3) : Colors.white,
      filled: true,
      prefixIcon: prefix,
      suffixIcon: suffix,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12),
      labelStyle: TextStyle(fontSize: 12),
    );
  }

  static void kycModal() {
    final user = Application.auth.user;
    final nextLevel = user.level + 1;
    if (nextLevel > 2) {
      return;
    }
    Widget modal = SizedBox();

    if (nextLevel == 1) {
      modal = BvnModal();
    }

    if (nextLevel == 2) {
      modal = PassportModal();
    }

    Get.bottomSheet(
      Container(
        height: Utils.height(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 20,
              ),
              height: 6,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: modal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
