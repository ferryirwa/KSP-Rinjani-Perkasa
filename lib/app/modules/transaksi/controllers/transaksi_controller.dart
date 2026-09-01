import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class TransaksiController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cacheKey = 'transaksi';

  final isLoading = false.obs;
  final transaksis = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchTransaksi();
  }

  void _loadCachedData() {
    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    final data = cached['data'] as List<dynamic>? ?? [];
    transaksis.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> fetchTransaksi() async {
    final hasCachedData = transaksis.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getTransaksi();
      final data = result['data'] as List<dynamic>? ?? [];

      transaksis.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat riwayat transaksi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat riwayat transaksi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }
}
