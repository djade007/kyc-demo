import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kyc_demo/src/controllers/profile/profile_controller.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/widgets/button.dart';

class PassportModal extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Passport verification',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ).space(),
        Obx(_buildForm),
      ],
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              readOnly: controller.loading.value,
              attribute: 'bvn',
              decoration: Utils.decoration('BVN Number'),
              validators: [
                FormBuilderValidators.required(),
              ],
            ).space(bottom: 20),
            FormBuilderDateTimePicker(
              inputType: InputType.date,
              attribute: 'dob',
              readOnly: controller.loading.value,
              decoration: Utils.decoration('Date of Birth'),
            ).space(bottom: 20),
            SizedBox(
              width: 150,
              child: AppButton(
                title: controller.loading.value ? 'Loading...' : 'Confirm',
                onPressed: controller.loading.value
                    ? null
                    : () {
                        controller.verifyBVN(formKey);
                      },
              ),
            ).right(),
          ],
        ),
      ),
    );
  }
}
