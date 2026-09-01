import 'package:get/get.dart';

import '../controllers/admin_tambah_anggota_controller.dart';

class AdminTambahAnggotaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminTambahAnggotaController>(
      () => AdminTambahAnggotaController(),
    );
  }
}