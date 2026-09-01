import 'package:get/get.dart';

import '../controllers/admin_laporan_keuangan_controller.dart';

class AdminLaporanKeuanganBinding extends Bindings {
@override
void dependencies() {
Get.lazyPut<AdminLaporanKeuanganController>(
() => AdminLaporanKeuanganController(),
);
}
}
