import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jetmarket/utils/extension/time_ago.dart';

import '../../../domain/core/model/model_data/notification.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/app_text.dart';
import '../../../utils/assets/assets_svg.dart';
import '../../../utils/style/app_style.dart';

class CardNotification extends StatelessWidget {
  const CardNotification({
    super.key,
    required this.data,
    this.onTap,
  });

  final NotificationData data;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppStyle.paddingAll12,
        decoration: BoxDecoration(
            color: const Color(0xffF4F6FA),
            borderRadius: AppStyle.borderRadius8All,
            border: AppStyle.borderAll),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(solarNotification),
                Gap(8.w),
                Text(data.type?.capitalize ?? '', style: text11GreyRegular),
                const Spacer(),
                Text("${data.createdAt?.timeAgo()}", style: text11GreyRegular)
              ],
            ),
            Gap(8.h),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data.title}', style: text12BlackRegular),
                    Gap(2.w),
                    Text('${data.body}', style: text11GreyRegular),
                  ],
                )),
                Visibility(
                  visible: data.image != null,
                  child: CachedNetworkImage(
                    imageUrl: Uri.tryParse(data.image ?? '')?.isAbsolute == true
                        ? data.image ?? ''
                        : '',
                    height: 50.r,
                    width: 50.r,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 120.w,
                        decoration: BoxDecoration(
                            color: kSofterGrey,
                            borderRadius: AppStyle.borderRadius8All,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      );
                    },
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
