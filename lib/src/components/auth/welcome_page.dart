import 'package:kyc_demo/src/controllers/auth/welcome_controller.dart';
import 'package:kyc_demo/src/init.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = 'welcome';
  final controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
