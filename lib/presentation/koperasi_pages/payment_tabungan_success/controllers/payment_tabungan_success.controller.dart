import 'package:get/get.dart';

import '../../../../domain/core/model/model_data/saving_direct_model.dart';

class PaymentTabunganSuccessController extends GetxController {
  SavingDirectModel? savingDirect;
  int? total;

  @override
  void onInit() {
    savingDirect = Get.arguments[0];
    total = Get.arguments[1];
    super.onInit();
  }
}
