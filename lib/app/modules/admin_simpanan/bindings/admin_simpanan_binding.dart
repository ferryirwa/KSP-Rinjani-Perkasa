import 'package:get/get.dart';

import '../controllers/admin_simpanan_controller.dart';

class AdminSimpananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminSimpananController>(() => AdminSimpananController());
  }
}