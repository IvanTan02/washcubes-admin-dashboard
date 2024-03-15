import 'package:flutter/material.dart';
import 'package:washcubes_admindashboard/src/constants/colors.dart';
import 'package:washcubes_admindashboard/src/constants/image_strings.dart';
import 'package:washcubes_admindashboard/src/constants/sizes.dart';
import 'package:washcubes_admindashboard/src/features/admin/screens/profile/admin_profile.dart';
import 'package:washcubes_admindashboard/src/features/operator/screens/profile/operator_profile.dart';
import 'package:washcubes_admindashboard/src/utilities/theme/widget_themes/text_theme.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: cDefaultSize),
            child: Image.asset(
              cAppLogo,
              width: 25,
            ),
          )
        ],
      ),
      elevation: 0,
      title: Row(
        children: [
          //Web Title
          Visibility(
            child: Text(
              'i3Cubes',
              style: CTextTheme.blackTextTheme.displaySmall,
            ),
          ),
          Expanded(child: Container()), //Spacing
          //Divider
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 24, 0),
            child: Container(
              width: 1,
              height: 22.0,
              color: AppColors.cGreyColor3,
            ),
          ),
          //Profile Icon
          CircleAvatar(
            child: IconButton(
                onPressed: () {
                  //TODO: Profile Pop Up, make it display operator / admin profile based on the user
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      // return const AdminProfile();
                      return const OperatorProfile();
                    },
                  );
                },
                icon: const Icon(
                  Icons.person_outline,
                  color: AppColors.cGreyColor2,
                )),
          )
        ],
      ),
    );
