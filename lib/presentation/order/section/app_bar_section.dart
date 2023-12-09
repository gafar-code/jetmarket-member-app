import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jetmarket/infrastructure/theme/app_colors.dart';
import 'package:jetmarket/presentation/order/controllers/order.controller.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app_text.dart';
import 'header_section.dart';

class AppBarDetailOrder extends StatelessWidget {
  final TabController tabController;
  final OrderController controller;
  final bool isScroll;

  const AppBarDetailOrder({
    Key? key,
    required this.tabController,
    required this.controller,
    required this.isScroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0.3,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      expandedHeight: 222,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              color: kWhite,
              height: 48.h,
              child: Row(
                children: [
                  Gap(16.w),
                  Text('Daftar Pesanan', style: text16BlackSemiBold),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.NOTIFICATION),
                    child: Icon(
                      Icons.notifications,
                      color: const Color(0xff333333).withOpacity(0.4),
                    ),
                  ),
                  Gap(16.w),
                ],
              ),
            ),
            Divider(
              color: kBorder,
              height: 0,
              thickness: 1,
            ),
            HeaderSection(controller: controller)
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(bottom: BorderSide(color: kDivider)),
          ),
          child: TabBar(
            isScrollable: true,
            controller: tabController,
            labelStyle: text14PrimarySemiBold,
            indicatorColor: kSecondaryColor,
            labelColor: kSecondaryColor,
            unselectedLabelColor: kSofterGrey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: controller.tabs.map((e) {
              return Tab(
                text: e,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
