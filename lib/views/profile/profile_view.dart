import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/views/search/search_view.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => SearchView(
                    title: 'Kullanıcı Ara',
                  ),
                );
              },
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
                  child: Column(
                    children: [
                      ProfileButtons(
                        icon: Icons.location_on,
                        text: "Kayıtlı Yerler",
                        //    func: null,
                      ),
                      ProfileButtons(
                        icon: Icons.settings,
                        text: "Kayıtlı Rotalar",
                        //    func: null,
                      ),
                      ProfileButtons(
                        icon: Icons.person,
                        text: "Arkadaşlar",
                        //func: null,
                      ),
                      ProfileButtons(
                        icon: Icons.settings,
                        text: "Ayarlar",
                        //func: null,
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
                    child: GestureDetector(
                      onTap: () {
                        print("object");
                        authController.logout();
                        // Get.back();
                      },
                      child: ProfileButtons(
                        text: "Çıkış Yap",
                        icon: Icons.logout_sharp,
                        //     func: authController.logout(),
                      ),
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
  ProfileButtons({
    super.key,
    required this.text,
    required this.icon,
    //  required this.func,
  });
  final String text;
  final IconData icon;
  // final Future<void>? func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstants.pictionBlueColor, width: 2),
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
    );
  }
}
