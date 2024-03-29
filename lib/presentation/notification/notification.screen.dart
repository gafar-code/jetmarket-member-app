import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jetmarket/domain/core/model/model_data/notification.dart';
import 'package:jetmarket/infrastructure/theme/app_colors.dart';
import 'package:jetmarket/presentation/notification/widget/card_notification.dart';
import 'package:jetmarket/utils/style/app_style.dart';

import '../../components/infiniti_page/infiniti_page.dart';
import 'controllers/notification.controller.dart';
import 'section/app_bar_section.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.updateUnreadNotification();
        return true;
      },
      child: Scaffold(
        backgroundColor: kWhite,
        body: CustomScrollView(
          slivers: [
            const AppBarNotification(),
            SliverPadding(
                padding: AppStyle.paddingAll16,
                sliver: PagedSliverList.separated(
                    pagingController: controller.pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<NotificationData>(
                      itemBuilder: (context, item, index) => CardNotification(
                        data: item,
                        onTap: () => controller.onTapNotification(item),
                      ),
                      newPageProgressIndicatorBuilder: InfinitiPage.progress,
                      firstPageProgressIndicatorBuilder: InfinitiPage.progress,
                      noItemsFoundIndicatorBuilder: (_) =>
                          InfinitiPage.empty(_, 'Notifikasi'),
                      firstPageErrorIndicatorBuilder: InfinitiPage.error,
                    ),
                    separatorBuilder: (_, i) => Gap(12.h))),
          ],
        ),
      ),
    );
  }
}
