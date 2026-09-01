import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../routes/app_routes.dart';

class AdminAnggotaController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final anggotas = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnggota();
  }

  Future<void> fetchAnggota() async {
    try {
      isLoading.value = true;

      final result = await _adminRepository.getAnggota();
      final data = result['data'] as List<dynamic>? ?? [];

      anggotas.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException catch (e) {
      String message = 'Gagal memuat data anggota.';

      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }

      Get.snackbar(
        'Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data anggota.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToTambahAnggota() async {
  final result = await Get.toNamed(AppRoutes.adminTambahAnggota);

  if (result == true) {
    await fetchAnggota();

    Get.snackbar(
      'Berhasil',
      'Akun anggota baru berhasil ditambahkan.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}

  Future<bool> updateAnggota({
    required dynamic id,
    required String nomorAnggota,
    required String nama,
    required String email,
    required String password,
    required String noHp,
    required String alamat,
    required String status,
  }) async {
    if (id == null) {
      Get.snackbar(
        'Gagal',
        'ID anggota tidak valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (nomorAnggota.isEmpty || nama.isEmpty || email.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Nomor anggota, nama, dan email wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (password.isNotEmpty && password.length < 6) {
      Get.snackbar(
        'Gagal',
        'Password minimal 6 karakter.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isSubmitting.value = true;

      await _adminRepository.updateAnggota(
        id: id,
        nomorAnggota: nomorAnggota,
        nama: nama,
        email: email,
        password: password,
        noHp: noHp,
        alamat: alamat,
        status: status,
      );

      await fetchAnggota();

      Get.snackbar(
        'Berhasil',
        'Data anggota berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        _messageFromDio(e, 'Gagal memperbarui data anggota.'),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memperbarui data anggota.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> hapusAnggota(dynamic id) async {
    if (id == null) {
      Get.snackbar(
        'Gagal',
        'ID anggota tidak valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isSubmitting.value = true;

      await _adminRepository.hapusAnggota(id);
      anggotas.removeWhere((anggota) => anggota['id'] == id);

      Get.snackbar(
        'Berhasil',
        'Data anggota berhasil dihapus.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        _messageFromDio(e, 'Gagal menghapus data anggota.'),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghapus data anggota.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  String _messageFromDio(DioException e, String fallback) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (data is Map && data['errors'] != null) {
      return data['errors'].toString();
    }

    return fallback;
  }
}
