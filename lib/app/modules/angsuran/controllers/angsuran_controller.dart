
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class AngsuranController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();

  final isLoading = false.obs;
  final isPaying = false.obs;
  final angsurans = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAngsuran();
  }

  double get totalTagihan {
    return angsurans.fold(0, (total, item) {
      final value = double.tryParse(item['jumlah_tagihan'].toString()) ?? 0;
      return total + value;
    });
  }

  double get totalBayar {
    return angsurans.fold(0, (total, item) {
      final value = double.tryParse(item['jumlah_bayar'].toString()) ?? 0;
      return total + value;
    });
  }

  double get totalBelumBayar {
    final sisa = totalTagihan - totalBayar;
    return sisa < 0 ? 0 : sisa;
  }

  int get totalTerlambat {
    return angsurans.where((item) {
      return item['status']?.toString() == 'terlambat';
    }).length;
  }

  Future<void> fetchAngsuran() async {
    final hasCachedData = angsurans.isNotEmpty;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getAngsuran();
      final data = result['data'] as List<dynamic>? ?? [];

      angsurans.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException catch (e) {
      String message = 'Gagal memuat data angsuran.';

      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data is Map && data['errors'] != null) {
        message = data['errors'].toString();
      }

      Get.snackbar(
        'Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data angsuran.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
  }

  Future<void> bayarDemo(dynamic id) async {
    try {
      isPaying.value = true;

      await _anggotaRepository.bayarAngsuranDemo(id);

      await fetchAngsuran();

      Get.snackbar(
        'Berhasil',
        'Pembayaran angsuran berhasil dicatat.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      String message = 'Gagal membayar angsuran.';

      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data is Map && data['errors'] != null) {
        message = data['errors'].toString();
      }

      Get.snackbar(
        'Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat membayar angsuran.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPaying.value = false;
    }
  }
}
