import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/init.dart';

class RegisterController extends GetxController {
  GlobalKey<FormBuilderState> formKey;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormBuilderState>();
  }

  void register() {
    if (!formKey.currentState.saveAndValidate()) return;
    final data = formKey.currentState.value;
    if (data['password'] != data['confirm_password']) {
      Utils.error("Confirmation password doesn't match");
      return;
    }
    print(data);
  }
}
