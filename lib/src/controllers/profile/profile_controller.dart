import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final loading = false.obs;
  final picker = ImagePicker();

  void refresh() async {
    loading.value = true;

    await UserRepository.it.refreshData(Application.auth.token);

    loading.value = false;
  }

  void verifyBVN(GlobalKey<FormBuilderState> formKey) async {
    if (!formKey.currentState.saveAndValidate()) return;
    final value = formKey.currentState.value;
    DateTime dob = value['dob'];

    final data = {
      'bvn': value['bvn'],
      'dob': '${dob.day}/${dob.month}/${dob.year}',
    };

    loading.value = true;
    final res = await UserRepository.it.updateBVN(data);
    if (res) {
      // close modal
      Get.back();
      Utils.success('BVN Verified Successfully');
    }
    loading.value = false;
  }

  void uploadPassport() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile == null) return;

    loading.value = true;
    final res = await UserRepository.it.uploadPassport(pickedFile.path);
    if (res) {
      // close modal
      Get.back();
      Utils.success('Passport Uploaded Successfully');
    }
    loading.value = false;
  }
}
