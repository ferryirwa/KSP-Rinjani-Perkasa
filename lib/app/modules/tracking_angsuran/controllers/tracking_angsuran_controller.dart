import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class TrackingAngsuranController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cachePrefix = 'tracking_angsuran';

  final isLoading = false.obs;
  final pinjaman = Rxn<Map<String, dynamic>>();
  final angsurans = <Map<String, dynamic>>[].obs;

  dynamic pinjamanId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args is Map<String, dynamic>) {
      pinjamanId = args['pinjaman_id'];
      _loadCachedData();
      fetchTrackingAngsuran();
    }
  }

  String get _cacheKey => '${_cachePrefix}_$pinjamanId';

  void _loadCachedData() {
    if (pinjamanId == null) {
      return;
    }

    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    pinjaman.value = Map<String, dynamic>.from(cached['pinjaman'] ?? {});
    final data = cached['angsuran'] as List<dynamic>? ?? [];
    angsurans.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> fetchTrackingAngsuran() async {
    if (pinjamanId == null) {
      Get.snackbar(
        'Gagal',
        'ID pinjaman tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final hasCachedData = pinjaman.value != null || angsurans.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result =
          await _anggotaRepository.getTrackingAngsuranPinjaman(pinjamanId);

      pinjaman.value = Map<String, dynamic>.from(result['pinjaman'] ?? {});

      final data = result['angsuran'] as List<dynamic>? ?? [];
      angsurans.value =
          data.map((item) => Map<String, dynamic>.from(item)).toList();
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat tracking angsuran.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat tracking angsuran.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }
}
