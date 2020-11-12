import 'package:flutter_svg/svg.dart';
import 'package:kyc_demo/src/components/profile/views/bvn_modal.dart';
import 'package:kyc_demo/src/init.dart';
import 'package:kyc_demo/src/widgets/drawer.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = 'profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          _buildHeader(),
          _buildSteps(),
          Container(
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: FlatButton(
              color: Get.theme.accentColor,
              onPressed: () {
                Get.bottomSheet(
                  Container(
                    height: Utils.height(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            bottom: 20,
                          ),
                          height: 6,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Expanded(child: BvnModal()),
                      ],
                    ),
                  ),
                );
              },
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
      ),
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
                      verified: true,
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
    bool verified: false,
  }) {
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
                    Text('johnmel').space(bottom: 5),
                    Text('John Doe').space(bottom: 5),
                    Text('john@jjj.com').space(bottom: 5),
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
                    'KYC LV 1',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 5,
                    ),
                    child: Text(
                      'Upgrade to level 2',
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
