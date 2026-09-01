import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AdminAuthController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Email dan password admin wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final result = await _adminRepository.login(
        email: email,
        password: password,
      );

      final token = result['token'];

      if (token == null) {
        Get.snackbar(
          'Gagal',
          'Token admin tidak ditemukan.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await StorageService.saveToken(token.toString());

      Get.snackbar(
        'Login Berhasil',
        'Selamat datang kembali, Admin.',
      );

      await Future<void>.delayed(const Duration(milliseconds: 700));

      Get.offAllNamed(AppRoutes.adminDashboard);
    } on DioException catch (e) {
      String message = 'Login admin gagal.';

      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data is Map && data['errors'] != null) {
        message = data['errors'].toString();
      } else if (e.message != null) {
        message = e.message.toString();
      }

      Get.snackbar(
        'Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FormatException catch (e) {
      if (kDebugMode) {
        debugPrint('[LOGIN ADMIN] $e');
      }

      Get.snackbar(
        'Gagal',
        'Server mengembalikan respons yang tidak valid. Pastikan endpoint API Laravel aktif dan mengembalikan JSON.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[LOGIN ADMIN] Error tidak terduga: $e');
        debugPrintStack(stackTrace: stackTrace);
      }

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat login admin.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
