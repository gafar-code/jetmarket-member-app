import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jetmarket/domain/core/interfaces/paylater_repository.dart';

import '../../../../components/bottom_sheet/show_bottom_sheet.dart';
import '../../../../components/dialog/dialog_noconnection.dart';
import '../../../../components/snackbar/app_snackbar.dart';
import '../../../../domain/core/interfaces/payment_repository.dart';
import '../../../../domain/core/model/model_data/payment_methode_model.dart';
import '../../../../domain/core/model/params/paylater/bill_paylater_body.dart';
import '../../../../domain/core/model/params/wallet/wallet_topup_body.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/theme/app_text.dart';
import '../../../../utils/extension/payment_methode_type.dart';
import '../../../../utils/network/action_status.dart';
import '../../../../utils/network/screen_status.dart';
import '../../../../utils/network/status_response.dart';
import '../widget/confirmation_saving_saldo.dart';
import '../widget/ovo_form.dart';

class ChoicePaymentPaylaterController extends GetxController {
  final PaymentRepository _paymentRepository;
  final PayLaterRepository _payLaterRepository;

  ChoicePaymentPaylaterController(
      this._paymentRepository, this._payLaterRepository);
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
        type: PaymentMethodeType.biling);
    if (response.result?.ewalletQr != null &&
        response.result?.otc != null &&
        response.result?.virtualAccount != null) {
      {
        if (response.status == StatusResponse.success) {
          paymentMethodes = response.result;
          update();
          screenStatus(ScreenStatus.success);
        } else if (response.status == StatusResponse.noInternet) {
          if (!(Get.isDialogOpen ?? false)) {
            DialogNoConnection.show(onReload: () {
              Get.back();
              getPaymentMethode();
            });
          }
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

  void confirmationDialogSavingSaldo() {
    AppDialogConfirmationSaving.show(controller: this);
  }

  void selectSaldoPayment() {
    selectedchCode = paymentMethodes?.saldo?[0].chCode ?? '';
    selectedchType = paymentMethodes?.saldo?[0].chType ?? '';
    update();
  }

  void confirmationSavingSaldo() {
    Get.back();
    if (Get.arguments[1] <= (paymentMethodes?.saldo?[0].amount ?? 0)) {
      selectSaldoPayment();
      paylaterPay();
    } else {
      errorDialogMessage('Saldo tidak cukup');
    }
  }

  void errorDialogMessage(String message) {
    AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: message,
            titleTextStyle: text16BlackSemiBold,
            descTextStyle: text12BlackRegular,
            btnCancelOnPress: () {})
        .show();
  }

  Future<void> paylaterPay() async {
    actionStatus = ActionStatus.loading;
    update();
    var body = BillPaylaterBody(
        refId: Get.arguments[0],
        amount: Get.arguments[1],
        chCode: selectedchCode,
        chType: selectedchType,
        mobileNumber: numberController.text);
    final response = await _payLaterRepository.paylaterPay(body);
    if (response.status == StatusResponse.success) {
      actionStatus = ActionStatus.success;
      update();
      Get.offAllNamed(Routes.DETAIL_PAYMENT_PAYLATER,
          arguments: response.result);
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
