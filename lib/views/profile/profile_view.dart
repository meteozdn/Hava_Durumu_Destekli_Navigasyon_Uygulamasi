import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/controllers/picker_controller/picker_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/views/profile/friends.dart';
import 'package:navigationapp/views/profile/saved_locations.dart';
import 'package:navigationapp/views/profile/saved_rotates.dart';
import 'package:navigationapp/views/profile/settings.dart';
import 'package:navigationapp/views/search/search_view.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final AuthController authController = Get.find();
  final UserController userController = Get.find();

  final ProfilePicturePickerController pickerController =
      Get.put(ProfilePicturePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ColorConstants.greyColor,
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.2),
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
              child: const Padding(
                padding: EdgeInsets.only(left: 1.0),
                child: Icon(
                  Icons.person_add_alt_1,
                  color: ColorConstants.pictionBlueColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorConstants.pictionBlueColor,
                        radius: 52.h,
                        child: CircleAvatar(
                          backgroundImage: userController.user.value!.image !=
                                  null
                              ? NetworkImage(userController.user.value!.image!)
                              : null,
                          backgroundColor: ColorConstants.pictionBlueColor,
                          radius: 50.h,
                          child: userController.user.value!.image == null
                              ? Icon(
                                  Icons.person,
                                  size: 50.w,
                                )
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await pickerController.pickImage();
                          showDialog(
                            context: context,
                            builder: (_) {
                              if (pickerController.image != null) {
                                return AlertDialog(
                                  title: const Text('Profil Fotoğrafı'),
                                  content: Image.file(
                                    fit: BoxFit.contain,
                                    pickerController.image!,
                                    width: 250.w,
                                    height: 250.w,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        pickerController.uploadImage();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: const Text('Tamam'),
                                    ),
                                    TextButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text('İptal'),
                                    ),
                                  ],
                                );
                              }

                              return AlertDialog(
                                title: const Text('Resim Seçilmedi'),
                                content: const Text('Tekrar Deneyiniz'),
                                actions: [
                                  TextButton(
                                    onPressed: Navigator.of(context).pop,
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: ColorConstants.pictionBlueColor,
                          child: Icon(
                            Icons.camera_alt_sharp,
                            color: ColorConstants.whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.h, right: 10.h, left: 10.h, bottom: 60),
                  child: Text(
                    userController.user.value!.name,
                    style: TextStyle(
                        color: ColorConstants.blackColor, fontSize: 30.sp),
                  ),
                ),
                const ProfileWidgets(),
                Padding(
                  padding: EdgeInsets.only(top: 60.0.h),
                  child: Container(
                    //height: 50.h,
                    decoration: BoxDecoration(
                      //border:
                      //   Border.all(color: ColorConstants.pictionBlueColor),
                      borderRadius: BorderRadius.circular(12.r),
                      color: ColorConstants.whiteColor,
                    ),
                    child: GestureDetector(
                      onTap: () {
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

class ProfileWidgets extends StatelessWidget {
  const ProfileWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50.h,
      decoration: BoxDecoration(
        //  border: Border.all(color: ColorConstants.pictionBlueColor),
        borderRadius: BorderRadius.circular(12.r),
        color: ColorConstants.whiteColor,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => const SavedLocationsView(
                    //  title: 'Kullanıcı Ara',
                    ),
              );
            },
            child: ProfileButtons(
              icon: Icons.location_on,
              text: "Kayıtlı Yerler",
              //    func: null,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Divider(
              height: 1.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => const SavedRotatesView(
                    //  title: 'Kullanıcı Ara',
                    ),
              );
            },
            child: ProfileButtons(
              icon: Icons.route_rounded,
              text: "Kayıtlı Rotalar",
              //    func: null,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Divider(
              height: 1.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => FriendsView(
                    //  title: 'Kullanıcı Ara',
                    ),
              );
            },
            child: ProfileButtons(
              icon: Icons.person,
              text: "Arkadaşlar",
              //func: null,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Divider(
              height: 1.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => const SettingsView(
                    //  title: 'Kullanıcı Ara',
                    ),
              );
            },
            child: ProfileButtons(
              icon: Icons.settings,
              text: "Ayarlar",
              //func: null,
            ),
          ),
        ],
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
                      //   border: Border.all(
                      //      color: ColorConstants.pictionBlueColor, width: 2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.greyColor,
                            border: Border.all(color: ColorConstants.greyColor),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Icon(
                          icon,
                          color: ColorConstants.whiteColor,
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 15.0.w),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 18.sp,
                        //  fontWeight: FontWeight.bold,
                        color: ColorConstants.pictionBlueColor),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.navigate_next_rounded,
            color: ColorConstants.greyColor,
            size: 30.r,
          )
        ],
      ),
    );
  }
}
