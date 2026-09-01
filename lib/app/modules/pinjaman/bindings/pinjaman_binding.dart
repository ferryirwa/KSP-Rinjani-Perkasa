import 'package:get/get.dart';

import '../controllers/pinjaman_controller.dart';

class PinjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinjamanController>(() => PinjamanController());
  }
}