import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  GlobalKey<FormBuilderState> formKey;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormBuilderState>();
  }

  void login() {
    print('here');
    if (!formKey.currentState.saveAndValidate()) return;
    final data = formKey.currentState.value;
    print(data);
  }
}
