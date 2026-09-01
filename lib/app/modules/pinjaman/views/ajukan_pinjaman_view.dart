import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ajukan_pinjaman_controller.dart';
import '../../../core/constants/app_colors.dart';

class AjukanPinjamanView extends StatefulWidget {
  const AjukanPinjamanView({super.key});

  @override
  State<AjukanPinjamanView> createState() => _AjukanPinjamanViewState();
}

class _AjukanPinjamanViewState extends State<AjukanPinjamanView> {
  final AjukanPinjamanController controller =
      Get.find<AjukanPinjamanController>();

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;

  String selectedJenis = 'Modal Usaha';

  final List<Map<String, dynamic>> jenisPinjaman = [
    {
      'title': 'Modal Usaha',
      'subtitle': 'Pinjaman untuk pengembangan usaha',
      'icon': Icons.business_center_rounded,
    },
    {
      'title': 'Konsumtif',
      'subtitle': 'Pinjaman untuk kebutuhan pribadi',
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'title': 'Pendidikan',
      'subtitle': 'Pinjaman untuk biaya pendidikan',
      'icon': Icons.school_rounded,
    },
    {
      'title': 'Lainnya',
      'subtitle': 'Pinjaman kebutuhan lainnya',
      'icon': Icons.more_horiz_rounded,
    },
  ];

  String _formatNumber(dynamic value) {
    final number = double.tryParse(value.toString()) ?? 0;
    final text = number.toInt().toString();

    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  String _rupiah(dynamic value) {
    return 'Rp ${_formatNumber(value)}';
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
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
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
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
                  'Ajukan Pinjaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Lengkapi formulir pengajuan',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.add_card_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      transform: Matrix4.translationValues(0, -18, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          _stepItem(
            icon: Icons.assignment_rounded,
            label: 'Formulir',
            active: true,
          ),
          _stepLine(),
          _stepItem(
            icon: Icons.description_rounded,
            label: 'Dokumen',
            active: false,
          ),
          _stepLine(),
          _stepItem(
            icon: Icons.fact_check_rounded,
            label: 'Review',
            active: false,
          ),
          _stepLine(),
          _stepItem(
            icon: Icons.check_circle_rounded,
            label: 'Selesai',
            active: false,
          ),
        ],
      ),
    );
  }

  Widget _stepItem({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: active ? primary : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: active ? Colors.white : AppColors.textMuted,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: active ? primary : AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _stepLine() {
    return Expanded(
      child: Container(
        height: 1.2,
        margin: const EdgeInsets.only(bottom: 20),
        color: AppColors.border,
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
      prefixIcon: Icon(
        icon,
        color: primary,
        size: 21,
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
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: dark,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _jenisCard(Map<String, dynamic> item) {
    final title = item['title'].toString();
    final subtitle = item['subtitle'].toString();
    final icon = item['icon'] as IconData;
    final selected = selectedJenis == title;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          selectedJenis = title;
        });

        if (controller.tujuanController.text.trim().isEmpty ||
            jenisPinjaman.any((e) =>
                controller.tujuanController.text.trim() == e['title'])) {
          controller.tujuanController.text = title;
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? primary : AppColors.borderLight,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 9,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: selected
                    ? primary.withValues(alpha: 0.12)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? primary : AppColors.textMuted,
                size: 18,
              ),
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
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? primary : AppColors.textSecondary,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Detail pinjaman',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.jumlahController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Jumlah Pinjaman',
              icon: Icons.payments_rounded,
            ),
            onChanged: controller.updateJumlah,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.tenorController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Tenor Bulan',
              icon: Icons.calendar_month_rounded,
            ),
            onChanged: controller.updateTenor,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.tujuanController,
            maxLines: 3,
            decoration: _inputDecoration(
              label: 'Tujuan Pinjaman',
              icon: Icons.description_rounded,
            ),
          ),
          const SizedBox(height: 22),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Identitas dan pekerjaan',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.nomorKtpController,
            keyboardType: TextInputType.number,
            maxLength: 16,
            decoration: _inputDecoration(
              label: 'Nomor KTP (16 digit)',
              icon: Icons.badge_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.usiaController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Usia',
              icon: Icons.cake_rounded,
            ),
          ),
          const SizedBox(height: 14),
          _dropdown(
            label: 'Status Pekerjaan',
            icon: Icons.work_rounded,
            value: controller.statusPekerjaan,
            options: const {
              'full_time': 'Karyawan tetap',
              'contract': 'Karyawan kontrak',
              'self_employed': 'Wiraswasta',
              'unemployed': 'Belum bekerja',
            },
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.lamaBekerjaController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Lama bekerja (bulan)',
              icon: Icons.timelapse_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.namaTempatKerjaController,
            decoration: _inputDecoration(
              label: 'Nama tempat usaha/kerja (opsional)',
              icon: Icons.storefront_rounded,
            ),
          ),
          const SizedBox(height: 22),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Kondisi keuangan',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.penghasilanController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Penghasilan bulanan',
              icon: Icons.account_balance_wallet_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.pendapatanTambahanController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Pendapatan tambahan (isi 0 bila tidak ada)',
              icon: Icons.add_card_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.pengeluaranController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Pengeluaran bulanan',
              icon: Icons.receipt_long_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.cicilanLainController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Total cicilan lain per bulan',
              icon: Icons.credit_card_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.tanggunganController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: 'Jumlah tanggungan',
              icon: Icons.family_restroom_rounded,
            ),
          ),
          const SizedBox(height: 22),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Profil tempat tinggal',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          _dropdown(
            label: 'Status tempat tinggal',
            icon: Icons.home_rounded,
            value: controller.statusTempatTinggal,
            options: const {
              'milik_sendiri': 'Milik sendiri',
              'sewa': 'Sewa',
              'keluarga': 'Milik keluarga',
              'menumpang': 'Menumpang',
            },
          ),
          const SizedBox(height: 14),
          _dropdown(
            label: 'Pendidikan terakhir',
            icon: Icons.school_rounded,
            value: controller.pendidikanTerakhir,
            options: const {
              'high_school': 'SMA/SMK',
              'bachelor': 'Sarjana',
              'master': 'Magister',
              'phd': 'Doktor',
            },
          ),
          const SizedBox(height: 14),
          _dropdown(
            label: 'Wilayah domisili',
            icon: Icons.location_city_rounded,
            value: controller.wilayahDomisili,
            options: const {
              'rural': 'Pedesaan',
              'suburban': 'Pinggiran kota',
              'urban': 'Perkotaan',
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required RxString value,
    required Map<String, String> options,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        initialValue: value.value,
        isExpanded: true,
        decoration: _inputDecoration(label: label, icon: icon),
        items: options.entries
            .map(
              (entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: (selected) {
          if (selected != null) {
            value.value = selected;
          }
        },
      ),
    );
  }

  Widget _documentPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Text(
            'Unggah foto yang jelas. Maksimal 5 MB per dokumen.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 14),
          _documentPicker(
            label: 'Foto KTP',
            icon: Icons.badge_rounded,
            documentType: 'foto_ktp',
            path: controller.fotoKtpPath,
          ),
          const SizedBox(height: 10),
          _documentPicker(
            label: 'Bukti penghasilan',
            icon: Icons.payments_rounded,
            documentType: 'bukti_penghasilan',
            path: controller.buktiPenghasilanPath,
          ),
          const SizedBox(height: 10),
          _documentPicker(
            label: 'Bukti tempat tinggal',
            icon: Icons.home_work_rounded,
            documentType: 'bukti_tempat_tinggal',
            path: controller.buktiTempatTinggalPath,
          ),
        ],
      ),
    );
  }

  Widget _documentPicker({
    required String label,
    required IconData icon,
    required String documentType,
    required RxString path,
  }) {
    return Obx(
      () => OutlinedButton.icon(
        onPressed: () => controller.pickDocument(documentType),
        icon: Icon(icon),
        label: Text(
          path.value.isEmpty
              ? 'Pilih $label'
              : '$label sudah dipilih',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: path.value.isEmpty ? primary : green,
          minimumSize: const Size.fromHeight(48),
          alignment: Alignment.centerLeft,
          side: BorderSide(
            color: path.value.isEmpty ? AppColors.border : green,
          ),
        ),
      ),
    );
  }

  Widget _estimasiCard() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.calculate_rounded,
                color: green,
                size: 24,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimasi Angsuran',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _rupiah(controller.estimasiAngsuran),
                    style: const TextStyle(
                      color: dark,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Bunga simulasi 1,5% per bulan',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
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
            onPressed: controller.isLoading.value ? null : controller.submit,
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.3,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(
              controller.isLoading.value
                  ? 'Mengirim Pengajuan...'
                  : 'Kirim Pengajuan',
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

  @override
  Widget build(BuildContext context) {
    if (controller.tujuanController.text.trim().isEmpty) {
      controller.tujuanController.text = selectedJenis;
    }

    return Scaffold(
      backgroundColor: softBrown,
      bottomNavigationBar: _submitButton(),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 18),
          children: [
            _header(),
            _stepPanel(),
            _sectionTitle('Jenis Pinjaman'),
            ...jenisPinjaman.map(_jenisCard),
            const SizedBox(height: 4),
            _sectionTitle('Data Pengajuan dan Pemohon'),
            _formPanel(),
            _sectionTitle('Dokumen Persyaratan'),
            _documentPanel(),
            _estimasiCard(),
          ],
        ),
      ),
    );
  }
}
