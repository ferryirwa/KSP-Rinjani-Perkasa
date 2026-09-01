import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AdminPengaturanController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();
  final ImagePicker _picker = ImagePicker();

  final isLoading = false.obs;
  final isChangingPassword = false.obs;
  final isSavingSystem = false.obs;
  final isUploadingPhoto = false.obs;

  // Profil admin
  final adminName = 'Admin Koperasi'.obs;
  final adminEmail = 'admin@koperasi.test'.obs;
  final profileImagePath = ''.obs;
  final profileImageUrl = ''.obs;

  // Controller lama, tetap dipertahankan agar pengaturan koperasi lama tidak error
  final bungaController = TextEditingController();
  final tenorController = TextEditingController();
  final dendaController = TextEditingController();
  final limitController = TextEditingController();
  final simpananController = TextEditingController();

  // Ganti password
  final passwordLamaController = TextEditingController();
  final passwordBaruController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();

  // Pengaturan sistem
  final notifikasiAktif = true.obs;
  final keamananLogin = true.obs;
  final darkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPengaturan();
  }

  String _safeText(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  bool _safeBool(dynamic value, {bool fallback = false}) {
    if (value == null) return fallback;

    final text = value.toString().toLowerCase();

    return value == true ||
        value == 1 ||
        text == '1' ||
        text == 'true' ||
        text == 'aktif' ||
        text == 'yes';
  }

  Future<void> fetchPengaturan() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _adminRepository.getPengaturan(),
        _adminRepository.getAdminProfile(),
      ]);
      final data = results[0];
      final profile = results[1];

      // Data pengaturan koperasi lama
      bungaController.text = _safeText(data['bunga_pinjaman'], fallback: '0');
      tenorController.text = _safeText(data['tenor_default'], fallback: '12');
      dendaController.text =
          _safeText(data['denda_keterlambatan'], fallback: '0');
      limitController.text = _safeText(data['limit_pinjaman'], fallback: '0');
      simpananController.text =
          _safeText(data['simpanan_wajib'], fallback: '0');

      adminName.value = _safeText(
        profile['name'] ?? profile['nama'],
        fallback: 'Admin Koperasi',
      );

      adminEmail.value = _safeText(
        profile['email'],
        fallback: 'admin@koperasi.test',
      );

      profileImageUrl.value = _safeText(profile['profile_photo']);

      notifikasiAktif.value = _safeBool(
        data['notifikasi_aktif'],
        fallback: true,
      );

      keamananLogin.value = _safeBool(
        data['keamanan_login'],
        fallback: true,
      );

      darkMode.value = _safeBool(
        data['dark_mode'],
        fallback: false,
      );
    } on DioException catch (e) {
      String message = 'Gagal mengambil data pengaturan';

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
        'Terjadi kesalahan saat mengambil pengaturan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> save() async {
    try {
      isLoading.value = true;

      await _adminRepository.updatePengaturan({
        'bunga_pinjaman': bungaController.text.trim(),
        'tenor_default': tenorController.text.trim(),
        'denda_keterlambatan': dendaController.text.trim(),
        'limit_pinjaman': limitController.text.trim(),
        'simpanan_wajib': simpananController.text.trim(),
      });

      Get.snackbar(
        'Sukses',
        'Pengaturan berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      String message = 'Gagal menyimpan pengaturan';

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
        'Terjadi kesalahan saat menyimpan pengaturan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSystem() async {
    try {
      isSavingSystem.value = true;

      await _adminRepository.updatePengaturan({
        'bunga_pinjaman': bungaController.text.trim().isEmpty
            ? '0'
            : bungaController.text.trim(),
        'tenor_default': tenorController.text.trim().isEmpty
            ? '12'
            : tenorController.text.trim(),
        'denda_keterlambatan': dendaController.text.trim().isEmpty
            ? '0'
            : dendaController.text.trim(),
        'limit_pinjaman': limitController.text.trim().isEmpty
            ? '0'
            : limitController.text.trim(),
        'simpanan_wajib': simpananController.text.trim().isEmpty
            ? '0'
            : simpananController.text.trim(),
        'notifikasi_aktif': notifikasiAktif.value,
        'keamanan_login': keamananLogin.value,
        'dark_mode': darkMode.value,
      });

      Get.snackbar(
        'Sukses',
        'Pengaturan sistem berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      String message = 'Gagal menyimpan pengaturan sistem';

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
        'Terjadi kesalahan saat menyimpan pengaturan sistem',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSavingSystem.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked != null) {
      profileImagePath.value = picked.path;
    }
  }

  Future<void> uploadProfileImage() async {
  if (profileImagePath.value.isEmpty) {
    Get.snackbar(
      'Foto Kosong',
      'Pilih foto profil terlebih dahulu.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  try {
    isUploadingPhoto.value = true;

    await _adminRepository.uploadAdminPhoto(profileImagePath.value);
    Get.snackbar(
      'Berhasil',
      'Foto profil berhasil diupload.',
      snackPosition: SnackPosition.BOTTOM,
    );

    await fetchPengaturan();
  } on DioException catch (e) {
    String message = 'Gagal upload foto profil';

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
      'Terjadi kesalahan saat upload foto profil.',
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isUploadingPhoto.value = false;
  }
}

  Future<void> changePassword() async {
    final oldPassword = passwordLamaController.text.trim();
    final newPassword = passwordBaruController.text.trim();
    final confirmPassword = konfirmasiPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Data Belum Lengkap',
        'Semua kolom kata sandi wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Password Lemah',
        'Kata sandi baru minimal 6 karakter.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Tidak Sama',
        'Konfirmasi kata sandi tidak cocok.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
  isChangingPassword.value = true;

  await _adminRepository.changeAdminPassword(
    currentPassword: oldPassword,
    password: newPassword,
    passwordConfirmation: confirmPassword,
  );

  passwordLamaController.clear();
  passwordBaruController.clear();
  konfirmasiPasswordController.clear();

  Get.snackbar(
    'Berhasil',
    'Kata sandi berhasil diperbarui.',
    snackPosition: SnackPosition.BOTTOM,
  );
} on DioException catch (e) {
  String message = 'Gagal mengubah kata sandi';

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
    'Terjadi kesalahan saat mengubah kata sandi.',
    snackPosition: SnackPosition.BOTTOM,
  );
} finally {
  isChangingPassword.value = false;
}
  }

  void logout() {
    Get.defaultDialog(
      title: 'Keluar',
      middleText: 'Apakah Anda yakin ingin keluar dari akun admin?',
      textCancel: 'Batal',
      textConfirm: 'Keluar',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _logout();
      },
    );
  }

  Future<void> _logout() async {
    try {
      await _adminRepository.logout();
    } on DioException {
      // Token lokal tetap perlu dihapus ketika sesi di server sudah tidak valid.
    } catch (_) {
      // Logout tetap diselesaikan di perangkat saat koneksi bermasalah.
    } finally {
      await StorageService.clearToken();
      Get.offAllNamed(AppRoutes.adminLogin);
    }
  }

  @override
  void onClose() {
    bungaController.dispose();
    tenorController.dispose();
    dendaController.dispose();
    limitController.dispose();
    simpananController.dispose();

    passwordLamaController.dispose();
    passwordBaruController.dispose();
    konfirmasiPasswordController.dispose();

    super.onClose();
  }
}
