import 'package:get/get.dart';
import 'package:jetmarket/infrastructure/navigation/routes.dart';
import 'package:jetmarket/presentation/main_pages/controllers/main_pages.controller.dart';

import '../../../../components/dialog/dialog_noconnection.dart';
import '../../../../domain/core/interfaces/ewallet_repository.dart';
import '../../../../domain/core/model/model_data/detail_topup_model.dart';
import '../../../../infrastructure/dal/repository/notification_repository_impl.dart';
import '../../../../infrastructure/dal/services/firebase/firebase_controller.dart';
import '../../../../utils/network/screen_status.dart';
import '../../../../utils/network/status_response.dart';
import '../../detail_withdraw/controllers/detail_withdraw.controller.dart';

enum StatusTopupType { waiting, success, failed }

class DetailTopupController extends GetxController {
  final EwalletRepository _ewalletRepository;

  DetailTopupController(this._ewalletRepository);

  var screenStatus = (ScreenStatus.initalize).obs;

  DetailTopupModel? detailTopupModel;

  var statusWd = StatusWdType.failed;

  Future<void> getDetailWIthdraw() async {
    screenStatus(ScreenStatus.loading);
    final response =
        await _ewalletRepository.getDetailTopup(id: Get.arguments[0]);
    if (response.status == StatusResponse.success) {
      detailTopupModel = response.result;
      update();
      screenStatus(ScreenStatus.success);
    } else if (response.status == StatusResponse.noInternet) {
      if (!(Get.isDialogOpen ?? false)) {
        DialogNoConnection.show(onReload: () {
          Get.back();
          getDetailWIthdraw();
        });
      }
    } else {
      screenStatus(ScreenStatus.failed);
    }
  }

  void actionBack() {
    if (Get.arguments[1] != null) {
      updateUnreadNotification();
      Get.offAllNamed(Routes.MAIN_PAGES);
      Get.put(MainPagesController());
    } else {
      Get.back();
    }
  }

  Future<void> updateUnreadNotification() async {
    final controller =
        Get.put(FirebaseController(NotificationRepositoryImpl()));
    await controller.getUnreadNotification();
  }

  @override
  void onInit() {
    getDetailWIthdraw();
    super.onInit();
  }
}
