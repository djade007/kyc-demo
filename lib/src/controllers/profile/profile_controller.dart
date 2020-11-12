import 'package:flutter_form_builder/src/form_builder.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final loading = false.obs;

  void refresh() async {
    loading.value = true;

    await UserRepository.it.refreshData(Application.auth.token);

    loading.value = false;
  }

  void verifyBVN(GlobalKey<FormBuilderState> formKey) {

  }
}
