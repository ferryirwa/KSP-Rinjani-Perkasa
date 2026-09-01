import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/transaksi_controller.dart';
import '../../../core/constants/app_colors.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final TransaksiController controller = Get.find<TransaksiController>();

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color red = AppColors.danger;
  static const Color blue = AppColors.info;

  String selectedFilter = 'semua';

  String _formatNumber(dynamic value) {
    final number = double.tryParse(value.toString()) ?? 0;
    final text = number.toInt().abs().toString();

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

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String _monthTitle(dynamic value) {
    final date = _parseDate(value);

    if (date == null) return 'Tanggal Tidak Diketahui';

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  String _jenisText(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'simpanan':
        return 'Simpanan';
      case 'simpanan_pokok':
        return 'Setoran Simpanan Pokok';
      case 'simpanan_wajib':
        return 'Setoran Simpanan Wajib';
      case 'simpanan_sukarela':
        return 'Setoran Simpanan Sukarela';
      case 'pengajuan_pinjaman':
        return 'Pengajuan Pinjaman';
      case 'pencairan_pinjaman':
        return 'Pencairan Pinjaman';
      case 'pembayaran_angsuran':
        return 'Bayar Angsuran';
      default:
        return jenis.replaceAll('_', ' ').toUpperCase();
    }
  }

  IconData _jenisIcon(String jenis) {
    final value = jenis.toLowerCase();

    if (value.contains('simpanan')) {
      return Icons.savings_rounded;
    }

    if (value == 'pengajuan_pinjaman') {
      return Icons.assignment_turned_in_rounded;
    }

    if (value == 'pencairan_pinjaman') {
      return Icons.account_balance_wallet_rounded;
    }

    if (value == 'pembayaran_angsuran') {
      return Icons.payments_rounded;
    }

    return Icons.receipt_long_rounded;
  }

  Color _jenisColor(String jenis) {
    final value = jenis.toLowerCase();

    if (value.contains('simpanan')) {
      return green;
    }

    if (value == 'pengajuan_pinjaman') {
      return orange;
    }

    if (value == 'pencairan_pinjaman') {
      return blue;
    }

    if (value == 'pembayaran_angsuran') {
      return red;
    }

    return primary;
  }

  bool _isIncome(String jenis) {
    final value = jenis.toLowerCase();

    return value.contains('simpanan') || value == 'pencairan_pinjaman';
  }

  bool _isExpense(String jenis) {
    return jenis.toLowerCase() == 'pembayaran_angsuran';
  }

  String _amountPrefix(String jenis) {
    if (_isExpense(jenis)) return '- ';
    if (_isIncome(jenis)) return '+ ';
    return '';
  }

  Color _amountColor(String jenis) {
    if (_isExpense(jenis)) return red;
    if (_isIncome(jenis)) return green;
    return dark;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'berhasil':
        return green;
      case 'pending':
        return orange;
      case 'gagal':
        return red;
      default:
        return primary;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'berhasil':
        return 'Berhasil';
      case 'pending':
        return 'Pending';
      case 'gagal':
        return 'Gagal';
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> _filteredData() {
    final data = controller.transaksis.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    final filtered = data.where((item) {
      final jenis = item['jenis_transaksi']?.toString().toLowerCase() ?? '';

      if (selectedFilter == 'semua') return true;
      if (selectedFilter == 'simpanan') return jenis.contains('simpanan');
      if (selectedFilter == 'pinjaman') return jenis.contains('pinjaman');
      if (selectedFilter == 'angsuran') return jenis == 'pembayaran_angsuran';

      return true;
    }).toList();

    filtered.sort((a, b) {
      final dateA = _parseDate(a['tanggal_transaksi'] ?? a['created_at']);
      final dateB = _parseDate(b['tanggal_transaksi'] ?? b['created_at']);

      if (dateA == null || dateB == null) return 0;

      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  Map<String, List<Map<String, dynamic>>> _groupByMonth(
    List<Map<String, dynamic>> data,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final item in data) {
      final key = _monthTitle(item['tanggal_transaksi'] ?? item['created_at']);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    return grouped;
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
                  'Riwayat Transaksi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Aktivitas simpanan, pinjaman, dan angsuran',
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
            onTap: controller.fetchTransaksi,
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

  Widget _filterPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
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
          _filterButton('Semua', 'semua'),
          const SizedBox(width: 8),
          _filterButton('Simpanan', 'simpanan'),
          const SizedBox(width: 8),
          _filterButton('Pinjaman', 'pinjaman'),
          const SizedBox(width: 8),
          _filterButton('Angsuran', 'angsuran'),
        ],
      ),
    );
  }

  Widget _filterButton(String label, String value) {
    final selected = selectedFilter == value;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? primary : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : dark,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: dark,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _transaksiItem(Map<String, dynamic> item) {
    final jenis = item['jenis_transaksi']?.toString() ?? '-';
    final status = item['status']?.toString() ?? '-';
    final color = _jenisColor(jenis);

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
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(
              _jenisIcon(jenis),
              color: color,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _jenisText(jenis),
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
                  _tanggal(item['tanggal_transaksi'] ?? item['created_at']),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item['keterangan']?.toString() ??
                      item['kode_transaksi']?.toString() ??
                      '-',
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
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_amountPrefix(jenis)}${_rupiah(item['jumlah'] ?? 0)}',
                style: TextStyle(
                  color: _amountColor(jenis),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _statusText(status),
                  style: TextStyle(
                    color: _statusColor(status),
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
            Icons.receipt_long_outlined,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            'Belum ada riwayat transaksi.',
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
      currentIndex: 1,
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
          controller.fetchTransaksi();
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
          if (controller.isLoading.value && controller.transaksis.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final data = _filteredData();
          final groupedData = _groupByMonth(data);

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchTransaksi,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 18),
              children: [
                _header(),
                _filterPanel(),

                if (data.isEmpty)
                  _emptyState()
                else
                  ...groupedData.entries.expand((entry) {
                    return [
                      _monthHeader(entry.key),
                      ...entry.value.map(_transaksiItem),
                    ];
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
    );
  }
}