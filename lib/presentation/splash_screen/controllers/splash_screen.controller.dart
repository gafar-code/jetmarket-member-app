import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';

class SplashScreenController extends GetxController {
  Future<void> start() async {
    await Future.delayed(3.seconds, () async {
      // await checkingAuth();
      Get.offAllNamed(Routes.CHECK_EXTERNAL_LINK);
    });
  }

  // Future<void> checkingAuth() async {
  //   bool isTokenReady = AppPreference().getAccessToken() != null;
  //   int? userId = AppPreference().getUserData()?.user?.id;
  //   int? trxid = AppPreference().getTrxId();
  //   if (isTokenReady) {
  //     final response = await _authRepository.getUserProfile(userId ?? 0);
  //     if (response.status == StatusResponse.success) {
  //       if (trxid == null) {
  //         if (response.result?.activatedAt != null &&
  //             response.result?.isVerified == true) {
  //           Get.offAllNamed(Routes.MAIN_PAGES);
  //         } else if (response.result?.isVerified == false) {
  //           Get.offAllNamed(Routes.REGISTER_OTP);
  //         } else if (response.result?.isVerified == true) {
  //           Get.offAllNamed(Routes.SUCCESS_VERIFY_OTP);
  //         } else {
  //           Get.offAllNamed(Routes.LOGIN);
  //         }
  //       } else {
  //         var argument = PaymentMethodeArgument(
  //             trxId: AppPreference().getTrxId(), status: "waiting");
  //         Get.offAllNamed(Routes.DETAIL_PAYMENT_REGISTER, arguments: argument);
  //       }
  //     } else {
  //       Get.offAllNamed(Routes.LOGIN);
  //     }
  //   } else {
  //     Get.offAllNamed(Routes.LOGIN);
  //   }
  // }
}
