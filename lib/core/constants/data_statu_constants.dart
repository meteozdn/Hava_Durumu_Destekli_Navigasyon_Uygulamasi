import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'enums/data_statu_enum.dart';

// Getx in RxStatus isimli değişkeni de kullanılabilir
class ViewStateforUI {
  Rx<DataCheck> viewState = DataCheck.none.obs;

  DataCheck waitingDataState() {
    return viewState.value = DataCheck.waiting;
  }

  doneDataState() {
    return viewState.value = DataCheck.done;
  }

  noneDataState() {
    return viewState.value = DataCheck.none;
  }

  errorDataState() {
    return viewState.value = DataCheck.error;
  }
}
