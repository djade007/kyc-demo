import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyc_demo/src/components/auth/login_page.dart';
import 'package:kyc_demo/src/components/auth/register_page.dart';
import 'package:kyc_demo/src/components/dashboard/dashboard_page.dart';
import 'package:kyc_demo/src/components/profile/profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // un-focus input on tap out
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
          accentColor: const Color(0xFF4ad3ce),
        ),
        initialRoute: ProfilePage.routeName,
        getPages: [
          GetPage(
            name: LoginPage.routeName,
            page: () => LoginPage(),
          ),
          GetPage(
            name: RegisterPage.routeName,
            page: () => RegisterPage(),
          ),
          GetPage(
            name: DashboardPage.routeName,
            page: () => DashboardPage(),
          ),
          GetPage(
            name: ProfilePage.routeName,
            page: () => ProfilePage(),
          ),
        ],
      ),
    );
  }
}
