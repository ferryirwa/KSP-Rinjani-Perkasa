import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminDashboardController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final isLoading = false.obs;
  final summary = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;

      final result = await _adminRepository.getDashboard();
      summary.value = Map<String, dynamic>.from(result['summary'] ?? {});
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat dashboard admin.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat dashboard admin.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
