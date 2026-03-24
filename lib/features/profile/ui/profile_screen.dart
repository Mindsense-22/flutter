import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/profile/ui/widgets/about_user_wid.dart';
import 'package:mindsense_app/features/profile/ui/widgets/favourite_wid.dart';
import 'package:mindsense_app/features/profile/ui/widgets/general_settings_wid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        actions: [          
          MaterialButton(
            onPressed: () {},
            child: SvgPicture.asset(
              "assets/images/settings_icon_white.svg",
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color ?? Colors.white,
                BlendMode.srcIn,
              ),
            ), 
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              AboutUserWid(),
              GeneralSettingsWid(),
              FavouriteWid(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

