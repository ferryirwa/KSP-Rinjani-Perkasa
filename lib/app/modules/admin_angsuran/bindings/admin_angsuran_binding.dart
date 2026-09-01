import 'package:get/get.dart';

import '../controllers/admin_angsuran_controller.dart';

class AdminAngsuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminAngsuranController>(() => AdminAngsuranController());
  }
}