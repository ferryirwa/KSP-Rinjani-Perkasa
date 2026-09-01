import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_tambah_simpanan_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminTambahSimpananView extends GetView<AdminTambahSimpananController> {
  const AdminTambahSimpananView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color blue = AppColors.info;

  String _todayText() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }

  Color _jenisColor(String jenis) {
    if (jenis == 'pokok') return blue;
    if (jenis == 'wajib') return orange;
    return green;
  }

  String _jenisLabel(String jenis) {
    if (jenis == 'pokok') return 'Simpanan Pokok';
    if (jenis == 'wajib') return 'Simpanan Wajib';
    return 'Simpanan Sukarela';
  }

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
                  'Tambah Simpanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Catat setoran simpanan anggota',
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
              Icons.savings_rounded,
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
              Icons.account_balance_wallet_rounded,
              color: primary,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Pilih anggota, jenis simpanan, jumlah, dan tanggal setoran. Setelah disimpan, data akan masuk ke database.',
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

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Color iconColor = primary,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: iconColor, size: 21),
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

  Widget _anggotaDropdown() {
    return Obx(() {
      if (controller.isLoadingAnggota.value) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: primary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Memuat data anggota...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.anggotas.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.people_outline_rounded,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Belum ada data anggota.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final selectedValue = controller.selectedAnggotaId.value;
      final isValidSelected = controller.anggotas.any((anggota) {
        final id = int.tryParse(anggota['id'].toString()) ?? 0;
        return id == selectedValue;
      });

      return DropdownButtonFormField<int>(
        initialValue: isValidSelected ? selectedValue : null,
        isExpanded: true,
        decoration: _inputDecoration(
          label: 'Pilih Anggota',
          icon: Icons.person_rounded,
        ),
        items: controller.anggotas.map((anggota) {
          final id = int.tryParse(anggota['id'].toString()) ?? 0;
          final nama = anggota['nama']?.toString() ?? '-';
          final nomor = anggota['nomor_anggota']?.toString() ?? '-';

          return DropdownMenuItem<int>(
            value: id,
            child: Text(
              '$nama - $nomor',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: dark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedAnggotaId.value = value;
        },
      );
    });
  }

  Widget _jenisDropdown() {
    return Obx(() {
      final jenis = controller.jenisSimpanan.value;

      return DropdownButtonFormField<String>(
        initialValue: jenis,
        isExpanded: true,
        decoration: _inputDecoration(
          label: 'Jenis Simpanan',
          icon: Icons.category_rounded,
          iconColor: _jenisColor(jenis),
        ),
        items: const [
          DropdownMenuItem(
            value: 'pokok',
            child: Text('Simpanan Pokok'),
          ),
          DropdownMenuItem(
            value: 'wajib',
            child: Text('Simpanan Wajib'),
          ),
          DropdownMenuItem(
            value: 'sukarela',
            child: Text('Simpanan Sukarela'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.jenisSimpanan.value = value;
          }
        },
      );
    });
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: _inputDecoration(
        label: label,
        icon: icon,
      ),
    );
  }

  Widget _jenisPreview() {
    return Obx(() {
      final jenis = controller.jenisSimpanan.value;
      final color = _jenisColor(jenis);

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_rounded,
              color: color,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_jenisLabel(jenis)} akan tercatat sebagai transaksi simpanan anggota.',
                style: TextStyle(
                  color: color,
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

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      final month = picked.month.toString().padLeft(2, '0');
      final day = picked.day.toString().padLeft(2, '0');

      controller.tanggalController.text = '${picked.year}-$month-$day';
    }
  }

  Widget _saveButton() {
    return Obx(() {
      return Container(
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
                : controller.tambahSimpanan,
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
                  : 'Simpan Simpanan',
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
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.tanggalController.text.isEmpty) {
      controller.tanggalController.text = _todayText();
    }

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
                        'Data Anggota',
                        Icons.people_alt_rounded,
                      ),
                      _anggotaDropdown(),
                    ],
                  ),
                  _formCard(
                    children: [
                      _sectionTitle(
                        'Detail Simpanan',
                        Icons.savings_rounded,
                      ),
                      _jenisDropdown(),
                      const SizedBox(height: 14),
                      _field(
                        controller: controller.jumlahController,
                        label: 'Jumlah Simpanan',
                        icon: Icons.payments_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        controller: controller.tanggalController,
                        label: 'Tanggal Simpanan',
                        icon: Icons.calendar_today_rounded,
                        readOnly: true,
                        onTap: () => _pickDate(context),
                      ),
                      _jenisPreview(),
                    ],
                  ),
                  _formCard(
                    children: [
                      _sectionTitle(
                        'Catatan Tambahan',
                        Icons.note_alt_rounded,
                      ),
                      _field(
                        controller: controller.keteranganController,
                        label: 'Keterangan',
                        icon: Icons.edit_note_rounded,
                        maxLines: 3,
                      ),
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