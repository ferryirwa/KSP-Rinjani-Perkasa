
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminAngsuranController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final isLoading = false.obs;
  final isPaying = false.obs;

  final angsurans = <Map<String, dynamic>>[].obs;
  final selectedFilter = 'semua'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAngsuran();
  }

  List<Map<String, dynamic>> get filteredAngsurans {
    if (selectedFilter.value == 'semua') {
      return angsurans;
    }

    return angsurans.where((item) {
      return item['status']?.toString() == selectedFilter.value;
    }).toList();
  }

  int countByStatus(String status) {
    return angsurans.where((item) {
      return item['status']?.toString() == status;
    }).length;
  }

  double get totalTagihan {
    return filteredAngsurans.fold(0, (total, item) {
      final value = double.tryParse(item['jumlah_tagihan'].toString()) ?? 0;
      return total + value;
    });
  }

  double get totalBayar {
    return filteredAngsurans.fold(0, (total, item) {
      final value = double.tryParse(item['jumlah_bayar'].toString()) ?? 0;
      return total + value;
    });
  }

  Future<void> fetchAngsuran() async {
    try {
      isLoading.value = true;

      final result = await _adminRepository.getAngsuran();
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
      isLoading.value = false;
    }
  }

  void changeFilter(String value) {
    selectedFilter.value = value;
  }

  void konfirmasiBayar(Map<String, dynamic> angsuran) {
    final id = angsuran['id'];
    final angsuranKe = angsuran['angsuran_ke']?.toString() ?? '-';

    Get.defaultDialog(
      title: 'Konfirmasi Pembayaran',
      middleText:
          'Apakah angsuran ke-$angsuranKe sudah dibayar dan ingin dicatat lunas?',
      textCancel: 'Batal',
      textConfirm: 'Ya, Lunaskan',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        bayarAngsuran(id);
      },
    );
  }

  Future<void> bayarAngsuran(dynamic id) async {
    try {
      isPaying.value = true;

      await _adminRepository.bayarAngsuran(id);

      await fetchAngsuran();

      Get.snackbar(
        'Berhasil',
        'Pembayaran angsuran berhasil dikonfirmasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      String message = 'Gagal mengonfirmasi pembayaran angsuran.';

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
        'Terjadi kesalahan saat mengonfirmasi pembayaran.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPaying.value = false;
    }
  }
}
