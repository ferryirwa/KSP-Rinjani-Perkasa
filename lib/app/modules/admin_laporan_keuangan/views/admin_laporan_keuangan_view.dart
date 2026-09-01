import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/admin_laporan_keuangan_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminLaporanKeuanganView extends GetView<AdminLaporanKeuanganController> {
  const AdminLaporanKeuanganView({super.key});

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

  Color _jenisColor(String jenis) {
    if (jenis.contains('simpanan')) return green;
    if (jenis == 'pembayaran_angsuran') return blue;
    if (jenis == 'pencairan_pinjaman') return red;
    if (jenis == 'pengajuan_pinjaman') return orange;
    return primary;
  }

  String _jenisText(String jenis) {
    return jenis.replaceAll('_', ' ').toUpperCase();
  }

  dynamic _summaryValue(Map summary, List<String> keys, {dynamic fallback = 0}) {
    for (final key in keys) {
      if (summary[key] != null) return summary[key];
    }

    return fallback;
  }

  double _summaryNumber(Map summary, List<String> keys) {
    final value = _summaryValue(summary, keys);
    return double.tryParse(value.toString()) ?? 0;
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
                  'Laporan Keuangan',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: controller.isDownloading.value
                  ? null
                  : controller.exportExcel,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    controller.isDownloading.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                    const SizedBox(width: 6),
                    const Text(
                      'Export',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageTitle(Map summary) {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Laporan Keuangan',
              style: TextStyle(
                color: dark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: primary,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Periode Ini',
                  style: TextStyle(
                    color: primary,
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

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String change = '+0%',
  }) {
    return PremiumCard(
      padding: const EdgeInsets.all(13),
      borderRadius: BorderRadius.circular(18),
      color: cardColor,
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryGrid(Map summary) {
    final totalSimpanan = _summaryNumber(summary, ['total_simpanan']);
    final totalPencairan = _summaryNumber(
      summary,
      ['total_pencairan_pinjaman'],
    );
    final totalAngsuran = _summaryNumber(
      summary,
      ['total_pembayaran_angsuran'],
    );
    final kasEstimasi = _summaryNumber(
      summary,
      ['saldo_kas_estimasi', 'kas_bersih'],
    );

    final cards = [
      _summaryCard(
        title: 'Total Simpanan',
        value: _rupiah(totalSimpanan),
        icon: Icons.savings_rounded,
        color: green,
        change: '+',
      ),
      _summaryCard(
        title: 'Pencairan Pinjaman',
        value: _rupiah(totalPencairan),
        icon: Icons.outbox_rounded,
        color: red,
        change: '-',
      ),
      _summaryCard(
        title: 'Pembayaran Angsuran',
        value: _rupiah(totalAngsuran),
        icon: Icons.receipt_long_rounded,
        color: blue,
        change: '+',
      ),
      _summaryCard(
        title: 'Saldo Kas Estimasi',
        value: _rupiah(kasEstimasi),
        icon: Icons.account_balance_rounded,
        color: primary,
        change: '=',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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

  List<_MonthlyFinance> _monthlyData() {
    final now = DateTime.now();
    final months = <_MonthlyFinance>[];

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      months.add(
        _MonthlyFinance(
          year: date.year,
          month: date.month,
          label: _monthLabel(date.month),
        ),
      );
    }

    for (final transaksi in controller.transaksis) {
      final data = Map<String, dynamic>.from(transaksi);
      final rawDate = data['tanggal_transaksi'] ?? data['created_at'];

      if (rawDate == null) continue;

      final parsedDate = DateTime.tryParse(rawDate.toString());
      if (parsedDate == null) continue;

      final index = months.indexWhere(
        (item) => item.year == parsedDate.year && item.month == parsedDate.month,
      );

      if (index == -1) continue;

      final jenis = data['jenis_transaksi']?.toString() ?? '';
      final jumlah = double.tryParse(data['jumlah'].toString()) ?? 0;

      if (jenis.contains('simpanan') || jenis == 'pembayaran_angsuran') {
        months[index].pendapatan += jumlah;
      } else if (jenis == 'pencairan_pinjaman') {
        months[index].beban += jumlah;
      }
    }

    return months;
  }

  String _monthLabel(int month) {
    const labels = [
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

    return labels[month - 1];
  }

  Widget _chartCard() {
    final months = _monthlyData();

    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Pendapatan vs Beban',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Berdasarkan transaksi 6 bulan terakhir',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarChartPainter(months: months),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _legendDot(green, 'Pendapatan'),
              const SizedBox(width: 16),
              _legendDot(orange, 'Beban'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _reportSummary(Map summary) {
    final totalSimpanan = _summaryNumber(summary, ['total_simpanan']);
    final totalPencairan = _summaryNumber(summary, ['total_pencairan_pinjaman']);
    final totalAngsuran = _summaryNumber(summary, ['total_pembayaran_angsuran']);
    final kasEstimasi = _summaryNumber(summary, ['saldo_kas_estimasi', 'kas_bersih']);
    final belumBayar = _summaryValue(
      summary,
      ['jumlah_anggota_belum_bayar'],
      fallback: 0,
    );
    final transaksi = _summaryValue(
      summary,
      ['jumlah_transaksi'],
      fallback: controller.transaksis.length,
    );
    final anggotaAktif = _summaryValue(
      summary,
      ['jumlah_anggota_aktif'],
      fallback: 0,
    );

    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Laporan',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _reportRow('Total Simpanan Masuk', _rupiah(totalSimpanan)),
          _reportRow('Total Pencairan Pinjaman', _rupiah(totalPencairan)),
          _reportRow('Total Pembayaran Angsuran', _rupiah(totalAngsuran)),
          _reportRow('Saldo Kas Estimasi', _rupiah(kasEstimasi)),
          _reportRow('Anggota Belum Bayar', '$belumBayar anggota'),
          _reportRow('Jumlah Transaksi', '$transaksi transaksi'),
          _reportRow('Anggota Aktif', '$anggotaAktif anggota'),
        ],
      ),
    );
  }

  Widget _reportRow(String title, String value) {
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
            textAlign: TextAlign.right,
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

  Widget _exportPanel() {
    return Obx(
      () => PremiumCard(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(22),
        color: cardColor,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.isDownloading.value
                    ? null
                    : controller.cetakPdf,
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                label: const Text(
                  'Cetak PDF',
                  style: TextStyle(fontWeight: FontWeight.w900),
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
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.isDownloading.value
                    ? null
                    : controller.exportExcel,
                icon: const Icon(Icons.table_chart_rounded, size: 18),
                label: const Text(
                  'Excel',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: const BorderSide(color: primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
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
            onTap: controller.fetchLaporan,
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

  Widget _transaksiItem(Map<String, dynamic> transaksi) {
    final anggota = transaksi['anggota'] is Map
        ? Map<String, dynamic>.from(transaksi['anggota'])
        : <String, dynamic>{};

    final jenis = transaksi['jenis_transaksi']?.toString() ?? '-';
    final color = _jenisColor(jenis);

    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(13),
      borderRadius: BorderRadius.circular(18),
      color: cardColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(
              Icons.receipt_long_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anggota['nama']?.toString() ?? 'Transaksi Koperasi',
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
                  _jenisText(jenis),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_tanggal(transaksi['tanggal_transaksi'])} • ${transaksi['status'] ?? '-'}',
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
          Text(
            _rupiah(transaksi['jumlah']),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
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
            'Belum ada transaksi keuangan.',
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
      currentIndex: 4,
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
          controller.fetchLaporan();
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
                if (controller.isLoading.value &&
                    controller.transaksis.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                final summary = controller.summary.value ?? {};

                return RefreshIndicator(
                  color: primary,
                  onRefresh: controller.fetchLaporan,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 18),
                    children: [
                      _pageTitle(summary),
                      _summaryGrid(summary),
                      _exportPanel(),
                      _chartCard(),
                      _reportSummary(summary),
                      _sectionTitle(
                        'Riwayat Transaksi',
                        controller.transaksis.length,
                      ),

                      if (controller.transaksis.isEmpty)
                        _emptyState()
                      else
                        ...controller.transaksis.map((item) {
                          return _transaksiItem(
                            Map<String, dynamic>.from(item),
                          );
                        }),

                      if (controller.isLoading.value &&
                          controller.transaksis.isNotEmpty)
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

class _MonthlyFinance {
  final int year;
  final int month;
  final String label;
  double pendapatan;
  double beban;

  _MonthlyFinance({
    required this.year,
    required this.month,
    required this.label,
    double? pendapatan,
    double? beban,
  }) : pendapatan = pendapatan ?? 0,
       beban = beban ?? 0;
}

class _BarChartPainter extends CustomPainter {
  final List<_MonthlyFinance> months;

  _BarChartPainter({
    required this.months,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderLight
      ..strokeWidth = 1;

    final pendapatanPaint = Paint()
      ..color = AdminLaporanKeuanganView.green
      ..style = PaintingStyle.fill;

    final bebanPaint = Paint()
      ..color = AdminLaporanKeuanganView.orange
      ..style = PaintingStyle.fill;

    final chartRect = Rect.fromLTWH(
      6,
      10,
      size.width - 12,
      size.height - 35,
    );

    for (int i = 0; i < 4; i++) {
      final y = chartRect.top + (chartRect.height / 3) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    double maxValue = 1;

    for (final item in months) {
      if (item.pendapatan > maxValue) maxValue = item.pendapatan;
      if (item.beban > maxValue) maxValue = item.beban;
    }

    final groupWidth = chartRect.width / months.length;
    final barWidth = groupWidth * 0.22;

    for (int i = 0; i < months.length; i++) {
      final item = months[i];
      final centerX = chartRect.left + groupWidth * i + groupWidth / 2;

      final pendapatanHeight =
          (item.pendapatan / maxValue) * chartRect.height;
      final bebanHeight = (item.beban / maxValue) * chartRect.height;

      final pendapatanRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - barWidth - 2,
          chartRect.bottom - pendapatanHeight,
          barWidth,
          pendapatanHeight,
        ),
        const Radius.circular(5),
      );

      final bebanRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX + 2,
          chartRect.bottom - bebanHeight,
          barWidth,
          bebanHeight,
        ),
        const Radius.circular(5),
      );

      canvas.drawRRect(pendapatanRect, pendapatanPaint);
      canvas.drawRRect(bebanRect, bebanPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: item.label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          chartRect.bottom + 11,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.months != months;
  }
}