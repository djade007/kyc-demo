import 'package:get/get.dart';
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
}
