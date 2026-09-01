import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class SimpananController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cacheKey = 'simpanan';

  final isLoading = false.obs;
  final simpanans = <Map<String, dynamic>>[].obs;

  double get totalSimpanan {
    double total = 0;

    for (final item in simpanans) {
      total += double.tryParse(item['jumlah'].toString()) ?? 0;
    }

    return total;
  }

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchSimpanan();
  }

  void _loadCachedData() {
    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    final data = cached['data'] as List<dynamic>? ?? [];
    simpanans.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> fetchSimpanan() async {
    final hasCachedData = simpanans.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getSimpanan();
      final data = result['data'] as List<dynamic>? ?? [];

      simpanans.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat data simpanan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat simpanan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }
}
