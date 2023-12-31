import 'package:get/get.dart';

import '../../../../presentation/order_pages/review_order/controllers/review_order.controller.dart';

class ReviewOrderControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewOrderController>(
      () => ReviewOrderController(),
    );
  }
}
