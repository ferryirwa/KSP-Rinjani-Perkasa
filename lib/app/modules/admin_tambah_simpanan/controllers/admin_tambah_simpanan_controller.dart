import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminTambahSimpananController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final jumlahController = TextEditingController();
  final tanggalController = TextEditingController();
  final keteranganController = TextEditingController();

  final isLoading = false.obs;
  final isLoadingAnggota = false.obs;

  final anggotas = <Map<String, dynamic>>[].obs;
  final selectedAnggotaId = Rxn<int>();
  final jenisSimpanan = 'wajib'.obs;

  @override
  void onInit() {
    super.onInit();
    tanggalController.text = DateTime.now().toIso8601String().split('T').first;
    fetchAnggota();
  }

  Future<void> fetchAnggota() async {
    try {
      isLoadingAnggota.value = true;

      final result = await _adminRepository.getAnggota();
      final data = result['data'] as List<dynamic>? ?? [];

      anggotas.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      if (anggotas.isNotEmpty) {
        selectedAnggotaId.value = int.tryParse(anggotas.first['id'].toString());
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal memuat daftar anggota.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingAnggota.value = false;
    }
  }

  Future<void> tambahSimpanan() async {
    final anggotaId = selectedAnggotaId.value;
    final jumlah = double.tryParse(jumlahController.text.trim()) ?? 0;
    final tanggal = tanggalController.text.trim();
    final keterangan = keteranganController.text.trim();

    if (anggotaId == null) {
      Get.snackbar(
        'Gagal',
        'Pilih anggota terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (jumlah < 1000) {
      Get.snackbar(
        'Gagal',
        'Jumlah simpanan minimal Rp 1.000.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (tanggal.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Tanggal simpanan wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      await _adminRepository.tambahSimpanan(
        anggotaId: anggotaId,
        jenisSimpanan: jenisSimpanan.value,
        jumlah: jumlah,
        tanggalSimpanan: tanggal,
        keterangan: keterangan,
      );

      Get.back(result: true);
    } on DioException catch (e) {
      String message = 'Gagal menambahkan simpanan.';

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
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menambahkan simpanan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    jumlahController.dispose();
    tanggalController.dispose();
    keteranganController.dispose();
    super.onClose();
  }
}
