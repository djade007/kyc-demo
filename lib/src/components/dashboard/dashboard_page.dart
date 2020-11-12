import 'package:kyc_demo/src/components/profile/profile_page.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/widgets/drawer.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: FlatButton(
          onPressed: () {
            Get.toNamed(ProfilePage.routeName);
          },
          child: Text('Go to Profile'),
        ),
      ),
    );
  }
}
