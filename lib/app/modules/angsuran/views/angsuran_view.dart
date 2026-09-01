import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/angsuran_controller.dart';
import '../../../core/constants/app_colors.dart';

class AngsuranView extends GetView<AngsuranController> {
  const AngsuranView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color red = AppColors.danger;
  static const Color blue = AppColors.info;

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

  String _tanggal(dynamic value) {
    if (value == null) return '-';

    final text = value.toString();

    if (text.contains('T')) {
      return text.split('T').first;
    }

    return text;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return green;
      case 'terlambat':
        return red;
      case 'belum_bayar':
        return orange;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return 'Lunas';
      case 'terlambat':
        return 'Terlambat';
      case 'belum_bayar':
        return 'Bayar';
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> _dataAngsuran() {
    return controller.angsurans.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
  }

  List<Map<String, dynamic>> _tagihanBelumLunas() {
    return _dataAngsuran().where((item) {
      final status = item['status']?.toString().toLowerCase() ?? '';
      return status != 'lunas';
    }).toList();
  }

  List<Map<String, dynamic>> _riwayatLunas() {
    return _dataAngsuran().where((item) {
      final status = item['status']?.toString().toLowerCase() ?? '';
      return status == 'lunas';
    }).toList();
  }

  String _tanggalJatuhTempoTerdekat() {
    final data = _tagihanBelumLunas();

    if (data.isEmpty) return '-';

    data.sort((a, b) {
      final aDate = DateTime.tryParse(
        (a['tanggal_jatuh_tempo'] ?? '').toString(),
      );
      final bDate = DateTime.tryParse(
        (b['tanggal_jatuh_tempo'] ?? '').toString(),
      );

      if (aDate == null || bDate == null) return 0;
      return aDate.compareTo(bDate);
    });

    return _tanggal(data.first['tanggal_jatuh_tempo']);
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
                  'Angsuran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pantau tagihan dan riwayat pembayaran',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: controller.fetchAngsuran,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBillCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      transform: Matrix4.translationValues(0, -18, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -18,
            child: Icon(
              Icons.receipt_long_rounded,
              size: 110,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Angsuran Bulan Ini',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _rupiah(controller.totalBelumBayar),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Jatuh tempo ${_tanggalJatuhTempoTerdekat()}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _miniTopInfo(
                    title: 'Sudah Dibayar',
                    value: _rupiah(controller.totalBayar),
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 10),
                  _miniTopInfo(
                    title: 'Terlambat',
                    value: '${controller.totalTerlambat}',
                    icon: Icons.warning_amber_rounded,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniTopInfo({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
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

  Widget _summaryPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      transform: Matrix4.translationValues(0, -6, 0),
      padding: const EdgeInsets.all(14),
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
          _summaryMiniCard(
            title: 'Total Tagihan',
            value: _rupiah(controller.totalTagihan),
            color: primary,
            icon: Icons.request_quote_rounded,
          ),
          const SizedBox(width: 10),
          _summaryMiniCard(
            title: 'Belum Bayar',
            value: _rupiah(controller.totalBelumBayar),
            color: orange,
            icon: Icons.pending_actions_rounded,
          ),
        ],
      ),
    );
  }

  Widget _summaryMiniCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: dark,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required String title,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (actionText != null)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tagihanItem(Map<String, dynamic> angsuran) {
    final pinjaman = angsuran['pinjaman'] is Map
        ? Map<String, dynamic>.from(angsuran['pinjaman'])
        : <String, dynamic>{};

    final status = angsuran['status']?.toString() ?? '-';
    final statusColor = _statusColor(status);
    final tujuan = pinjaman['tujuan_pinjaman']?.toString();
    final kodePinjaman = pinjaman['kode_pinjaman']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: statusColor.withValues(alpha: 0.12),
            child: Icon(
              Icons.receipt_long_rounded,
              color: statusColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tujuan == null || tujuan.isEmpty
                      ? 'Pinjaman $kodePinjaman'
                      : tujuan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _rupiah(angsuran['jumlah_tagihan']),
                  style: const TextStyle(
                    color: dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Jatuh tempo ${_tanggal(angsuran['tanggal_jatuh_tempo'])}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 35,
            child: ElevatedButton(
              onPressed: controller.isPaying.value
                  ? null
                  : () => _showBayarDialog(angsuran),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: primary.withValues(alpha: 0.55),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(
                controller.isPaying.value ? '...' : _statusText(status),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riwayatItem(Map<String, dynamic> angsuran) {
    final pinjaman = angsuran['pinjaman'] is Map
        ? Map<String, dynamic>.from(angsuran['pinjaman'])
        : <String, dynamic>{};

    final tujuan = pinjaman['tujuan_pinjaman']?.toString();
    final kodePinjaman = pinjaman['kode_pinjaman']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
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
          CircleAvatar(
            radius: 22,
            backgroundColor: green.withValues(alpha: 0.12),
            child: const Icon(
              Icons.check_circle_rounded,
              color: green,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tujuan == null || tujuan.isEmpty
                      ? 'Pinjaman $kodePinjaman'
                      : tujuan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _tanggal(angsuran['tanggal_bayar']),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _rupiah(angsuran['jumlah_bayar']),
                style: const TextStyle(
                  color: dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Lunas',
                  style: TextStyle(
                    color: green,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBayarDialog(Map<String, dynamic> angsuran) {
    Get.dialog(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          'Bayar Angsuran',
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Text(
          'Konfirmasi pembayaran demo sebesar ${_rupiah(angsuran['jumlah_tagihan'])}?',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.bayarDemo(angsuran['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Bayar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(String message) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 54,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.surface,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 0,
      onTap: (index) {
        if (index == 0) {
          Get.offNamed(AppRoutes.dashboard);
        } else if (index == 1) {
          Get.toNamed(AppRoutes.transaksi);
        } else if (index == 2) {
          Get.toNamed(AppRoutes.ajukanPinjaman);
        } else if (index == 3) {
          Get.toNamed(AppRoutes.notifikasi);
        } else if (index == 4) {
          Get.toNamed(AppRoutes.profil);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'Transaksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_card_rounded),
          label: 'Ajukan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_rounded),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBrown,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.angsurans.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final belumLunas = _tagihanBelumLunas();
          final riwayat = _riwayatLunas();

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchAngsuran,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 18),
              children: [
                _header(),
                _topBillCard(),
                _summaryPanel(),

                _sectionTitle(
                  title: 'Rincian Angsuran',
                ),

                if (belumLunas.isEmpty)
                  _emptyState('Tidak ada angsuran yang perlu dibayar.')
                else
                  ...belumLunas.map(_tagihanItem),

                _sectionTitle(
                  title: 'Riwayat Pembayaran',
                  actionText: 'Lihat Semua',
                  onTap: controller.fetchAngsuran,
                ),

                if (riwayat.isEmpty)
                  _emptyState('Belum ada riwayat pembayaran.')
                else
                  ...riwayat.map(_riwayatItem),

                if (controller.isLoading.value &&
                    controller.angsurans.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}