import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_tambah_anggota_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminTambahAnggotaView extends GetView<AdminTambahAnggotaController> {
  const AdminTambahAnggotaView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color red = AppColors.danger;

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
                  'Tambah Anggota',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Buat akun anggota koperasi baru',
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
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Lengkapi data anggota. Setelah disimpan, anggota dapat login menggunakan email atau nomor anggota.',
              style: TextStyle(
                color: dark,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formCard({required List<Widget> children}) {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(24),
      color: cardColor,
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

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        style: const TextStyle(
          color: dark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
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
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        initialValue: controller.status.value,
        decoration: InputDecoration(
          labelText: 'Status Akun',
          labelStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            controller.status.value == 'aktif'
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: controller.status.value == 'aktif' ? green : red,
          ),
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
        ),
        items: const [
          DropdownMenuItem(
            value: 'aktif',
            child: Text('Aktif'),
          ),
          DropdownMenuItem(
            value: 'nonaktif',
            child: Text('Nonaktif'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.status.value = value;
          }
        },
      ),
    );
  }

  Widget _saveButton() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: softBrown,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: controller.isLoading.value
                ? null
                : controller.tambahAnggota,
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.3,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              controller.isLoading.value
                  ? 'Menyimpan Data...'
                  : 'Simpan Anggota',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withValues(alpha: 0.55),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusPreview() {
    return Obx(() {
      final isAktif = controller.status.value == 'aktif';

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: isAktif ? green.withValues(alpha: 0.10) : red.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAktif
                ? green.withValues(alpha: 0.35)
                : red.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isAktif
                  ? Icons.check_circle_rounded
                  : Icons.info_rounded,
              color: isAktif ? green : red,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isAktif
                    ? 'Akun aktif dapat langsung digunakan untuk login.'
                    : 'Akun nonaktif tidak dapat login sampai status diaktifkan.',
                style: TextStyle(
                  color: isAktif ? green : red,
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBrown,
      bottomNavigationBar: _saveButton(),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _infoCard(),

                  _formCard(
                    children: [
                      _sectionTitle(
                        'Identitas Anggota',
                        Icons.badge_rounded,
                      ),
                      _field(
                        controller: controller.nomorAnggotaController,
                        label: 'Nomor Anggota',
                        icon: Icons.confirmation_number_rounded,
                      ),
                      _field(
                        controller: controller.namaController,
                        label: 'Nama Lengkap',
                        icon: Icons.person_rounded,
                      ),
                      _field(
                        controller: controller.emailController,
                        label: 'Email',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),

                  _formCard(
                    children: [
                      _sectionTitle(
                        'Keamanan Akun',
                        Icons.lock_rounded,
                      ),
                      _field(
                        controller: controller.passwordController,
                        label: 'Password',
                        icon: Icons.lock_rounded,
                        obscureText: true,
                      ),
                    ],
                  ),

                  _formCard(
                    children: [
                      _sectionTitle(
                        'Kontak & Status',
                        Icons.contact_phone_rounded,
                      ),
                      _field(
                        controller: controller.noHpController,
                        label: 'No HP',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      _field(
                        controller: controller.alamatController,
                        label: 'Alamat',
                        icon: Icons.location_on_rounded,
                        maxLines: 2,
                      ),
                      _statusDropdown(),
                      _statusPreview(),
                    ],
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}