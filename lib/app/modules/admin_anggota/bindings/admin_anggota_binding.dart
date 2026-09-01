import 'package:get/get.dart';

import '../controllers/admin_anggota_controller.dart';

class AdminAnggotaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminAnggotaController>(() => AdminAnggotaController());
  }
}