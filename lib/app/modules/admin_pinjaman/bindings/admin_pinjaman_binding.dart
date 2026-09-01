import 'package:get/get.dart';

import '../controllers/admin_pinjaman_controller.dart';

class AdminPinjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPinjamanController>(() => AdminPinjamanController());
  }
}