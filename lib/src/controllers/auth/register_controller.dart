import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/components/auth/login_page.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/repositories/user_repository.dart';

class RegisterController extends GetxController {
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void register(GlobalKey<FormBuilderState> formKey) async {
    if (!formKey.currentState.saveAndValidate()) return;
    final data = formKey.currentState.value;
    if (data['password'] != data['confirm_password']) {
      Utils.error("Confirmation password doesn't match");
      return;
    }

    final String name = data['name'];
    final names = name.split(' ');
    data['firstName'] = names[0];

    data['lastName'] = names.length > 1 ? names[1] : '';

    loading.value = true;
    final res = await UserRepository.it.register(data);
    loading.value = false;

    if (res) {
      Get.offAllNamed(LoginPage.routeName);
      Utils.success(
        'Registration successful. Please check your email for confirmation link',
      );
    }
  }
}
