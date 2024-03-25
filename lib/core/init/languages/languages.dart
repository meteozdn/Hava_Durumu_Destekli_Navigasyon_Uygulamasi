import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'Home': 'Home',
          'English': 'English',
          'Turkce': 'Turkish',
          'ChangeLang': 'Change Language',
          'language': 'English',
        },
        'tr': {
          'Home': 'Ana Sayfa',
          'Turkce': 'Türkçe',
          'English': 'İngilizce',
          'ChangeLang': 'Dili Değiştir',
          'language': 'Türkçe',
        }
      };
}
