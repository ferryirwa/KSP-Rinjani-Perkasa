import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/tracking_pengajuan_controller.dart';
import '../../../core/constants/app_colors.dart';

class TrackingPengajuanView extends GetView<TrackingPengajuanController> {
  const TrackingPengajuanView({super.key});

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

    if (text.contains(' ')) {
      return text.split(' ').first;
    }

    return text;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return primary;
      case 'diproses':
        return orange;
      case 'disetujui':
      case 'dicairkan':
      case 'lunas':
        return green;
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
        return 'Berjalan';
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
      case 'ditolak':
        return Icons.cancel_rounded;
      case 'dicairkan':
        return Icons.payments_rounded;
      case 'lunas':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  int _statusIndex(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return 0;
      case 'diproses':
        return 1;
      case 'disetujui':
        return 2;
      case 'dicairkan':
        return 3;
      case 'lunas':
        return 4;
      case 'ditolak':
        return 1;
      default:
        return 0;
    }
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
                  'Status Pinjaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tracking pengajuan secara realtime',
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
            onTap: controller.fetchTrackingPengajuan,
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

  Widget _pinjamanCard(Map<String, dynamic> pinjaman) {
    final status = pinjaman['status']?.toString() ?? '-';
    final statusColor = _statusColor(status);
    final tujuan = pinjaman['tujuan_pinjaman']?.toString();
    final kode = pinjaman['kode_pinjaman']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      transform: Matrix4.translationValues(0, -18, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _statusIcon(status),
              color: statusColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tujuan == null || tujuan.isEmpty ? 'Pinjaman $kode' : tujuan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _rupiah(pinjaman['jumlah_pinjaman'] ?? 0),
                  style: const TextStyle(
                    color: dark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kode: $kode',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }

  Widget _progressCard(Map<String, dynamic> pinjaman) {
    final currentStatus = pinjaman['status']?.toString() ?? 'diajukan';
    final currentIndex = _statusIndex(currentStatus);

    final stages = [
      {
        'label': 'Diajukan',
        'status': 'diajukan',
        'date': '01 Jan',
        'icon': Icons.send_rounded,
      },
      {
        'label': 'Diproses',
        'status': 'diproses',
        'date': '05 Jan',
        'icon': Icons.hourglass_top_rounded,
      },
      {
        'label': 'Disetujui',
        'status': 'disetujui',
        'date': '10 Jan',
        'icon': Icons.verified_rounded,
      },
      {
        'label': 'Berjalan',
        'status': 'dicairkan',
        'date': '15 Jan',
        'icon': Icons.payments_rounded,
      },
      {
        'label': 'Selesai',
        'status': 'lunas',
        'date': '10 Jan',
        'icon': Icons.check_circle_rounded,
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      transform: Matrix4.translationValues(0, -6, 0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Pinjaman',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(stages.length, (index) {
              final completed = currentStatus == 'ditolak'
                  ? index <= currentIndex
                  : index <= currentIndex;
              final color = currentStatus == 'ditolak' && index == currentIndex
                  ? red
                  : completed
                      ? green
                      : AppColors.textSecondary;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (index != 0)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: completed
                                  ? color
                                  : AppColors.border,
                            ),
                          ),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: 1.2),
                          ),
                          child: Icon(
                            stages[index]['icon'] as IconData,
                            color: color,
                            size: 17,
                          ),
                        ),
                        if (index != stages.length - 1)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: index < currentIndex
                                  ? green
                                  : AppColors.border,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stages[index]['label'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: completed ? dark : AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stages[index]['date'].toString(),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(Map<String, dynamic> pinjaman) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Pinjaman',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _detailRow(
            'Plafon Pinjaman',
            _rupiah(pinjaman['jumlah_pinjaman'] ?? 0),
          ),
          _detailRow(
            'Tenor',
            '${pinjaman['tenor_bulan'] ?? 0} bulan',
          ),
          _detailRow(
            'Angsuran/Bulan',
            _rupiah(pinjaman['angsuran_per_bulan'] ?? 0),
          ),
          _detailRow(
            'Bunga',
            '${pinjaman['bunga_persen'] ?? '1.5'}%',
          ),
          _detailRow(
            'Status',
            _statusText(pinjaman['status']?.toString() ?? '-'),
          ),
          _detailRow(
            'Tujuan',
            pinjaman['tujuan_pinjaman']?.toString() ?? '-',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
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
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            color: AppColors.borderLight,
          ),
      ],
    );
  }

  Widget _trackingHistory() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Pengajuan',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          if (controller.tracking.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Belum ada tracking pengajuan.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            ...List.generate(controller.tracking.length, (index) {
              final item = Map<String, dynamic>.from(controller.tracking[index]);
              return _historyItem(
                item,
                index == controller.tracking.length - 1,
              );
            }),
        ],
      ),
    );
  }

  Widget _historyItem(Map<String, dynamic> item, bool isLast) {
    final status = item['status']?.toString() ?? '-';
    final color = _statusColor(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                shape: BoxShape.circle,
                border: Border.all(color: color),
              ),
              child: Icon(
                _statusIcon(status),
                color: color,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 54,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusText(status),
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['catatan']?.toString() ?? '-',
                  style: const TextStyle(
                    color: dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _tanggal(item['waktu']),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
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
            'Data tracking pinjaman belum tersedia.',
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
          if (controller.isLoading.value &&
              controller.pinjaman.value == null &&
              controller.tracking.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final pinjaman = controller.pinjaman.value == null
              ? <String, dynamic>{}
              : Map<String, dynamic>.from(controller.pinjaman.value!);

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchTrackingPengajuan,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 18),
              children: [
                _header(),

                if (pinjaman.isEmpty)
                  _emptyState()
                else ...[
                  _pinjamanCard(pinjaman),
                  _progressCard(pinjaman),
                  _detailCard(pinjaman),
                  _trackingHistory(),
                ],

                if (controller.isLoading.value &&
                    (pinjaman.isNotEmpty || controller.tracking.isNotEmpty))
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