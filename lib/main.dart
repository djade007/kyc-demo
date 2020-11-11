import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/components/auth/login_page.dart';
import 'package:kyc_demo/src/components/auth/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // unfocus input on tap out
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          currentFocus.requestFocus(FocusNode());
        }
      },
      child: GetMaterialApp(
        title: 'KYC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: RegisterPage.routeName,
        getPages: [
          GetPage(
            name: LoginPage.routeName,
            page: () => LoginPage(),
          ),
          GetPage(
            name: RegisterPage.routeName,
            page: () => RegisterPage(),
          ),
        ],
      ),
    );
  }
}
