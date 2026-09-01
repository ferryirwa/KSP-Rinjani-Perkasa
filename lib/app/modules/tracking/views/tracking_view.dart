import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/tracking_controller.dart';
import '../../../core/constants/app_colors.dart';

class TrackingView extends GetView<TrackingController> {
  const TrackingView({super.key});

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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return primary;
      case 'diproses':
        return orange;
      case 'disetujui':
      case 'dicairkan':
      case 'aktif':
        return green;
      case 'lunas':
        return blue;
      case 'ditolak':
        return red;
      default:
        return primary;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return 'Diajukan';
      case 'diproses':
        return 'Diproses';
      case 'disetujui':
        return 'Disetujui';
      case 'dicairkan':
      case 'aktif':
        return 'Aktif';
      case 'lunas':
        return 'Lunas';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return Icons.send_rounded;
      case 'diproses':
        return Icons.hourglass_top_rounded;
      case 'disetujui':
        return Icons.verified_rounded;
      case 'dicairkan':
      case 'aktif':
        return Icons.payments_rounded;
      case 'lunas':
        return Icons.check_circle_rounded;
      case 'ditolak':
        return Icons.cancel_rounded;
      default:
        return Icons.track_changes_rounded;
    }
  }

  int _countByStatus(String status) {
    return controller.pinjamans.where((item) {
      final data = Map<String, dynamic>.from(item);
      return data['status']?.toString().toLowerCase() == status;
    }).length;
  }

  double _totalPinjaman() {
    double total = 0;

    for (final item in controller.pinjamans) {
      final data = Map<String, dynamic>.from(item);
      total += double.tryParse(data['jumlah_pinjaman'].toString()) ?? 0;
    }

    return total;
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
                  'Tracking Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pantau pinjaman dan angsuran Anda',
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
            onTap: controller.fetchTrackingStatus,
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

  Widget _topSummaryCard() {
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
              Icons.track_changes_rounded,
              size: 110,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Pinjaman Dilacak',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.pinjamans.length} Pinjaman',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Total nilai ${_rupiah(_totalPinjaman())}',
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
                    icon: Icons.hourglass_top_rounded,
                    title: 'Diproses',
                    value: '${_countByStatus('diproses')}',
                  ),
                  const SizedBox(width: 10),
                  _miniTopInfo(
                    icon: Icons.check_circle_rounded,
                    title: 'Aktif',
                    value:
                        '${_countByStatus('dicairkan') + _countByStatus('aktif') + _countByStatus('disetujui')}',
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
    required IconData icon,
    required String title,
    required String value,
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
          _summaryMiniBox(
            title: 'Diajukan',
            value: '${_countByStatus('diajukan')}',
            color: primary,
            icon: Icons.send_rounded,
          ),
          const SizedBox(width: 10),
          _summaryMiniBox(
            title: 'Lunas',
            value: '${_countByStatus('lunas')}',
            color: blue,
            icon: Icons.verified_rounded,
          ),
          const SizedBox(width: 10),
          _summaryMiniBox(
            title: 'Ditolak',
            value: '${_countByStatus('ditolak')}',
            color: red,
            icon: Icons.cancel_rounded,
          ),
        ],
      ),
    );
  }

  Widget _summaryMiniBox({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                color: dark,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Daftar Pinjaman ($total)',
              style: const TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: controller.fetchTrackingStatus,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Refresh',
                style: TextStyle(
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

  Widget _pinjamanCard(Map<String, dynamic> item) {
    final status = item['status']?.toString() ?? '-';
    final statusColor = _statusColor(status);

    final kode = item['kode_pinjaman']?.toString() ?? '-';
    final tujuan = item['tujuan_pinjaman']?.toString();
    final jumlah = item['jumlah_pinjaman'] ?? 0;
    final tenor = item['tenor_bulan'] ?? 0;
    final angsuran = item['angsuran_per_bulan'] ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: statusColor.withValues(alpha: 0.13),
                child: Icon(
                  _statusIcon(status),
                  color: statusColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tujuan == null || tujuan.isEmpty
                          ? 'Pinjaman $kode'
                          : tujuan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _statusText(status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _rupiah(jumlah),
              style: const TextStyle(
                color: dark,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  icon: Icons.calendar_month_rounded,
                  title: 'Tenor',
                  value: '$tenor bulan',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoBox(
                  icon: Icons.payments_rounded,
                  title: 'Angsuran/Bulan',
                  value: _rupiah(angsuran),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _angsuranBox(
                title: 'Total',
                value: '${item['total_angsuran'] ?? 0}',
                color: primary,
              ),
              const SizedBox(width: 8),
              _angsuranBox(
                title: 'Lunas',
                value: '${item['angsuran_lunas'] ?? 0}',
                color: green,
              ),
              const SizedBox(width: 8),
              _angsuranBox(
                title: 'Belum',
                value: '${item['angsuran_belum_bayar'] ?? 0}',
                color: orange,
              ),
              const SizedBox(width: 8),
              _angsuranBox(
                title: 'Telat',
                value: '${item['angsuran_terlambat'] ?? 0}',
                color: red,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _trackingButtons(item),
        ],
      ),
    );
  }

  Widget _trackingButtons(Map<String, dynamic> item) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(
                AppRoutes.trackingPengajuan,
                arguments: {
                  'pinjaman_id': item['id'],
                },
              );
            },
            icon: const Icon(Icons.timeline_rounded, size: 18),
            label: const Text(
              'Tracking Pinjaman',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.toNamed(
                AppRoutes.trackingAngsuran,
                arguments: {
                  'pinjaman_id': item['id'],
                },
              );
            },
            icon: const Icon(Icons.payments_rounded, size: 18),
            label: const Text(
              'Tracking Angsuran',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: const BorderSide(color: primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 17),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _angsuranBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.16)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: dark,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.track_changes_rounded,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            'Belum ada pinjaman yang bisa dilacak.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
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
          if (controller.isLoading.value && controller.pinjamans.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchTrackingStatus,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 18),
              children: [
                _header(),
                _topSummaryCard(),
                _summaryPanel(),
                _sectionTitle(controller.pinjamans.length),
                if (controller.pinjamans.isEmpty)
                  _emptyState()
                else
                  ...controller.pinjamans.map((item) {
                    return _pinjamanCard(
                      Map<String, dynamic>.from(item),
                    );
                  }),
                if (controller.isLoading.value &&
                    controller.pinjamans.isNotEmpty)
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