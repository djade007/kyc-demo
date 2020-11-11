import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/components/auth/register_page.dart';
import 'package:kyc_demo/src/controllers/auth/login_controller.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/widgets/button.dart';
import 'package:kyc_demo/src/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  static const routeName = 'login';
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLogo(),
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 25,
                    right: 25,
                  ),
                  width: double.infinity,
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 20,
                        right: 20,
                        bottom: 30,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ).space(bottom: 5),
                          Text(
                            'Please sign in',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ).space(bottom: 20),
                          FormBuilder(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  attribute: 'email',
                                  decoration: Utils.decoration('Email Address'),
                                  validators: [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.email(),
                                  ],
                                ).space(bottom: 20),
                                FormBuilderTextField(
                                  attribute: 'password',
                                  decoration: Utils.decoration('Password'),
                                  obscureText: true,
                                  validators: [
                                    FormBuilderValidators.required(),
                                  ],
                                ).space(bottom: 20),
                                AppButton(
                                  title: 'Sign in',
                                  onPressed: controller.login,
                                ).space(),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, right: 8, bottom: 8),
                                        child: Text(
                                          'Forgot Password ?',
                                          style: TextStyle(
                                            color: Get.theme.primaryColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(RegisterPage.routeName);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: Get.textTheme.bodyText2
                                                .copyWith(
                                              fontSize: 11,
                                            ),
                                            children: [
                                              TextSpan(text: 'New User? '),
                                              TextSpan(
                                                text: 'Sign up',
                                                style: TextStyle(
                                                  color: Get.theme.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
