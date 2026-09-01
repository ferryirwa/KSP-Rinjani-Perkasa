import 'package:get/get.dart';

import '../controllers/angsuran_controller.dart';

class AngsuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AngsuranController>(() => AngsuranController());
  }
}