import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminTambahAnggotaController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final nomorAnggotaController = TextEditingController();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final noHpController = TextEditingController();
  final alamatController = TextEditingController();

  final status = 'aktif'.obs;
  final isLoading = false.obs;

  Future<void> tambahAnggota() async {
    final nomorAnggota = nomorAnggotaController.text.trim();
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final noHp = noHpController.text.trim();
    final alamat = alamatController.text.trim();

    if (nomorAnggota.isEmpty ||
        nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Nomor anggota, nama, email, dan password wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Gagal',
        'Password minimal 6 karakter.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      await _adminRepository.tambahAnggota(
        nomorAnggota: nomorAnggota,
        nama: nama,
        email: email,
        password: password,
        noHp: noHp,
        alamat: alamat,
        status: status.value,
      );
      Get.back(result: true);
    } on DioException catch (e) {
      String message = 'Gagal membuat akun anggota.';

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
        'Terjadi kesalahan saat membuat akun anggota.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nomorAnggotaController.dispose();
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    super.onClose();
  }
}
