import 'package:get/get.dart';

import '../controllers/simpanan_controller.dart';

class SimpananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SimpananController>(() => SimpananController());
  }
}