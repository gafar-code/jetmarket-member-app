import 'package:get/get.dart';
import 'package:jetmarket/infrastructure/dal/repository/saving_repository_impl.dart';

import '../../../../presentation/koperasi_pages/detail_menabung/controllers/detail_menabung.controller.dart';

class DetailMenabungControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMenabungController>(
      () => DetailMenabungController(SavingRepositoryImpl()),
    );
  }
}
