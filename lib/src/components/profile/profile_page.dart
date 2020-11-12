import 'package:flutter_svg/svg.dart';
import 'package:kyc_demo/src/application.dart';
import 'package:kyc_demo/src/controllers/profile/profile_controller.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/widgets/drawer.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = 'profile';
  final auth = Application.auth;
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Obx(
            () => IconButton(
              icon: controller.loading.value
                  ? CircularProgressIndicator()
                  : const Icon(Icons.refresh),
              onPressed: controller.loading.value ? null : controller.refresh,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(child: Obx(_buildContent)),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        _buildSteps(),
        Container(
          padding: const EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          child: FlatButton(
            color: Get.theme.accentColor,
            onPressed: Utils.kycModal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              'Continue verification',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSteps() {
    return Card(
      margin: const EdgeInsets.only(
        top: 40,
        bottom: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ).space(left: 16),
              Text(
                'Complete steps below to get verified',
                style: TextStyle(
                  fontSize: 13,
                ),
              ).space(
                left: 16,
                bottom: 0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 16,
                  right: 10,
                ),
                child: Row(
                  children: [
                    _buildCard(
                      level: 1,
                      title: 'BVN Verification',
                      svg: 'bvn',
                    ),
                    _buildCard(
                      level: 2,
                      title: 'Passport Verification',
                      svg: 'id-card',
                    ),
                    _buildCard(
                      level: 3,
                      title: 'Link Bank Account',
                      svg: 'link',
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

  Widget _buildCard({
    @required int level,
    @required String title,
    @required String svg,
  }) {
    final verified = auth.user.level >= level;
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: verified ? 0.3 : 1,
          duration: Duration(milliseconds: 300),
          child: Container(
            width: 200,
            height: 190,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/$svg.svg',
                    width: 60,
                  ),
                  Text(
                    'Level $level',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ).space(
                    top: 12,
                    bottom: 5,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (verified)
          Positioned(
            right: 34,
            top: 18,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Get.theme.accentColor,
              ),
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Material(
                  shape: CircleBorder(),
                  color: Colors.grey.withOpacity(.2),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(auth.user.username).space(bottom: 5),
                    Text(auth.user.name).space(bottom: 5),
                    Text(auth.user.email).space(bottom: 0),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black54,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: Text(
                    'KYC LV ${auth.user.level}',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: Utils.kycModal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 5,
                    ),
                    child: Text(
                      'Upgrade to level ${auth.user.level + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Get.theme.accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
