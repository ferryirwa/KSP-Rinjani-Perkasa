import 'package:get/get.dart';

import '../controllers/admin_tambah_simpanan_controller.dart';

class AdminTambahSimpananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminTambahSimpananController>(
      () => AdminTambahSimpananController(),
    );
  }
}