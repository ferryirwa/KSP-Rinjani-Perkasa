import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../routes/app_routes.dart';

import '../../../data/repositories/anggota_repository.dart';
import '../../../data/services/menu_cache_service.dart';

class ProfilController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();
  static const String _cacheKey = 'profil';

  final isLoading = false.obs;
  final isSaving = false.obs;

  final anggota = Rxn<Map<String, dynamic>>();
  final summary = Rxn<Map<String, dynamic>>();

  final noHpController = TextEditingController();
  final alamatController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

final isUploadingPhoto = false.obs;
final profileImagePath = ''.obs;
final profileImageUrl = ''.obs;

final oldPasswordController = TextEditingController();
final newPasswordController = TextEditingController();
final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchProfil();
  }

  void _loadCachedData() {
    final cached = MenuCacheService.instance.readMap(_cacheKey);

    if (cached == null) {
      return;
    }

    anggota.value = Map<String, dynamic>.from(cached['anggota'] ?? {});
    summary.value = Map<String, dynamic>.from(cached['summary'] ?? {});

    noHpController.text = anggota.value?['no_hp']?.toString() ?? '';
    alamatController.text = anggota.value?['alamat']?.toString() ?? '';
  }

  Future<void> fetchProfil() async {
    final hasCachedData = anggota.value != null || summary.value != null;

    try {
      if (!hasCachedData) {
        isLoading.value = true;
      }

      final result = await _anggotaRepository.getProfil();

      anggota.value = Map<String, dynamic>.from(result['anggota'] ?? {});
      summary.value = Map<String, dynamic>.from(result['summary'] ?? {});

      noHpController.text = anggota.value?['no_hp']?.toString() ?? '';
      alamatController.text = anggota.value?['alamat']?.toString() ?? '';
      MenuCacheService.instance.writeMap(_cacheKey, result);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memuat profil.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat profil.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!hasCachedData) {
        isLoading.value = false;
      }
    }
    final foto = anggota.value?['profile_photo'] ??
    anggota.value?['foto_profil'] ??
    anggota.value?['foto'] ??
    '';

profileImageUrl.value = foto.toString();
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

    final file = File(profileImagePath.value);

    if (!file.existsSync()) {
      Get.snackbar(
        'Gagal',
        'File foto tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Hubungkan ke API upload foto profil jika endpoint backend sudah tersedia.
    // Contoh:
    // await _repository.uploadFotoProfil(profileImagePath.value);

    Get.snackbar(
      'Berhasil',
      'Foto profil berhasil dipilih.',
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

void showChangePasswordDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('Ubah Kata Sandi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata Sandi Lama',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata Sandi Baru',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Konfirmasi Kata Sandi Baru',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: changePassword,
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

Future<void> changePassword() async {
  final oldPassword = oldPasswordController.text.trim();
  final newPassword = newPasswordController.text.trim();
  final confirmPassword = confirmPasswordController.text.trim();

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

  Get.back();

  oldPasswordController.clear();
  newPasswordController.clear();
  confirmPasswordController.clear();

  Get.snackbar(
    'Berhasil',
    'Validasi kata sandi berhasil. Hubungkan endpoint backend agar tersimpan.',
    snackPosition: SnackPosition.BOTTOM,
  );
}

void logout() {
  Get.defaultDialog(
    title: 'Keluar',
    middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
    textCancel: 'Batal',
    textConfirm: 'Keluar',
    confirmTextColor: Colors.white,
    onConfirm: () async {
      Get.back();

      // Kalau kamu punya StorageService, hapus token di sini.
      // Contoh:
      // await StorageService.clear();

      Get.offAllNamed(AppRoutes.login);
    },
  );
}

  Future<void> simpanProfil() async {
    try {
      isSaving.value = true;

      final result = await _anggotaRepository.updateProfil(
        noHp: noHpController.text.trim(),
        alamat: alamatController.text.trim(),
      );

      anggota.value = Map<String, dynamic>.from(result['anggota'] ?? {});
      summary.value = Map<String, dynamic>.from(result['summary'] ?? summary.value ?? {});

      final cachedResult = Map<String, dynamic>.from(result);
      cachedResult['summary'] = summary.value ?? {};
      MenuCacheService.instance.writeMap(_cacheKey, cachedResult);

      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal memperbarui profil.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memperbarui profil.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    noHpController.dispose();
    alamatController.dispose();
    super.onClose();
    oldPasswordController.dispose();
newPasswordController.dispose();
confirmPasswordController.dispose();
  }
}
