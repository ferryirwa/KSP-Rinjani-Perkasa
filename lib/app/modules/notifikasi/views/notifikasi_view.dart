import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/notifikasi_controller.dart';
import '../../../core/constants/app_colors.dart';

class NotifikasiView extends StatefulWidget {
  const NotifikasiView({super.key});

  @override
  State<NotifikasiView> createState() => _NotifikasiViewState();
}

class _NotifikasiViewState extends State<NotifikasiView> {
  final NotifikasiController controller = Get.find<NotifikasiController>();

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color red = AppColors.danger;
  static const Color blue = AppColors.info;

  String selectedFilter = 'semua';

  IconData _iconTipe(String tipe) {
    final value = tipe.toLowerCase();

    if (value == 'pinjaman') {
      return Icons.account_balance_wallet_rounded;
    }

    if (value == 'angsuran') {
      return Icons.payments_rounded;
    }

    if (value == 'simpanan') {
      return Icons.savings_rounded;
    }

    if (value == 'sistem') {
      return Icons.info_rounded;
    }

    return Icons.notifications_rounded;
  }

  Color _warnaTipe(String tipe) {
    final value = tipe.toLowerCase();

    if (value == 'pinjaman') {
      return blue;
    }

    if (value == 'angsuran') {
      return orange;
    }

    if (value == 'simpanan') {
      return green;
    }

    if (value == 'sistem') {
      return primary;
    }

    return primary;
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

  String _jam(dynamic value) {
    if (value == null) return '';

    final text = value.toString();

    try {
      final date = DateTime.parse(text);
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (_) {
      if (text.contains(' ')) {
        final parts = text.split(' ');
        if (parts.length > 1) {
          return parts[1].split('.').first.substring(0, 5);
        }
      }
      return '';
    }
  }

  String _tipeLabel(String tipe) {
    final value = tipe.toLowerCase();

    if (value == 'pinjaman') return 'Pinjaman';
    if (value == 'angsuran') return 'Angsuran';
    if (value == 'simpanan') return 'Simpanan';
    if (value == 'sistem') return 'Sistem';

    return tipe;
  }

  List<Map<String, dynamic>> _filteredData() {
    final data = controller.notifikasis.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    final filtered = data.where((item) {
      final tipe = item['tipe']?.toString().toLowerCase() ?? '';

      if (selectedFilter == 'semua') return true;

      if (selectedFilter == 'transaksi') {
        return tipe == 'simpanan' || tipe == 'angsuran';
      }

      if (selectedFilter == 'pinjaman') {
        return tipe == 'pinjaman';
      }

      if (selectedFilter == 'sistem') {
        return tipe == 'sistem' || tipe == 'notifikasi';
      }

      return true;
    }).toList();

    return filtered;
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
                  'Notifikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Informasi terbaru dari koperasi',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.unreadCount.value <= 0) {
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: controller.fetchNotifikasi,
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
              );
            }

            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: controller.isActionLoading.value
                  ? null
                  : controller.tandaiSemuaDibaca,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: controller.isActionLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Tandai semua',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            );
          }),
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    '${controller.unreadCount.value} notifikasi belum dibaca',
                    style: const TextStyle(
                      color: dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: controller.fetchNotifikasi,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _filterButton('Semua', 'semua'),
              const SizedBox(width: 8),
              _filterButton('Transaksi', 'transaksi'),
              const SizedBox(width: 8),
              _filterButton('Pinjaman', 'pinjaman'),
              const SizedBox(width: 8),
              _filterButton('Sistem', 'sistem'),
            ],
          ),
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

  Widget _notifikasiItem(Map<String, dynamic> item) {
    final tipe = item['tipe']?.toString() ?? '-';
    final sudahDibaca = controller.sudahDibaca(item);
    final color = _warnaTipe(tipe);
    final createdAt = item['created_at'];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: sudahDibaca ? cardColor : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: sudahDibaca ? AppColors.borderLight : orange.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 9,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: sudahDibaca
            ? null
            : () {
                controller.tandaiDibaca(item['id']);
              },
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: color.withValues(alpha: 0.12),
                    child: Icon(
                      _iconTipe(tipe),
                      color: color,
                      size: 22,
                    ),
                  ),
                  if (!sudahDibaca)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['judul']?.toString() ?? '-',
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
                      item['pesan']?.toString() ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.11),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _tipeLabel(tipe),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _tanggal(createdAt),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Text(
                _jam(createdAt),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
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
            Icons.notifications_none_rounded,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            'Belum ada notifikasi.',
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
          Get.offNamed(AppRoutes.dashboard);
        } else if (index == 1) {
          Get.toNamed(AppRoutes.transaksi);
        } else if (index == 2) {
          Get.toNamed(AppRoutes.ajukanPinjaman);
        } else if (index == 3) {
          controller.fetchNotifikasi();
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
              controller.notifikasis.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final data = _filteredData();

          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchNotifikasi,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 18),
              children: [
                _header(),
                _filterPanel(),

                if (data.isEmpty)
                  _emptyState()
                else
                  ...data.map(_notifikasiItem),

                if (controller.isLoading.value &&
                    controller.notifikasis.isNotEmpty)
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