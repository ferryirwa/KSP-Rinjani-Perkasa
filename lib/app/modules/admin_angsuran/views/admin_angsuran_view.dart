import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/admin_angsuran_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminAngsuranView extends GetView<AdminAngsuranController> {
  const AdminAngsuranView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color red = AppColors.danger;

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
        return 'Belum Bayar';
      default:
        return status;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Icons.check_circle_rounded;
      case 'terlambat':
        return Icons.warning_amber_rounded;
      case 'belum_bayar':
        return Icons.pending_actions_rounded;
      default:
        return Icons.receipt_long_rounded;
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
                  'KoperasiKu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Data Angsuran / Pembayaran',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(30),
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
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return PremiumCard(
      padding: const EdgeInsets.all(13),
      borderRadius: BorderRadius.circular(18),
      color: cardColor,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 14,
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

  Widget _summaryGrid() {
    final totalData = controller.angsurans.length;
    final belumBayar = controller.countByStatus('belum_bayar');
    final terlambat = controller.countByStatus('terlambat');
    final lunas = controller.countByStatus('lunas');

    final cards = [
      _summaryCard(
        icon: Icons.receipt_long_rounded,
        title: 'Total Data',
        value: '$totalData',
        color: primary,
      ),
      _summaryCard(
        icon: Icons.pending_actions_rounded,
        title: 'Belum Bayar',
        value: '$belumBayar',
        color: orange,
      ),
      _summaryCard(
        icon: Icons.warning_amber_rounded,
        title: 'Terlambat',
        value: '$terlambat',
        color: red,
      ),
      _summaryCard(
        icon: Icons.check_circle_rounded,
        title: 'Lunas',
        value: '$lunas',
        color: green,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.85,
        ),
        itemBuilder: (context, index) => cards[index],
      ),
    );
  }

  Widget _totalPaymentCard() {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _miniAmountBox(
                  title: 'Total Tagihan',
                  value: _rupiah(controller.totalTagihan),
                  icon: Icons.request_quote_rounded,
                  color: primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniAmountBox(
                  title: 'Total Dibayar',
                  value: _rupiah(controller.totalBayar),
                  icon: Icons.payments_rounded,
                  color: green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniAmountBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
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
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required String value,
  }) {
    final selected = controller.selectedFilter.value == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => controller.changeFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primary : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : dark,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _filterPanel() {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Status',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip(label: 'Semua', value: 'semua'),
              _filterChip(label: 'Belum Bayar', value: 'belum_bayar'),
              _filterChip(label: 'Terlambat', value: 'terlambat'),
              _filterChip(label: 'Lunas', value: 'lunas'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title ($total)',
              style: const TextStyle(
                color: dark,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: controller.fetchAngsuran,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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

  Widget _infoLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _angsuranListItem(Map<String, dynamic> angsuran) {
    final pinjaman = angsuran['pinjaman'] is Map
        ? Map<String, dynamic>.from(angsuran['pinjaman'])
        : <String, dynamic>{};

    final anggota = pinjaman['anggota'] is Map
        ? Map<String, dynamic>.from(pinjaman['anggota'])
        : <String, dynamic>{};

    final status = angsuran['status']?.toString() ?? '-';
    final statusColor = _statusColor(status);

    final nama = anggota['nama']?.toString() ?? '-';
    final kodePinjaman = pinjaman['kode_pinjaman']?.toString() ?? '-';

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: statusColor.withValues(alpha: 0.13),
        child: Icon(
          _statusIcon(status),
          color: statusColor,
          size: 21,
        ),
      ),
      title: Text(
        'Angsuran ke-${angsuran['angsuran_ke'] ?? '-'}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: dark,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            kodePinjaman,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      trailing: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      onTap: () => _showAngsuranDetail(angsuran),
    );
  }

  void _showAngsuranDetail(Map<String, dynamic> angsuran) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: _angsuranDetailCard(angsuran),
      ),
    );
  }

  Widget _angsuranDetailCard(Map<String, dynamic> angsuran) {
    final pinjaman = angsuran['pinjaman'] is Map
        ? Map<String, dynamic>.from(angsuran['pinjaman'])
        : <String, dynamic>{};

    final anggota = pinjaman['anggota'] is Map
        ? Map<String, dynamic>.from(pinjaman['anggota'])
        : <String, dynamic>{};

    final status = angsuran['status']?.toString() ?? '-';
    final statusColor = _statusColor(status);

    final nama = anggota['nama']?.toString() ?? '-';
    final nomorAnggota = anggota['nomor_anggota']?.toString() ?? '-';
    final kodePinjaman = pinjaman['kode_pinjaman']?.toString() ?? '-';

    return SingleChildScrollView(
      child: PremiumCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        'Angsuran ke-${angsuran['angsuran_ke'] ?? '-'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
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

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _infoLine(
                    icon: Icons.badge_rounded,
                    label: 'No Anggota',
                    value: nomorAnggota,
                  ),
                  _infoLine(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Kode Pinjaman',
                    value: kodePinjaman,
                  ),
                  _infoLine(
                    icon: Icons.event_rounded,
                    label: 'Jatuh Tempo',
                    value: _tanggal(angsuran['tanggal_jatuh_tempo']),
                  ),
                  _infoLine(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Tanggal Bayar',
                    value: _tanggal(angsuran['tanggal_bayar']),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _amountColumn(
                    title: 'Tagihan',
                    value: _rupiah(angsuran['jumlah_tagihan']),
                    color: primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _amountColumn(
                    title: 'Dibayar',
                    value: _rupiah(angsuran['jumlah_bayar']),
                    color: green,
                  ),
                ),
              ],
            ),

            if (status != 'lunas') ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: controller.isPaying.value
                      ? null
                      : () {
                          Get.back();
                          _showConfirmDialog(angsuran);
                        },
                  icon: controller.isPaying.value
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_rounded, size: 19),
                  label: Text(
                    controller.isPaying.value
                        ? 'Memproses...'
                        : 'Konfirmasi Bayar',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    disabledBackgroundColor:
                        primary.withValues(alpha: 0.55),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _amountColumn({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(Map<String, dynamic> angsuran) {
    Get.dialog(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const Text(
          'Pastikan pembayaran angsuran sudah diterima sebelum dikonfirmasi.',
          style: TextStyle(
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
              controller.konfirmasiBayar(angsuran);
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
              'Ya, Konfirmasi',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      padding: const EdgeInsets.all(28),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: const Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            'Belum ada data angsuran pada filter ini.',
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
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.surface,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 0,
      onTap: (index) {
        if (index == 0) {
          Get.offNamed(AppRoutes.adminDashboard);
        } else if (index == 1) {
          Get.offNamed(AppRoutes.adminAnggota);
        } else if (index == 2) {
          Get.offNamed(AppRoutes.adminSimpanan);
        } else if (index == 3) {
          Get.offNamed(AppRoutes.adminPinjaman);
        } else if (index == 4) {
          Get.offNamed(AppRoutes.adminLaporanKeuangan);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Anggota',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.savings_rounded),
          label: 'Simpanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wallet_rounded),
          label: 'Pinjaman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Laporan',
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
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Obx(() {
                final data = controller.filteredAngsurans;

                if (controller.isLoading.value &&
                    controller.angsurans.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                return RefreshIndicator(
                  color: primary,
                  onRefresh: controller.fetchAngsuran,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 18),
                    children: [
                      _summaryGrid(),
                      _totalPaymentCard(),
                      _filterPanel(),
                      _sectionTitle('Daftar Angsuran', data.length),

                      if (data.isEmpty)
                        _emptyState()
                      else
                        ...data.map((item) {
                          return _angsuranListItem(
                            Map<String, dynamic>.from(item),
                          );
                        }),

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
          ],
        ),
      ),
    );
  }
}
