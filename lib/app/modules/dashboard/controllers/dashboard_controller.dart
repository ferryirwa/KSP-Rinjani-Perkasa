import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class DashboardController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cacheKey = 'dashboard';

  final isLoading = false.obs;
  final anggota = Rxn<Map<String, dynamic>>();
  final summary = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchDashboard();
  }

  void _loadCachedData() {
    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    anggota.value = Map<String, dynamic>.from(cached['anggota'] ?? {});
    summary.value = Map<String, dynamic>.from(cached['summary'] ?? {});
  }

  Future<void> _prefetchMenuCaches() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final endpoints =
        <MapEntry<String, Future<Map<String, dynamic>> Function()>>[
      MapEntry('simpanan', _anggotaRepository.getSimpanan),
      MapEntry('pinjaman', _anggotaRepository.getPinjaman),
      MapEntry('angsuran', _anggotaRepository.getAngsuran),
      MapEntry('transaksi', _anggotaRepository.getTransaksi),
      MapEntry('tracking_status', _anggotaRepository.getTrackingStatus),
      MapEntry('notifikasi', _anggotaRepository.getNotifikasi),
      MapEntry('profil', _anggotaRepository.getProfil),
    ];

    for (final endpoint in endpoints) {
      await _cacheEndpoint(endpoint.key, endpoint.value());
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
  }

  Future<void> _cacheEndpoint(
    String key,
    Future<Map<String, dynamic>> future,
  ) async {
    try {
      final result = await future;
      MenuCacheService.instance.writeMap(key, result);
    } catch (_) {}
  }

  Future<void> fetchDashboard() async {
    final hasCachedData = anggota.value != null || summary.value != null;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getDashboard();

      anggota.value = Map<String, dynamic>.from(result['anggota'] ?? {});
      summary.value = Map<String, dynamic>.from(result['summary'] ?? {});
      MenuCacheService.instance.writeMap(_cacheKey, result);
      unawaited(_prefetchMenuCaches());
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat dashboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat dashboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }
}
