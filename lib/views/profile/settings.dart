import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/views/profile/profile_view.dart';

class SettingsView extends StatelessWidget {
  final MapController mapController = Get.find();
  final ThemeChanger themeChanger = Get.find();

  SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 304,
          decoration: BoxDecoration(
            //border:
            //   Border.all(color: ColorConstants.pictionBlueColor),
            borderRadius: BorderRadius.circular(12.r),
            color: themeChanger.isLight.value
                ? ColorConstants.whiteColor
                : ColorConstants.darkGrey,
          ),
          child: Column(
            children: <Widget>[
              ProfileButtons(
                text: "Tema Seçimi",
                icon: Icons.color_lens,
                onPressed: () {
                  _showThemeSelectionDialog(context);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Divider(
                  height: 1.h,
                ),
              ),
              ProfileButtons(
                text: "Dil Seçimi",
                icon: Icons.language,
                onPressed: () {
                  // Dil seçimi işlemleri
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Divider(
                  height: 1.h,
                ),
              ),
              ProfileButtons(
                text: "Bildirim Ayarları",
                icon: Icons.notifications,
                onPressed: () {
                  // Bildirim ayarları işlemleri
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Divider(
                  height: 1.h,
                ),
              ),
              ProfileButtons(
                text: "Hesap Ayarları",
                icon: Icons.account_circle,
                onPressed: () {
                  // Hesap ayarları işlemleri
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Divider(
                  height: 1.h,
                ),
              ),
              ProfileButtons(
                text: "Gizlilik ve Güvenlik",
                icon: Icons.security,
                onPressed: () {
                  // Gizlilik ve güvenlik işlemleri
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Divider(
                  height: 1.h,
                ),
              ),
              ProfileButtons(
                text: "Hakkında",
                icon: Icons.info,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tema Seçimi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: const Text("Açık Tema"),
                onTap: () async {
                  themeChanger.isLight(true);

                  await mapController.setMapStyle();
                  ThemeChanger.instance
                      .setTheme(ThemeChanger.instance.initTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: const Text("Koyu Tema"),
                onTap: () async {
                  themeChanger.isLight(false);

                  await mapController.setMapStyle();

                  ThemeChanger.instance
                      .setTheme(ThemeChanger.instance.darkTheme());
                  Navigator.pop(context);
                },
              ), /*
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: const Text("Kırmızı Tema"),
                onTap: () {
                  ThemeChanger.instance
                      .setTheme(ThemeChanger.instance.buildRedTheme());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: const Text("Pembe Tema"),
                onTap: () {
                  ThemeChanger.instance
                      .setTheme(ThemeChanger.instance.defaultTheme());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.red,
                          Colors.yellow,
                          Colors.yellow
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: const Text("Mavi Tema"),
                onTap: () {
                  ThemeChanger.instance
                      .setTheme(ThemeChanger.instance.buildBlueTheme());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: const Text("Turuncu Tema"),
                onTap: () {
                  ThemeChanger.instance
                      .setTheme(ThemeChanger.instance.buildOrangeTheme());
                  Navigator.pop(context);
                },
              ),*/
            ],
          ),
        );
      },
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hakkında"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Uygulama Adı",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              "Versiyon 1.0.0",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
