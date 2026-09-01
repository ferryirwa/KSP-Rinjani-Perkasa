import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/admin_simpanan_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminSimpananView extends StatefulWidget {
  const AdminSimpananView({super.key});

  @override
  State<AdminSimpananView> createState() => _AdminSimpananViewState();
}

class _AdminSimpananViewState extends State<AdminSimpananView> {
  final AdminSimpananController controller =
      Get.find<AdminSimpananController>();

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color blue = AppColors.info;
  static const Color orange = AppColors.warning;
  static const Color green = AppColors.success;

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

  String _jenisText(String jenis) {
    if (jenis.toLowerCase() == 'pokok') return 'Simpanan Pokok';
    if (jenis.toLowerCase() == 'wajib') return 'Simpanan Wajib';
    return 'Simpanan Sukarela';
  }

  Color _jenisColor(String jenis) {
    if (jenis.toLowerCase() == 'pokok') return blue;
    if (jenis.toLowerCase() == 'wajib') return orange;
    return green;
  }

  List<Map<String, dynamic>> _dataSimpanan() {
    return controller.simpanans.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
  }

  double _totalByJenis(String jenis) {
    double total = 0;

    for (final item in controller.simpanans) {
      final data = Map<String, dynamic>.from(item);
      final itemJenis = data['jenis_simpanan']?.toString().toLowerCase() ?? '';

      if (itemJenis == jenis) {
        total += double.tryParse(data['jumlah'].toString()) ?? 0;
      }
    }

    return total;
  }

  double _totalSemua() {
    double total = 0;

    for (final item in controller.simpanans) {
      final data = Map<String, dynamic>.from(item);
      total += double.tryParse(data['jumlah'].toString()) ?? 0;
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
                  'KoperasiKu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
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
              Icons.savings_rounded,
              color: Colors.white,
              size: 23,
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
  }) {
    return PremiumCard(
      padding: const EdgeInsets.all(14),
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
    final pokok = _totalByJenis('pokok');
    final wajib = _totalByJenis('wajib');
    final sukarela = _totalByJenis('sukarela');
    final total = _totalSemua();

    final cards = [
      _summaryCard(
        title: 'Simpanan Pokok',
        value: _rupiah(pokok),
        icon: Icons.account_balance_wallet_rounded,
        color: blue,
      ),
      _summaryCard(
        title: 'Simpanan Wajib',
        value: _rupiah(wajib),
        icon: Icons.savings_rounded,
        color: orange,
      ),
      _summaryCard(
        title: 'Simpanan Sukarela',
        value: _rupiah(sukarela),
        icon: Icons.volunteer_activism_rounded,
        color: green,
      ),
      _summaryCard(
        title: 'Total Simpanan',
        value: _rupiah(total),
        icon: Icons.paid_rounded,
        color: primary,
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

  Widget _addButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton.icon(
          onPressed: controller.goToTambahSimpanan,
          icon: const Icon(Icons.add_circle_rounded, size: 20),
          label: const Text(
            'Tambah Simpanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _compositionCard() {
    final pokok = _totalByJenis('pokok');
    final wajib = _totalByJenis('wajib');
    final sukarela = _totalByJenis('sukarela');
    final total = pokok + wajib + sukarela;

    double percent(double value) {
      if (total <= 0) return 0;
      return (value / total) * 100;
    }

    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Komposisi Simpanan',
            style: TextStyle(
              color: dark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: _DonutChartPainter(
                        values: [pokok, wajib, sukarela],
                        colors: const [blue, orange, green],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _rupiah(total),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: dark,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _legendRow(
                      color: blue,
                      title: 'Pokok',
                      value: _rupiah(pokok),
                      percent: '${percent(pokok).toStringAsFixed(1)}%',
                    ),
                    const SizedBox(height: 12),
                    _legendRow(
                      color: orange,
                      title: 'Wajib',
                      value: _rupiah(wajib),
                      percent: '${percent(wajib).toStringAsFixed(1)}%',
                    ),
                    const SizedBox(height: 12),
                    _legendRow(
                      color: green,
                      title: 'Sukarela',
                      value: _rupiah(sukarela),
                      percent: '${percent(sukarela).toStringAsFixed(1)}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendRow({
    required Color color,
    required String title,
    required String value,
    required String percent,
  }) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$title\n$value',
            style: const TextStyle(
              color: dark,
              fontSize: 11,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          percent,
          style: const TextStyle(
            color: dark,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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
            onTap: controller.fetchSimpanan,
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

  Widget _simpananItem(Map<String, dynamic> simpanan) {
    final anggota = simpanan['anggota'] is Map
        ? Map<String, dynamic>.from(simpanan['anggota'])
        : <String, dynamic>{};

    final jenis = simpanan['jenis_simpanan']?.toString() ?? '-';
    final nama = anggota['nama']?.toString() ?? 'Anggota';
    final nomorAnggota = anggota['nomor_anggota']?.toString() ?? '-';
    final tanggal = simpanan['tanggal_simpanan'] ?? simpanan['tanggal'];
    final jumlah = simpanan['jumlah'] ?? 0;

    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(18),
      color: cardColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: _jenisColor(jenis).withValues(alpha: 0.13),
            child: Icon(
              Icons.savings_rounded,
              color: _jenisColor(jenis),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
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
                  '${_jenisText(jenis)} • $nomorAnggota',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _tanggal(tanggal),
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
            '+ ${_rupiah(jumlah)}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: green,
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
            Icons.savings_outlined,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            'Belum ada data simpanan.',
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
      currentIndex: 2,
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
          controller.fetchSimpanan();
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
                final data = _dataSimpanan();

                if (controller.isLoading.value && data.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                return RefreshIndicator(
                  color: primary,
                  onRefresh: controller.fetchSimpanan,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 18),
                    children: [
                      _summaryGrid(),
                      _addButton(),
                      _compositionCard(),
                      _sectionTitle('Transaksi Terbaru', data.length),
                      if (data.isEmpty)
                        _emptyState()
                      else
                        ...data.map(_simpananItem),

                      if (controller.isLoading.value && data.isNotEmpty)
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

class _DonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  const _DonutChartPainter({
    required this.values,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (sum, item) => sum + item);

    final rect = Rect.fromLTWH(
      8,
      8,
      size.width - 16,
      size.height - 16,
    );

    final bgPaint = Paint()
      ..color = AppColors.borderLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2,
      false,
      bgPaint,
    );

    if (total <= 0) return;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * math.pi * 2;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.colors != colors;
  }
}