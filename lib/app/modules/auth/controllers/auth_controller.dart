import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/firebase_notification_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

enum LoginRole { admin, anggota }

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final AdminRepository _adminRepository = AdminRepository();

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final selectedRole = LoginRole.anggota.obs;

  void selectRole(LoginRole role) {
    selectedRole.value = role;
  }

  Future<void> login() async {
    final login = loginController.text.trim();
    final password = passwordController.text.trim();
    final role = selectedRole.value;

    if (login.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Gagal',
        role == LoginRole.admin
            ? 'Email admin dan password wajib diisi.'
            : 'Email/nomor anggota dan password wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final firebaseToken =
          await FirebaseNotificationService.instance.getToken();

      final result = role == LoginRole.admin
          ? await _adminRepository.login(
              email: login,
              password: password,
            )
          : await _authRepository.login(
              login: login,
              password: password,
              firebaseToken: firebaseToken,
            );

      final token = result['token'];

      if (token == null) {
        Get.snackbar(
          'Gagal',
          role == LoginRole.admin
              ? 'Token admin tidak ditemukan.'
              : 'Token tidak ditemukan dari server.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await StorageService.saveToken(token.toString());

      if (role == LoginRole.anggota) {
        await FirebaseNotificationService.instance.syncTokenAfterLogin();
      }

      Get.snackbar(
        'Login Berhasil',
        role == LoginRole.admin
            ? 'Selamat datang kembali, Admin.'
            : 'Selamat datang kembali. Data akun Anda siap digunakan.',
      );

      await Future<void>.delayed(const Duration(milliseconds: 700));

      Get.offAllNamed(
        role == LoginRole.admin
            ? AppRoutes.adminDashboard
            : AppRoutes.dashboard,
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        _messageFromDio(e, role),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } on FormatException catch (e) {
      if (kDebugMode) {
        debugPrint('[LOGIN] $e');
      }

      Get.snackbar(
        'Gagal',
        'Server mengembalikan respons yang tidak valid. Pastikan endpoint API Laravel aktif dan mengembalikan JSON.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[LOGIN] Error tidak terduga: $e');
        debugPrintStack(stackTrace: stackTrace);
      }

      Get.snackbar(
        'Error',
        'Terjadi kesalahan pada aplikasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    loginController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String _messageFromDio(DioException error, LoginRole role) {
    final data = error.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (data is Map && data['errors'] != null) {
      return data['errors'].toString();
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Tidak bisa terhubung ke server. Pastikan backend aktif dan alamat API benar.';
    }

    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Server terlalu lama merespons. Coba lagi beberapa saat.';
    }

    return role == LoginRole.admin
        ? 'Login admin gagal.'
        : 'Login gagal. Periksa kembali data Anda.';
  }
}
