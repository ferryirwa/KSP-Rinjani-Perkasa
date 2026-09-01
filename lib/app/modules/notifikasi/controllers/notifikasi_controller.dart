import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class NotifikasiController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cacheKey = 'notifikasi';

  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final unreadCount = 0.obs;
  final notifikasis = <Map<String, dynamic>>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchNotifikasi();

    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => fetchNotifikasi(showError: false),
    );
  }

  void _loadCachedData() {
    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    unreadCount.value =
        int.tryParse((cached['unread_count'] ?? 0).toString()) ?? 0;

    final data = cached['data'] as List<dynamic>? ?? [];
    notifikasis.value =
        data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> fetchNotifikasi({bool showError = true}) async {
    final hasCachedData = notifikasis.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getNotifikasi();
      final data = result['data'] as List<dynamic>? ?? [];

      unreadCount.value = int.tryParse(
            (result['unread_count'] ?? 0).toString(),
          ) ??
          0;

      notifikasis.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      if (showError) {
        Get.snackbar(
          'Gagal',
          e.response?.data['message'] ?? 'Gagal memuat notifikasi.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (showError) {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat memuat notifikasi.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }

  Future<void> tandaiDibaca(dynamic id) async {
    try {
      isActionLoading.value = true;

      await _anggotaRepository.bacaNotifikasi(id);
      await fetchNotifikasi(showError: false);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menandai notifikasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> tandaiSemuaDibaca() async {
    try {
      isActionLoading.value = true;

      await _anggotaRepository.bacaSemuaNotifikasi();
      await fetchNotifikasi(showError: false);

      Get.snackbar(
        'Berhasil',
        'Semua notifikasi ditandai sudah dibaca.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menandai semua notifikasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  bool sudahDibaca(Map<String, dynamic> item) {
    final value = item['dibaca'];

    return value == true || value.toString() == '1';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
