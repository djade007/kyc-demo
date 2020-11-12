import 'package:get/get.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/components/dashboard/dashboard_page.dart';
import 'package:kyc_demo/src/components/profile/profile_page.dart';
import 'package:kyc_demo/src/init.dart';

class AppDrawer extends StatelessWidget {
  final auth = Application.auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Obx(
            () => UserAccountsDrawerHeader(
              accountEmail: Text(auth.user.email),
              accountName: Text(auth.user.name),
              currentAccountPicture: Material(
                color: Colors.white,
                shape: CircleBorder(),
                child: Icon(
                  Icons.person,
                  color: Get.theme.primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  title: Text('Dashboard'),
                  leading: Icon(Icons.dashboard),
                  onTap: () {
                    Get.back(); // close
                    Get.toNamed(DashboardPage.routeName);
                  },
                ),
                ListTile(
                  title: Text('Profile'),
                  leading: Material(
                    color: Get.theme.primaryColor,
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.back(); // close
                    Get.toNamed(ProfilePage.routeName);
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    Application.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
