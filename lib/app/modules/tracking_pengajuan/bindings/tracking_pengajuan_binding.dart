import 'package:get/get.dart';

import '../controllers/tracking_pengajuan_controller.dart';

class TrackingPengajuanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingPengajuanController>(
      () => TrackingPengajuanController(),
    );
  }
}
