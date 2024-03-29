import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jetmarket/domain/core/model/model_data/cart_product.dart';
import 'package:jetmarket/presentation/home_pages/cart/section/cart_product.dart';
import 'package:jetmarket/presentation/home_pages/cart/section/select_all_product.dart';

import '../../../components/infiniti_page/infiniti_page.dart';
import '../../../utils/style/app_style.dart';
import 'controllers/cart.controller.dart';
import 'section/app_bar_section.dart';
import 'section/footer_section.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AppBarCart(),
          const SelectAllProduct(),
          SliverPadding(
            padding: AppStyle.paddingAll16,
            sliver: GetBuilder<CartController>(builder: (controller) {
              return PagedSliverList.separated(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<CartProduct>(
                  itemBuilder: (context, item, index) {
                    return CardProduct(
                      data: item,
                      index: index,
                    );
                  },
                  newPageProgressIndicatorBuilder: InfinitiPage.progress,
                  firstPageProgressIndicatorBuilder: InfinitiPage.progress,
                  noItemsFoundIndicatorBuilder: (_) =>
                      InfinitiPage.empty(_, 'Produk'),
                  firstPageErrorIndicatorBuilder: InfinitiPage.error,
                ),
                separatorBuilder: (_, i) => Gap(12.h),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const FooterSection(),
    );
  }
}
