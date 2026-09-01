import 'package:get/get.dart';

import '../controllers/tracking_angsuran_controller.dart';

class TrackingAngsuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingAngsuranController>(
      () => TrackingAngsuranController(),
    );
  }
}
