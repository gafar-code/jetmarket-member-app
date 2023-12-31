import 'package:get/get.dart';

import '../../../../presentation/koperasi_pages/koperasi/controllers/koperasi.controller.dart';

class KoperasiControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KoperasiController>(
      () => KoperasiController(),
    );
  }
}
