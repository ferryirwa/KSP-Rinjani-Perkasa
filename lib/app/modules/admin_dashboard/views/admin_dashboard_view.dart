import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../../../core/constants/app_colors.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color red = AppColors.danger;
  static const Color info = AppColors.info;

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

  String _today() {
    final now = DateTime.now();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  // ==================== HEADER PREMIUM ====================
  Widget _header(Map summary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3E2723),
            Color(0xFF6D4C41),
            Color(0xFF8D6E63),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dekorasi lingkaran
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -50,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris atas: logo + nama + tanggal
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KoperasiKu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Dashboard Admin',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _today(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Label ringkasan
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE7D2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'TOTAL SIMPANAN KOPERASI',
                    style: TextStyle(
                      color: Color(0xFFFFE7D2),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nilai total
              Text(
                _rupiah(summary['total_simpanan'] ?? 0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Total simpanan seluruh anggota koperasi',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),

              // Badge anggota aktif
              Row(
                children: [
                  _headerBadge(
                    icon: Icons.people_alt_rounded,
                    label: '${summary['anggota_aktif'] ?? 0} Anggota Aktif',
                    color: const Color(0xFF81C784),
                  ),
                  const SizedBox(width: 10),
                  _headerBadge(
                    icon: Icons.verified_rounded,
                    label:
                        '${summary['persentase_anggota_aktif'] ?? 0}% Aktif',
                    color: const Color(0xFFFFE7D2),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SECTION TITLE ====================
  Widget _sectionTitle(String title, {String? subtitle, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primary, size: 18),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: dark,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (subtitle != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== STAT CARD PREMIUM ====================
  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String caption,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  caption,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: dark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
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
    );
  }

  Widget _summaryGrid(Map summary) {
    final items = [
      _statCard(
        icon: Icons.people_alt_rounded,
        title: 'Total Anggota',
        value: '${summary['total_anggota'] ?? 0}',
        color: primary,
        caption: 'Aktif',
        gradient: const LinearGradient(
          colors: [Color(0xFF8D6E63), Color(0xFF6D4C41)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _statCard(
        icon: Icons.account_balance_wallet_rounded,
        title: 'Total Pinjaman',
        value: _rupiah(summary['total_pinjaman'] ?? 0),
        color: orange,
        caption: 'Dana',
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _statCard(
        icon: Icons.savings_rounded,
        title: 'Total Simpanan',
        value: _rupiah(summary['total_simpanan'] ?? 0),
        color: green,
        caption: 'Aset',
        gradient: const LinearGradient(
          colors: [Color(0xFF81C784), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _statCard(
        icon: Icons.assignment_late_rounded,
        title: 'Pengajuan',
        value: '${summary['pinjaman_diajukan'] ?? 0}',
        color: red,
        caption: 'Baru',
        gradient: const LinearGradient(
          colors: [Color(0xFFE57373), Color(0xFFC62828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.12,
      ),
      itemBuilder: (context, index) => items[index],
    );
  }

  // ==================== PROGRESS CARD ====================
  Widget _progressCard({
    required String title,
    required String value,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
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
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0).toDouble(),
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressSection(Map summary) {
    return Column(
      children: [
        _progressCard(
          title: 'Anggota Aktif',
          value: '${summary['persentase_anggota_aktif'] ?? 0}%',
          progress: ((summary['persentase_anggota_aktif'] ?? 0) as num)
              .toDouble() /
              100,
          color: green,
          icon: Icons.people_alt_rounded,
        ),
        const SizedBox(height: 12),
        _progressCard(
          title: 'Pinjaman Disetujui',
          value: '${summary['persentase_pinjaman_disetujui'] ?? 0}%',
          progress: ((summary['persentase_pinjaman_disetujui'] ?? 0) as num)
              .toDouble() /
              100,
          color: primary,
          icon: Icons.verified_rounded,
        ),
      ],
    );
  }

  // ==================== FINANCE MINI CARD ====================
  Widget _financeMiniCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required LinearGradient gradient,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            value,
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
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _financeSummary(Map summary) {
    return SizedBox(
      height: 132,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        clipBehavior: Clip.none,
        children: [
          _financeMiniCard(
            title: 'Total Simpanan',
            value: _rupiah(summary['total_simpanan'] ?? 0),
            icon: Icons.savings_rounded,
            color: green,
            gradient: const LinearGradient(
              colors: [Color(0xFF81C784), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          _financeMiniCard(
            title: 'Total Pinjaman',
            value: _rupiah(summary['total_pinjaman'] ?? 0),
            icon: Icons.wallet_rounded,
            color: orange,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          _financeMiniCard(
            title: 'Angsuran Terlambat',
            value: '${summary['angsuran_terlambat'] ?? 0}',
            icon: Icons.warning_amber_rounded,
            color: red,
            gradient: const LinearGradient(
              colors: [Color(0xFFE57373), Color(0xFFC62828)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          _financeMiniCard(
            title: 'Angsuran Dibayar',
            value: _rupiah(summary['total_angsuran_dibayar'] ?? 0),
            icon: Icons.check_circle_rounded,
            color: info,
            gradient: const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MENU CARD ====================
  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required LinearGradient gradient,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
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
                gradient: gradient,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: dark,
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminMenu() {
    final menus = [
      _menuCard(
        icon: Icons.people_alt_rounded,
        title: 'Anggota',
        subtitle: 'Kelola data anggota',
        onTap: () => Get.toNamed(AppRoutes.adminAnggota),
        color: primary,
        gradient: const LinearGradient(
          colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.savings_rounded,
        title: 'Simpanan',
        subtitle: 'Kelola simpanan',
        onTap: () => Get.toNamed(AppRoutes.adminSimpanan),
        color: green,
        gradient: const LinearGradient(
          colors: [Color(0xFF81C784), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Tambah Anggota',
        subtitle: 'Registrasi baru',
        onTap: () => Get.toNamed(AppRoutes.adminTambahAnggota),
        color: info,
        gradient: const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.add_card_rounded,
        title: 'Tambah Simpanan',
        subtitle: 'Setoran simpanan',
        onTap: () => Get.toNamed(AppRoutes.adminTambahSimpanan),
        color: const Color(0xFF00897B),
        gradient: const LinearGradient(
          colors: [Color(0xFF4DB6AC), Color(0xFF00897B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.account_balance_wallet_rounded,
        title: 'Pinjaman',
        subtitle: 'Kelola pinjaman',
        onTap: () => Get.toNamed(AppRoutes.adminPinjaman),
        color: orange,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.receipt_long_rounded,
        title: 'Angsuran',
        subtitle: 'Kelola angsuran',
        onTap: () => Get.toNamed(AppRoutes.adminAngsuran),
        color: const Color(0xFF7B1FA2),
        gradient: const LinearGradient(
          colors: [Color(0xFFBA68C8), Color(0xFF7B1FA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.bar_chart_rounded,
        title: 'Laporan',
        subtitle: 'Laporan keuangan',
        onTap: () => Get.toNamed(AppRoutes.adminLaporanKeuangan),
        color: red,
        gradient: const LinearGradient(
          colors: [Color(0xFFE57373), Color(0xFFC62828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _menuCard(
        icon: Icons.settings_rounded,
        title: 'Pengaturan',
        subtitle: 'Pengaturan sistem',
        onTap: () => Get.toNamed(AppRoutes.adminPengaturan),
        color: const Color(0xFF546E7A),
        gradient: const LinearGradient(
          colors: [Color(0xFF90A4AE), Color(0xFF546E7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) => menus[index],
    );
  }

  // ==================== BOTTOM NAV ====================
  Widget _bottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        onTap: (index) {
          if (index == 0) {
            controller.fetchDashboard();
          } else if (index == 1) {
            Get.toNamed(AppRoutes.adminAnggota);
          } else if (index == 2) {
            Get.toNamed(AppRoutes.adminSimpanan);
          } else if (index == 3) {
            Get.toNamed(AppRoutes.adminPinjaman);
          } else if (index == 4) {
            Get.toNamed(AppRoutes.adminLaporanKeuangan);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBrown,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final summary = controller.summary.value ?? {};

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchDashboard,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                _header(summary),

                _sectionTitle(
                  'Ringkasan Koperasi',
                  subtitle: _today(),
                  icon: Icons.dashboard_customize_rounded,
                ),
                _summaryGrid(summary),

                _sectionTitle(
                  'Kinerja Koperasi',
                  subtitle: 'Persentase',
                  icon: Icons.trending_up_rounded,
                ),
                _progressSection(summary),

                _sectionTitle(
                  'Ringkasan Keuangan',
                  subtitle: 'Data terbaru',
                  icon: Icons.account_balance_rounded,
                ),
                _financeSummary(summary),

                _sectionTitle(
                  'Menu Admin',
                  subtitle: '${8} menu',
                  icon: Icons.menu_book_rounded,
                ),
                _adminMenu(),
              ],
            ),
          );
        }),
      ),
    );
  }
}