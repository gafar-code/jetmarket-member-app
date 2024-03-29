import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jetmarket/components/form/app_form.dart';
import 'package:jetmarket/infrastructure/theme/app_colors.dart';
import 'package:jetmarket/infrastructure/theme/app_text.dart';
import 'package:jetmarket/presentation/auth/register_otp/controllers/register_otp.controller.dart';
import 'package:jetmarket/utils/style/app_style.dart';

import '../../../../components/button/app_button.dart';

class FormSection extends StatelessWidget {
  const FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const Gap(270),
          Container(
            padding: AppStyle.paddingAll16,
            decoration: BoxDecoration(
                color: kWhite, borderRadius: AppStyle.borderRadius20Top),
            child: GetBuilder<RegisterOtpController>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Masukan Kode OTP', style: text20PrimarySemiBold),
                  Gap(4.h),
                  Text('Kami telah mengirim kode ke nomor Anda',
                      style: text14BlackRegular),
                  Gap(16.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          controller.otpControllers.length,
                          (index) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(4.r, 0, 4.r, 0),
                                  child: AppForm(
                                    focusNode: controller.focusNodes[index],
                                    controller:
                                        controller.otpControllers[index],
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (value) =>
                                        controller.listenForm(index, value),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ))),
                  Gap(42.h),
                  AppButton.primary(
                    actionStatus: controller.actionStatus,
                    text: 'Verifikasi',
                    onPressed: controller.enableButton
                        ? () => controller.verifyOtp()
                        : null,
                  ),
                  Gap(72.h),
                  Obx(() => Center(
                        child: Column(
                          children: [
                            Visibility(
                              visible: controller.isCountdownSendOtpRun.value,
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                          'Belum menerima OTP ?\nKirim ulang Dalam ',
                                      style: text14BlackRegular,
                                      children: [
                                        TextSpan(
                                            text: controller
                                                .countdownSendOtp.value,
                                            style: text14BlackSemiBold)
                                      ])),
                            ),
                            Visibility(
                                visible:
                                    !controller.isCountdownSendOtpRun.value,
                                child: GestureDetector(
                                    onTap: () => controller.sendOtp(),
                                    child: Text(
                                      'Kirim Ulang',
                                      textAlign: TextAlign.center,
                                      style:
                                          controller.isCountdownSendOtpRun.value
                                              ? text14HintBold
                                              : text14NormalBold,
                                    )))
                          ],
                        ),
                      )),
                ],
              );
            }),
          ),
        ],
      ),
    ));
  }
}
