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
        top: 30,
      ),
      child: Material(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: controller.loading.value ? null : controller.uploadPassport,
          child: SizedBox(
            width: 200,
            height: 200,
            child: controller.loading.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator().space(),
                      Text(
                        'Uploading...',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40).space(),
                      Text(
                        'Click to Upload Passport',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
