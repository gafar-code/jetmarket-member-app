import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jetmarket/domain/core/model/model_data/notification.dart';
import 'package:jetmarket/infrastructure/theme/app_colors.dart';
import 'package:jetmarket/infrastructure/theme/app_text.dart';
import 'package:jetmarket/presentation/notification/widget/card_notification.dart';
import 'package:jetmarket/utils/style/app_style.dart';

import 'controllers/notification.controller.dart';
import 'section/app_bar_section.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: CustomScrollView(
        slivers: [
          const AppBarNotification(),
          SliverPadding(
              padding: AppStyle.paddingAll16,
              sliver: PagedSliverList.separated(
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<NotificationData>(
                    itemBuilder: (context, item, index) => CardNotification(
                      data: item,
                    ),
                    newPageProgressIndicatorBuilder: (_) {
                      return SizedBox(
                        height: 120.h,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 12.r,
                          ),
                        ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (_) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          radius: 12.r,
                        ),
                      );
                    },
                    noItemsFoundIndicatorBuilder: (_) {
                      return Center(
                        child: Text("Oops! Notifikasi belum tersedia",
                            style: text12BlackRegular),
                      );
                    },
                  ),
                  separatorBuilder: (_, i) => Gap(12.h))),
        ],
      ),
    );
  }
}
