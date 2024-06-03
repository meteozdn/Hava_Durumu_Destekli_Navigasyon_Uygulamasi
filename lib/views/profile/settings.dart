import 'package:flutter/material.dart';
import 'package:navigationapp/views/profile/profile_view.dart';
import '../../controllers/theme_changer_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
      ),
      body: ListView(
        children: <Widget>[
          ProfileButtons(
            text: "Tema Seçimi",
            icon: Icons.color_lens,
            onPressed: () {
              _showThemeSelectionDialog(context);
            },
          ),
          ProfileButtons(
            text: "Dil Seçimi",
            icon: Icons.language,
            onPressed: () {
              // Dil seçimi işlemleri
            },
          ),
          ProfileButtons(
            text: "Bildirim Ayarları",
            icon: Icons.notifications,
            onPressed: () {
              // Bildirim ayarları işlemleri
            },
          ),
          ProfileButtons(
            text: "Hesap Ayarları",
            icon: Icons.account_circle,
            onPressed: () {
              // Hesap ayarları işlemleri
            },
          ),
          ProfileButtons(
            text: "Gizlilik ve Güvenlik",
            icon: Icons.security,
            onPressed: () {
              // Gizlilik ve güvenlik işlemleri
            },
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
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tema Seçimi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: Text("Açık Tema"),
                onTap: () {
                  ThemeChanger.instance.setTheme(ThemeData.light());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: Text("Koyu Tema"),
                onTap: () {
                  ThemeChanger.instance.setTheme(ThemeData.dark());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: Text("Kırmızı Tema"),
                onTap: () {
                  ThemeChanger.instance.setTheme(ThemeChanger.instance.buildRedTheme());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: Text("Pembe Tema"),
                onTap: () {
                  ThemeChanger.instance.setTheme(ThemeChanger.instance.buildPinkTheme());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.red , Colors.yellow , Colors.yellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: Text("Mavi Tema"),
                onTap: () {
                  ThemeChanger.instance.setTheme(ThemeChanger.instance.buildBlueTheme());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                title: Text("Turuncu Tema"),
                onTap: () {
                  ThemeChanger.instance.setTheme(ThemeChanger.instance.buildOrangeTheme());
                  Navigator.pop(context);
                },
              ),
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
        title: Text("Hakkında"),
      ),
      body: Center(
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

class ProfileButtons extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double textSize;
  final double iconSize;

  const ProfileButtons({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.blueGrey,
    this.iconColor = Colors.pink,
    this.textColor = Colors.black87,
    this.textSize = 16.0,
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
        ),
      ),
      leading: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      onTap: onPressed,
      tileColor: backgroundColor,
    );
  }
}
