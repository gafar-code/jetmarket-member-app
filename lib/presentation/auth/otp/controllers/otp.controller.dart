import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jetmarket/domain/core/model/params/auth/forgot_verify_otp_param.dart';
import 'package:jetmarket/utils/app_preference/app_preferences.dart';

import '../../../../components/snackbar/app_snackbar.dart';
import '../../../../domain/core/interfaces/auth_repository.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../utils/network/action_status.dart';
import '../../../../utils/network/status_response.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository;
  OtpController(this._authRepository);
  late List<TextEditingController> otpControllers;
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  var enableButton = false;
  var actionStatus = ActionStatus.initalize;

  String email = "";
  var countdownSendOtp = ''.obs;
  var isCountdownSendOtpRun = false.obs;

  Future<void> verifyOtp() async {
    List<String> otpNumber = [];
    for (var otp in otpControllers) {
      otpNumber.add(otp.text);
    }
    actionStatus = ActionStatus.loading;
    update();
    var param = ForgotVerifyOtpParam(email: email, otp: otpNumber.join());
    final response = await _authRepository.verifyForgotOtp(param);
    if (response.status == StatusResponse.success) {
      actionStatus = ActionStatus.success;
      AppPreference().saveAccessToken(status: 200, token: response.result);
      update();
      Get.toNamed(Routes.RESET_PASSWORD, arguments: response.result);
    } else {
      actionStatus = ActionStatus.failed;
      update();
      AppSnackbar.show(message: response.message ?? '', type: SnackType.error);
    }
  }

  void listenForm(int index, String value) {
    if (value.isNotEmpty) {
      if (index < otpControllers.length - 1) {
        focusNodes[index + 1].requestFocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  void startCountdown() {
    int secondsRemaining = 120;
    // ignore: unused_local_variable
    late Timer timer;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        isCountdownSendOtpRun(true);
        int minutes = secondsRemaining ~/ 60;
        int remainingSeconds = secondsRemaining % 60;
        String minutesString = (minutes < 10) ? '0$minutes' : '$minutes';
        String secondsString = (remainingSeconds < 10)
            ? '0$remainingSeconds'
            : '$remainingSeconds';
        countdownSendOtp.value = '$minutesString:$secondsString';
        secondsRemaining--;
      } else {
        countdownSendOtp.value = '00:00';
        isCountdownSendOtpRun(false);
        timer.cancel();
      }
    });
  }

  Future<void> sendOtp() async {
    startCountdown();
    final response = await _authRepository.sendOtp(email);
    if (response.status == StatusResponse.success) {
    } else {
      AppSnackbar.show(message: response.message ?? '', type: SnackType.error);
    }
  }

  @override
  void onInit() {
    email = Get.arguments;
    super.onInit();
    otpControllers = List.generate(6, (index) {
      var controller = TextEditingController();
      controller.addListener(_checkIfAllFieldsFilled);
      return controller;
    });
    _checkIfAllFieldsFilled();
  }

  void _checkIfAllFieldsFilled() {
    bool allFilled = otpControllers.every((element) => element.text.isNotEmpty);
    enableButton = allFilled;
    update();
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
