import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:jetmarket/infrastructure/theme/app_colors.dart';
import 'package:jetmarket/presentation/home_pages/home/section/app_bar_section.dart';
import 'package:jetmarket/presentation/home_pages/home/section/banner_section.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'controllers/home.controller.dart';
import 'section/category_section.dart';
import 'section/product_popular_onpage.dart';
import 'section/product_popular_section.dart';
import 'section/product_section.dart';
import 'section/search_section.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isHomeScreen.value
          ? _homePageSection()
          : _popularPage();
    });
  }

  Widget _homePageSection() {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
          appBar: appBarHome,
          backgroundColor: kWhite,
          body: SafeArea(
              child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  header: const WaterDropHeader(
                    waterDropColor: kPrimaryColor,
                    complete: SizedBox.shrink(),
                    refresh: CupertinoActivityIndicator(
                      color: kSoftGrey,
                    ),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SearchSection(controller: controller),
                      const BannerSection(),
                      const CategorySection(),
                      ProductPopularSection(controller: controller),
                      ProductSection(controller: controller),
                      SliverToBoxAdapter(child: Gap(16.h)),
                    ],
                  )))),
    );
  }

  Widget _popularPage() {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.seeAllPopular();
        return false;
      },
      child: Scaffold(
          appBar: appBarHome,
          backgroundColor: kWhite,
          body: SafeArea(
              child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  header: const WaterDropHeader(
                    waterDropColor: kPrimaryColor,
                    complete: SizedBox.shrink(),
                    refresh: CupertinoActivityIndicator(
                      color: kSoftGrey,
                    ),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SearchSection(controller: controller),
                      ProductPopularOnPageSection(controller: controller),
                      SliverToBoxAdapter(child: Gap(16.h)),
                    ],
                  )))),
    );
  }
}
