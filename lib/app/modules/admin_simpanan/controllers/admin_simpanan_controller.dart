import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../routes/app_routes.dart';

class AdminSimpananController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final isLoading = false.obs;
  final simpanans = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSimpanan();
  }

  Future<void> fetchSimpanan() async {
    try {
      isLoading.value = true;

      final result = await _adminRepository.getSimpanan();
      final data = result['data'] as List<dynamic>? ?? [];

      simpanans.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException catch (e) {
      String message = 'Gagal memuat data simpanan.';

      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }

      Get.snackbar(
        'Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data simpanan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToTambahSimpanan() async {
    final result = await Get.toNamed(AppRoutes.adminTambahSimpanan);

    if (result == true) {
      await fetchSimpanan();

      Get.snackbar(
        'Berhasil',
        'Simpanan anggota berhasil ditambahkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
