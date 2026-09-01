import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class PinjamanController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cacheKey = 'pinjaman';

  final isLoading = false.obs;
  final pinjamans = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchPinjaman();
  }

  void _loadCachedData() {
    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    final data = cached['data'] as List<dynamic>? ?? [];
    pinjamans.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> fetchPinjaman() async {
    final hasCachedData = pinjamans.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getPinjaman();
      final data = result['data'] as List<dynamic>? ?? [];

      pinjamans.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat data pinjaman.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat pinjaman.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }
}
