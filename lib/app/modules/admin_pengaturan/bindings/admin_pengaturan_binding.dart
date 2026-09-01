import 'package:get/get.dart';
import '../controllers/admin_pengaturan_controller.dart';

class AdminPengaturanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPengaturanController>(
      () => AdminPengaturanController(),
    );
  }
}