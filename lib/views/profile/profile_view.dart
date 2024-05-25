import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: const CircleAvatar(
              backgroundColor: ColorConstants.pictionBlueColor,
              child: Padding(
                padding: EdgeInsets.only(left: 1.0),
                child: Icon(
                  Icons.person_add_alt_1,
                  color: ColorConstants.whiteColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          color: ColorConstants.whiteColor,
          child: Padding(
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CircleAvatar(
                    backgroundColor: ColorConstants.pictionBlueColor,
                    radius: 50.h,
                    //   child: Text("kenan?"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.h, right: 10.h, left: 10.h, bottom: 60),
                  child: Text(
                    "Ahmet ",
                    style: TextStyle(
                        color: ColorConstants.blackColor, fontSize: 30.sp),
                  ),
                ),
                Container(
                  // height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstants.pictionBlueColor),
                    borderRadius: BorderRadius.circular(20.r),
                    color: ColorConstants.whiteColor,
                  ),
                  child: const Column(
                    children: [
                      ProfileButtons(
                        icon: Icons.location_on,
                        text: "Kayıtlı Yerler",
                      ),
                      ProfileButtons(
                        icon: Icons.settings,
                        text: "Kayıtlı Rotalar",
                      ),
                      ProfileButtons(
                        icon: Icons.person,
                        text: "Arkadaşlar",
                      ),
                      ProfileButtons(
                        icon: Icons.settings,
                        text: "Ayarlar",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0.h),
                  child: Container(
                    //height: 50.h,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: ColorConstants.pictionBlueColor),
                      borderRadius: BorderRadius.circular(20.r),
                      color: ColorConstants.whiteColor,
                    ),
                    child: const ProfileButtons(
                      text: "Çıkış Yap",
                      icon: Icons.logout_sharp,
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

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    super.key,
    required this.text,
    required this.icon,
  });
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.pictionBlueColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0.w),
                          child: Icon(
                            icon,
                            color: ColorConstants.pictionBlueColor,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0.w),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.pictionBlueColor),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.navigate_next_rounded,
                color: ColorConstants.pictionBlueColor,
                size: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
