import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jetmarket/domain/core/interfaces/ewallet_repository.dart';

import '../../../../components/bottom_sheet/show_bottom_sheet.dart';
import '../../../../components/snackbar/app_snackbar.dart';
import '../../../../domain/core/interfaces/payment_repository.dart';
import '../../../../domain/core/model/model_data/payment_methode_model.dart';
import '../../../../domain/core/model/params/wallet/wallet_topup_body.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/theme/app_text.dart';
import '../../../../utils/extension/payment_methode_type.dart';
import '../../../../utils/global/constant.dart';
import '../../../../utils/network/action_status.dart';
import '../../../../utils/network/screen_status.dart';
import '../../../../utils/network/status_response.dart';
import '../widget/ovo_form.dart';

class ChoicePaymentTopupController extends GetxController {
  final PaymentRepository _paymentRepository;
  final EwalletRepository _ewalletRepository;

  ChoicePaymentTopupController(
      this._paymentRepository, this._ewalletRepository);
  TextEditingController numberController = TextEditingController();
  var screenStatus = (ScreenStatus.initalize).obs;
  var actionStatus = ActionStatus.initalize;
  PaymentMethodeModel? paymentMethodes;
  WalletTopupBody? walletTopupBody;
  String selectedBankTransfer = "";
  String selectedEwallet = "";
  String selectedRetail = "";
  int selectedId = 0;
  String selectedchType = "";
  String selectedchCode = "";
  String selectedName = "";
  final String countryCode = '+62';

  bool isBankTransferExpanded = false;
  bool isEwalletExpanded = false;
  bool isRetailExpanded = false;
  var isPhoneValidated = false.obs;

  void onChangeExpandBank(bool expand) {
    isBankTransferExpanded = expand;
    selectedBankTransfer = "";
    update();
  }

  void onChangeExpandEwallet(bool expand) {
    isEwalletExpanded = expand;
    selectedEwallet = "";
    update();
  }

  void onChangeExpandRetail(bool expand) {
    isRetailExpanded = expand;
    selectedRetail = "";
    update();
  }

  Future<void> getPaymentMethode() async {
    screenStatus(ScreenStatus.loading);
    final response = await _paymentRepository.getPaymentMethode(
        type: PaymentMethodeType.topup);
    if (response.result?.ewalletQr != null &&
        response.result?.otc != null &&
        response.result?.virtualAccount != null) {
      {
        if (response.status == StatusResponse.success) {
          paymentMethodes = response.result;
          update();
          screenStatus(ScreenStatus.success);
        } else {
          AppSnackbar.show(message: response.message, type: SnackType.error);
          screenStatus(ScreenStatus.failed);
        }
      }
    } else {
      AppSnackbar.show(message: 'Something went wrong', type: SnackType.error);
      screenStatus(ScreenStatus.failed);
    }
  }

  Future<void> topUpWallet() async {
    actionStatus = ActionStatus.loading;
    update();
    var body = WalletTopupBody(
        amount: Get.arguments,
        chCode: selectedchCode,
        chType: selectedchType,
        mobileNumber: numberController.text);
    final response = await _ewalletRepository.topUpWallet(body);
    if (response.status == StatusResponse.success) {
      actionStatus = ActionStatus.success;
      update();
      isPayment = true;
      Get.offNamed(Routes.PAYMENT_TOPUP_SALDO, arguments: response.result);
    } else {
      actionStatus = ActionStatus.failed;
      update();
      AwesomeDialog(
              context: Get.context!,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: response.message,
              titleTextStyle: text16BlackSemiBold,
              descTextStyle: text12BlackRegular,
              btnCancelOnPress: () {})
          .show();
    }
  }

  String assetImage(String path) {
    return "assets/images/${path.toLowerCase()}.png";
  }

  void actionPayment(int id, String chType, String chCode, String name) {
    selectedBankTransfer = chCode;
    selectedEwallet = chCode;
    selectedRetail = chCode;
    selectedId = id;
    selectedchType = chType;
    selectedchCode = chCode;
    selectedName = name;
    update();
    if (chType == "EWALLET" && chCode == "OVO") {
      CustomBottomSheet.show(
          child: OvoForm(
        controller: this,
      ));
    }
  }

  List<TextInputFormatter> formaterNumber() => [
        LengthLimitingTextInputFormatter(countryCode.length + 12),
        FilteringTextInputFormatter.deny(RegExp(r'[^\d+]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.startsWith(countryCode)) {
            return newValue;
          }
          return oldValue;
        }),
      ];

  listenPhoneForm(String value) {
    if (value.startsWith('${countryCode}0') &&
        value.length > (countryCode.length + 1)) {
      numberController.text =
          countryCode + value.substring(countryCode.length + 1);
      numberController.selection = TextSelection.fromPosition(
          TextPosition(offset: numberController.text.length));
      update();
    }
    if (value.length >= 9) {
      isPhoneValidated(true);
    } else {
      isPhoneValidated(false);
    }
  }

  String getImage(String image) {
    String img;
    try {
      img = 'assets/images/${image.toLowerCase()}.png';
    } catch (e) {
      img = 'assets/images/warning.png';
    }
    return img;
  }

  @override
  void onInit() {
    numberController.text = countryCode;
    numberController.selection = TextSelection.fromPosition(
        TextPosition(offset: numberController.text.length));
    getPaymentMethode();
    super.onInit();
  }
}
