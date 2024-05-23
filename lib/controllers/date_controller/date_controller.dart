import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';

class DateController extends GetxController {
  var date = DateTime.now().obs;

  @override
  void onInit() async {
    await findSystemLocale()
        .then((value) => print(DateFormat("HH:mm").format(DateTime.now())));
    await initializeDateFormatting();
    await initializeDateFormatting("tr_TR", null).then((_) {
      final format = DateFormat('yyyy-MM-dd HH:mm', "tr_TR");
      date.value = format.parse(date.value.toString().substring(0, 16));
      print(date.value.toString());
      // const dateAsString = '10 Mart 2021 16:38';
      // final format = DateFormat('dd MMMM yyyy HH:mm', 'tr_TR');
      // date.value = format.parse(dateAsString);
    });
    super.onInit();
  }

  incrase({bool isMonth = false}) {
    date.value = isMonth
        ? DateTime(date.value.year, date.value.month + 1, date.value.day)
        : DateTime(date.value.year, date.value.month, date.value.day + 1);
  }

  descrease({bool isMonth = false}) {
    date.value = isMonth
        ? DateTime(date.value.year, date.value.month - 1, date.value.day)
        : DateTime(date.value.year, date.value.month, date.value.day - 1);
  }

  @override
  void dispose() {
    // Get.delete();
    super.dispose();
  }
}
