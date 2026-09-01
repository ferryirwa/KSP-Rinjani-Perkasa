import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class TrackingPengajuanController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cachePrefix = 'tracking_pengajuan';

  final isLoading = false.obs;
  final pinjaman = Rxn<Map<String, dynamic>>();
  final tracking = <Map<String, dynamic>>[].obs;

  dynamic pinjamanId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args is Map<String, dynamic>) {
      pinjamanId = args['pinjaman_id'];
      _loadCachedData();
      fetchTrackingPengajuan();
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
    final data = cached['tracking'] as List<dynamic>? ?? [];
    tracking.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> fetchTrackingPengajuan() async {
    if (pinjamanId == null) {
      Get.snackbar(
        'Gagal',
        'ID pinjaman tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final hasCachedData = pinjaman.value != null || tracking.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result =
          await _anggotaRepository.getTrackingPengajuanPinjaman(pinjamanId);

      pinjaman.value = Map<String, dynamic>.from(result['pinjaman'] ?? {});

      final data = result['tracking'] as List<dynamic>? ?? [];
      tracking.value =
          data.map((item) => Map<String, dynamic>.from(item)).toList();
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat tracking pengajuan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat tracking pengajuan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }
}
