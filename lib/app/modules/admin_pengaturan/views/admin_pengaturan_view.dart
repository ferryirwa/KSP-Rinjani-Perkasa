import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_pengaturan_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminPengaturanView extends GetView<AdminPengaturanController> {
  const AdminPengaturanView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color red = AppColors.danger;
  static const Color orange = AppColors.warning;

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengaturan Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Profil, keamanan, dan sistem koperasi',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      color: cardColor,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: primary, size: 21),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 1.3),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: dark,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        decoration: _inputDecoration(
          label: label,
          icon: icon,
        ),
      ),
    );
  }

  Widget _profileCard() {
    return _card(
      children: [
        _sectionTitle('Profil Admin', Icons.admin_panel_settings_rounded),
        Row(
          children: [
            Obx(() {
              final imagePath = controller.profileImagePath.value;
              final imageUrl = controller.profileImageUrl.value;
              final hasLocalImage = imagePath.isNotEmpty;
              final hasRemoteImage = imageUrl.isNotEmpty;

              return Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: primary.withValues(alpha: 0.12),
                    backgroundImage: hasLocalImage
                        ? FileImage(File(imagePath))
                        : hasRemoteImage
                            ? NetworkImage(imageUrl)
                            : null,
                    child: !hasLocalImage && !hasRemoteImage
                        ? const Icon(
                            Icons.person_rounded,
                            color: primary,
                            size: 42,
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: controller.pickProfileImage,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.adminName.value.isEmpty
                          ? 'Admin Koperasi'
                          : controller.adminName.value,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.adminEmail.value.isEmpty
                          ? 'admin@koperasi.test'
                          : controller.adminEmail.value,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: Obx(
                      () => OutlinedButton.icon(
                        onPressed: controller.isUploadingPhoto.value
                            ? null
                            : controller.uploadProfileImage,
                        icon: controller.isUploadingPhoto.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.cloud_upload_rounded, size: 16),
                        label: Text(
                          controller.isUploadingPhoto.value
                              ? 'Mengunggah...'
                              : 'Upload Foto',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primary,
                          side: const BorderSide(color: primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _passwordCard() {
    return _card(
      children: [
        _sectionTitle('Ganti Kata Sandi', Icons.lock_rounded),
        _field(
          controller: controller.passwordLamaController,
          label: 'Kata Sandi Lama',
          icon: Icons.lock_outline_rounded,
          obscureText: true,
        ),
        _field(
          controller: controller.passwordBaruController,
          label: 'Kata Sandi Baru',
          icon: Icons.lock_reset_rounded,
          obscureText: true,
        ),
        _field(
          controller: controller.konfirmasiPasswordController,
          label: 'Konfirmasi Kata Sandi Baru',
          icon: Icons.verified_user_rounded,
          obscureText: true,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isChangingPassword.value
                  ? null
                  : controller.changePassword,
              icon: controller.isChangingPassword.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(
                controller.isChangingPassword.value
                    ? 'Menyimpan...'
                    : 'Simpan Kata Sandi',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: primary.withValues(alpha: 0.55),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _systemTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _systemSettingsCard() {
    return _card(
      children: [
        _sectionTitle('Pengaturan Sistem', Icons.tune_rounded),
        Obx(
          () => _systemTile(
            icon: Icons.notifications_active_rounded,
            title: 'Notifikasi Sistem',
            subtitle: 'Aktifkan pengingat dan informasi transaksi',
            trailing: Switch(
              value: controller.notifikasiAktif.value,
              activeThumbColor: primary,
              onChanged: (value) {
                controller.notifikasiAktif.value = value;
              },
            ),
          ),
        ),
        Obx(
          () => _systemTile(
            icon: Icons.lock_person_rounded,
            title: 'Keamanan Login',
            subtitle: 'Aktifkan perlindungan keamanan tambahan',
            trailing: Switch(
              value: controller.keamananLogin.value,
              activeThumbColor: primary,
              onChanged: (value) {
                controller.keamananLogin.value = value;
              },
            ),
          ),
        ),
        Obx(
          () => _systemTile(
            icon: Icons.dark_mode_rounded,
            title: 'Mode Gelap',
            subtitle: 'Ubah tampilan aplikasi menjadi gelap',
            trailing: Switch(
              value: controller.darkMode.value,
              activeThumbColor: primary,
              onChanged: (value) {
                controller.darkMode.value = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: Obx(
            () => ElevatedButton.icon(
              onPressed:
                  controller.isSavingSystem.value ? null : controller.saveSystem,
              icon: controller.isSavingSystem.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_as_rounded),
              label: Text(
                controller.isSavingSystem.value
                    ? 'Menyimpan...'
                    : 'Simpan Pengaturan Sistem',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: primary.withValues(alpha: 0.55),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _appInfoCard() {
    return _card(
      children: [
        _sectionTitle('Informasi Aplikasi', Icons.info_rounded),
        _infoRow('Nama Aplikasi', 'KoperasiKu'),
        _infoRow('Versi', '1.0.0'),
        _infoRow('Role', 'Admin'),
        _infoRow('Status Sistem', 'Aktif'),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: dark,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: controller.logout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: red,
          side: const BorderSide(color: red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBrown,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchPengaturan,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _header(),
                _profileCard(),
                _passwordCard(),
                _systemSettingsCard(),
                _appInfoCard(),
                _logoutButton(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
