import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/components/profile/profile_page.dart';
import 'package:kyc_demo/src/repositories/user_repository.dart';

class LoginController extends GetxController {
  final loading = false.obs;

  void login(GlobalKey<FormBuilderState> formKey) async {
    print('here');
    if (!formKey.currentState.saveAndValidate()) return;
    final data = formKey.currentState.value;

    loading.value = true;
    final res = await UserRepository.it.login(data);
    if (res) {
      Get.toNamed(ProfilePage.routeName);
    }
    loading.value = false;
  }
}
