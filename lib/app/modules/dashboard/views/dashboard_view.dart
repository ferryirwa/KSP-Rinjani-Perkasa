import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import '../../../core/constants/app_colors.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color blue = AppColors.info; // accent
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

  dynamic _summaryValue(Map summary, List<String> keys, {dynamic fallback = 0}) {
    for (final key in keys) {
      if (summary[key] != null) return summary[key];
    }

    return fallback;
  }

  Widget _header(Map anggota) {
    final nama = anggota['nama']?.toString() ?? 'Anggota';
    final initial = nama.isNotEmpty ? nama[0].toUpperCase() : 'A';
    final theme = Theme.of(Get.context!);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $nama 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Selamat datang di Koperasi Kita',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Get.toNamed(AppRoutes.profil),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.22),
                  child: Text(
                    initial,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Akses cepat ke fitur utama',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saldoCard(Map summary) {
    final totalSimpanan = _summaryValue(summary, ['total_simpanan']);
    final theme = Theme.of(Get.context!);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      transform: Matrix4.translationValues(0, -22, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -4,
            bottom: -8,
            child: Icon(
              Icons.eco_rounded,
              size: 92,
              color: primary.withValues(alpha: 0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Total',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _rupiah(totalSimpanan),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: dark,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.visibility_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Total aset Anda di koperasi',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.simpanan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Lihat Ringkasan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
Widget _quickMenuCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: dark,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _quickMenuPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Menu Cepat',
                    style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: dark,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.pinjaman),
                  style: TextButton.styleFrom(
                    foregroundColor: primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _quickMenuCard(
                  icon: Icons.savings_rounded,
                  title: 'Simpanan',
                  onTap: () => Get.toNamed(AppRoutes.simpanan),
                ),
                const SizedBox(width: 10),
                _quickMenuCard(
                  icon: Icons.receipt_long_rounded,
                  title: 'Angsuran',
                  onTap: () => Get.toNamed(AppRoutes.angsuran),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _quickMenuCard(
                  icon: Icons.track_changes_rounded,
                  title: 'Tracking',
                  onTap: () => Get.toNamed(AppRoutes.tracking),
                ),
                const SizedBox(width: 10),
                _quickMenuCard(
                  icon: Icons.add_card_rounded,
                  title: 'Ajukan',
                  onTap: () => Get.toNamed(AppRoutes.ajukanPinjaman),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryPanel(Map summary) {
    final totalSimpanan = _summaryValue(summary, ['total_simpanan']);
    final totalPinjaman = _summaryValue(summary, ['total_pinjaman']);
    final pinjamanAktif = _summaryValue(summary, ['pinjaman_aktif']);
    final notifikasi = _summaryValue(summary, ['notifikasi_belum_dibaca']);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ringkasan',
                  style: TextStyle(
                    color: dark,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Get.toNamed(AppRoutes.transaksi),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'Lihat Semua',
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
          const SizedBox(height: 12),
          _summaryRow(
            icon: Icons.savings_rounded,
            title: 'Simpanan',
            value: _rupiah(totalSimpanan),
            color: green,
            onTap: () => Get.toNamed(AppRoutes.simpanan),
          ),
          _summaryRow(
            icon: Icons.request_quote_rounded,
            title: 'Total Pinjaman',
            value: _rupiah(totalPinjaman),
            color: orange,
            onTap: () => Get.toNamed(AppRoutes.pinjaman),
          ),
          _summaryRow(
            icon: Icons.verified_rounded,
            title: 'Pinjaman Aktif',
            value: '$pinjamanAktif pinjaman',
            color: blue,
            onTap: () => Get.toNamed(AppRoutes.pinjaman),
          ),
          _summaryRow(
            icon: Icons.notifications_active_rounded,
            title: 'Notifikasi Baru',
            value: '$notifikasi pesan',
            color: red,
            onTap: () => Get.toNamed(AppRoutes.notifikasi),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: dark,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: cardColor,
      selectedItemColor: primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 12,
      showUnselectedLabels: true,
      selectedIconTheme: const IconThemeData(size: 22),
      unselectedIconTheme: const IconThemeData(size: 20),
      onTap: (index) {
        if (index == 0) {
          controller.fetchDashboard();
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
              (controller.anggota.value == null ||
                  controller.summary.value == null)) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final anggota = controller.anggota.value ?? {};
          final summary = controller.summary.value ?? {};

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchDashboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _header(anggota),
                _saldoCard(summary),
                _quickMenuPanel(),
                _summaryPanel(summary),

                if (controller.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 18),
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