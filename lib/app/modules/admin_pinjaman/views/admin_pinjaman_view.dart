import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_pinjaman_controller.dart';
import '../../../core/constants/app_colors.dart';

class AdminPinjamanView extends GetView<AdminPinjamanController> {
  const AdminPinjamanView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.warning;
  static const Color red = AppColors.danger;

  String rupiah(dynamic value) {
    final number = double.tryParse(value?.toString() ?? '0') ?? 0;
    return 'Rp ${number.toStringAsFixed(0)}';
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diajukan':
        return orange;
      case 'diproses':
        return primary;
      case 'disetujui':
        return green;
      case 'ditolak':
        return red;
      case 'dicairkan':
        return Colors.purple;
      case 'lunas':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
      case 'rendah':
        return green;
      case 'medium':
      case 'sedang':
        return orange;
      case 'high':
      case 'tinggi':
        return red;
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic> normalizeRiskData(dynamic raw) {
    if (raw == null) return {};

    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(raw['data']);
      }
      return raw;
    }

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      if (map['data'] is Map) {
        return Map<String, dynamic>.from(map['data']);
      }
      return map;
    }

    return {};
  }

  Widget riskCard(Map<String, dynamic> data) {
    final normalized = normalizeRiskData(data);

    final score = double.tryParse(
          normalized['risk_percentage']?.toString() ??
              normalized['score']?.toString() ??
              normalized['probability']?.toString() ??
              '0',
        ) ??
        0;

    final category = normalized['risk_category']?.toString() ??
        normalized['kategori']?.toString() ??
        normalized['kategori_risiko']?.toString() ??
        normalized['label']?.toString() ??
        'unknown';

    final color = riskColor(category);
    final eligibility = normalized['kelayakan_pinjaman']?.toString() ?? '';
    final isEligible = eligibility == 'layak';
    final eligibilityLabel = isEligible ? 'LAYAK' : 'TIDAK LAYAK';
    final eligibilityColor = isEligible ? green : red;
    final reason = normalized['decision_reason']?.toString() ?? '';
    final warnings = normalized['input_warnings'] is List
        ? List<String>.from(
            (normalized['input_warnings'] as List).map((item) => '$item'),
          )
        : <String>[];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.psychology_rounded, color: color),
              const SizedBox(width: 10),
              const Text(
                'AI Credit Risk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            width: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: (score / 100).clamp(0.0, 1.0),
                    strokeWidth: 12,
                    color: color,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${score.toInt()}%',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Risk',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              category.toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: eligibilityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  'REKOMENDASI: $eligibilityLabel',
                  style: TextStyle(
                    color: eligibilityColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (reason.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    reason,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          if (warnings.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: orange.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Perlu verifikasi admin: ${warnings.join(' ')}',
                style: TextStyle(color: Colors.brown.shade700, fontSize: 12),
              ),
            ),
          ],
          const SizedBox(height: 10),
          const Text(
            'Hasil ML adalah rekomendasi; keputusan akhir tetap oleh admin.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget pinjamanCard(Map<String, dynamic> item) {
    final anggota =
        item['anggota'] is Map ? Map<String, dynamic>.from(item['anggota']) : {};

    final int? pinjamanId = int.tryParse(item['id']?.toString() ?? '');
    final status = item['status']?.toString() ?? 'unknown';
    final statusColorValue = statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: statusColorValue,
                child: const Icon(
                  Icons.wallet_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['kode_pinjaman']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      anggota['nama']?.toString() ?? '-',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColorValue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColorValue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          infoRow(
            Icons.badge_rounded,
            'Nomor Anggota',
            anggota['nomor_anggota']?.toString() ?? '-',
          ),
          infoRow(
            Icons.money_rounded,
            'Jumlah',
            rupiah(item['jumlah_pinjaman']),
          ),
          infoRow(
            Icons.calendar_month_rounded,
            'Tenor',
            '${item['tenor_bulan'] ?? 0} bulan',
          ),
          const SizedBox(height: 16),
          Obx(() {
            final risk =
                pinjamanId == null ? null : controller.riskScore[pinjamanId];
            final loading = pinjamanId == null
                ? false
                : (controller.riskLoading[pinjamanId] ?? false);

            if (loading) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Menghitung risiko...',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }

            if (risk != null && risk.isNotEmpty) {
              return riskCard(risk);
            }

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics_rounded),
                label: const Text(
                  'Analisa Risiko AI',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                onPressed: pinjamanId == null
                    ? null
                    : () => controller.fetchRisk(pinjamanId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_rounded),
              label: const Text(
                'Ubah Status',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              onPressed: () => controller.showStatusSheet(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBrown,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Admin Pinjaman',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primary),
          );
        }

        if (controller.pinjamans.isEmpty) {
          return RefreshIndicator(
            color: primary,
            onRefresh: controller.fetchPinjaman,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height * .35),
                const Center(
                  child: Text(
                    'Belum ada data pinjaman',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: primary,
          onRefresh: controller.fetchPinjaman,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pinjamans.length,
            itemBuilder: (_, index) => pinjamanCard(controller.pinjamans[index]),
          ),
        );
      }),
    );
  }
}
