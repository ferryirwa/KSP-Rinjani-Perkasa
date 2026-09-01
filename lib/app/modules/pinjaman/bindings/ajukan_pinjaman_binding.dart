import 'package:get/get.dart';

import '../controllers/ajukan_pinjaman_controller.dart';

class AjukanPinjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AjukanPinjamanController>(
      () => AjukanPinjamanController(),
    );
  }
}