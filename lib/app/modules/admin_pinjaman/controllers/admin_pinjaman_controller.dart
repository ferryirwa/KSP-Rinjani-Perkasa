import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;
import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminPinjamanController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final isLoading = false.obs;
  final isUpdating = false.obs;

  final pinjamans = <Map<String, dynamic>>[].obs;
  final riskScore = <int, Map<String, dynamic>>{}.obs;
  final riskLoading = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPinjaman();
  }

  int? _parseId(dynamic value) {
    return int.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic> _normalizeRiskData(dynamic result) {
    if (result == null) return {};

    if (result is Map) {
      final map = Map<String, dynamic>.from(result);
      final source = map['data'] is Map ? map['data'] : map;

      if (source is Map) {
        final normalized = Map<String, dynamic>.from(source);

        return {
          'risk_percentage': double.tryParse(
                normalized['risk_percentage']?.toString() ??
                    normalized['score']?.toString() ??
                    normalized['probability']?.toString() ??
                    normalized['persentase']?.toString() ??
                    '0',
              ) ??
              0,
          'risk_category': normalized['risk_category']?.toString() ??
              normalized['kategori']?.toString() ??
              normalized['kategori_risiko']?.toString() ??
              normalized['label']?.toString() ??
              'unknown',
          ...normalized,
        };
      }
    }

    return {};
  }

  void _syncRiskToPinjaman(int id, Map<String, dynamic> riskData) {
    final index = pinjamans.indexWhere((item) => _parseId(item['id']) == id);
    if (index == -1) return;

    final updated = Map<String, dynamic>.from(pinjamans[index]);
    updated['ml_analysis'] = riskData;
    updated['skor_ml'] = riskData['risk_percentage'];
    updated['kategori_risiko'] = riskData['risk_category'];

    pinjamans[index] = updated;
    pinjamans.refresh();
  }

  void _hydrateRiskFromPinjamanList(List<Map<String, dynamic>> items) {
    for (final item in items) {
      final id = _parseId(item['id']);
      if (id == null) continue;

      Map<String, dynamic>? riskData;

      if (item['ml_analysis'] is Map) {
        riskData = _normalizeRiskData(item['ml_analysis']);
      } else if (item['risk_percentage'] != null ||
          item['risk_category'] != null ||
          item['skor_ml'] != null ||
          item['kategori_risiko'] != null) {
        riskData = _normalizeRiskData({
          'risk_percentage': item['risk_percentage'] ?? item['skor_ml'],
          'risk_category': item['risk_category'] ?? item['kategori_risiko'],
        });
      }

      if (riskData != null && riskData.isNotEmpty) {
        riskScore[id] = riskData;
      }
    }

    riskScore.refresh();
  }

  Future<void> fetchRisk(int id) async {
    if (riskLoading[id] == true) return;

    try {
      riskLoading[id] = true;
      riskLoading.refresh();

      debugPrint('REQUEST RISK ID : $id');

      final result = await _adminRepository.getRiskPinjaman(id);

      debugPrint('RISK RESPONSE : $result');

      if (result is Map && result['success'] == false) {
        throw Exception(result['message'] ?? 'Risk gagal');
      }

      final data = _normalizeRiskData(result);

      if (data.isEmpty) {
        throw Exception('Data analisa risiko kosong atau format tidak sesuai');
      }

      riskScore[id] = data;
      riskScore.refresh();

      _syncRiskToPinjaman(id, data);

      Get.snackbar(
        'Berhasil',
        'Analisa risiko selesai',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      debugPrint('=================');
      debugPrint('URL : ${e.requestOptions.uri}');
      debugPrint('STATUS : ${e.response?.statusCode}');
      debugPrint('BODY : ${e.response?.data}');
      debugPrint('=================');

      Get.snackbar(
        'API ERROR',
        '${e.response?.statusCode ?? ''} ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'ERROR',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      riskLoading[id] = false;
      riskLoading.refresh();
    }
  }

  Future<void> fetchPinjaman() async {
    try {
      isLoading.value = true;

      final result = await _adminRepository.getPinjaman();
      final data = result['data'];

      if (data is List) {
        final items = data
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        pinjamans.assignAll(items);
        _hydrateRiskFromPinjamanList(items);
      } else {
        pinjamans.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus({
    required dynamic id,
    required String status,
  }) async {
    try {
      isUpdating.value = true;

      await _adminRepository.updateStatusPinjaman(
        id: id,
        status: status,
        catatan: null,
      );

      await fetchPinjaman();

      Get.back();

      Get.snackbar(
        'Berhasil',
        'Status pinjaman berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void showStatusSheet(Map<String, dynamic> pinjaman) {
    final id = _parseId(pinjaman['id']);
    if (id == null) return;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Update Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: const Text('Diproses'),
              onTap: () {
                updateStatus(
                  id: id,
                  status: 'diproses',
                );
              },
            ),
            ListTile(
              title: const Text('Disetujui'),
              onTap: () {
                updateStatus(
                  id: id,
                  status: 'disetujui',
                );
              },
            ),
            ListTile(
              title: const Text('Ditolak'),
              onTap: () {
                updateStatus(
                  id: id,
                  status: 'ditolak',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
