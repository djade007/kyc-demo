import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/controllers/auth/register_controller.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/widgets/button.dart';
import 'package:kyc_demo/src/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = 'register';
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLogo().space(bottom: 20),
              Text(
                'Create your account...',
                style: Get.textTheme.caption,
              ).space(bottom: 30),
              FormBuilder(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: FormBuilderTextField(
                            attribute: 'email',
                            decoration: Utils.decoration('Email Address'),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Required',
                              ),
                              FormBuilderValidators.email(
                                errorText: 'Invalid email',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: FormBuilderTextField(
                            attribute: 'name',
                            decoration: Utils.decoration('Name'),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: 'Required'),
                            ],
                          ),
                        ),
                      ],
                    ).space(bottom: 20),
                    FormBuilderTextField(
                      attribute: 'username',
                      decoration: Utils.decoration('Username'),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ).space(bottom: 20),
                    Row(
                      children: [
                        Flexible(
                          child: FormBuilderTextField(
                            attribute: 'password',
                            decoration: Utils.decoration('Password'),
                            obscureText: true,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Required',
                              ),
                              FormBuilderValidators.minLength(
                                8,
                                errorText: '8 characters minimum',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: FormBuilderTextField(
                            attribute: 'confirm_password',
                            decoration: Utils.decoration('Confirm Password'),
                            obscureText: true,
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Required',
                              ),
                              FormBuilderValidators.minLength(
                                8,
                                errorText: 'must be 8 characters or more',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).space(),
                    SizedBox(
                      width: Utils.width(2) - 20,
                      child: Text(
                        'Use 8 or more characters with a mix of letters,'
                        'numbers & symbols.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                        ),
                      ),
                    ).left().space(bottom: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                'Sign in instead ?',
                                style: TextStyle(
                                  color: Get.theme.primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: AppButton(
                            title: 'Sign up',
                            onPressed: controller.register,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
