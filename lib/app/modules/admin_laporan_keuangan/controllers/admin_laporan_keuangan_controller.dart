import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Get;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminLaporanKeuanganController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  final isLoading = false.obs;
  final isDownloading = false.obs;

  final summary = Rxn<Map<String, dynamic>>();
  final transaksis = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    try {
      isLoading.value = true;

      final result = await _adminRepository.getLaporanKeuangan();
      summary.value = Map<String, dynamic>.from(result['summary'] ?? {});

      final data = result['data'] as List<dynamic>? ?? [];
      transaksis.value = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final message = responseData is Map && responseData['message'] != null
          ? responseData['message'].toString()
          : 'Gagal memuat laporan keuangan.';

      Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat laporan keuangan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Directory> _reportDirectory() async {
    final externalStorageDirectory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : null;
    final baseDirectory =
        externalStorageDirectory ?? await getApplicationDocumentsDirectory();
    final directory = Directory(
      '${baseDirectory.path}${Platform.pathSeparator}laporan',
    );

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<void> _openDownloadedReport({
    required String filePath,
    required String label,
  }) async {
    final file = File(filePath);
    if (!await file.exists() || await file.length() == 0) {
      throw StateError('Berkas $label tidak berhasil diunduh.');
    }

    final result = await OpenFilex.open(filePath);
    if (result.type == ResultType.done) {
      Get.snackbar(
        'Berhasil',
        'Laporan $label berhasil dibuat dan dibuka.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'File berhasil dibuat',
      'Tidak dapat membuka file otomatis (${result.message}). Lokasi: $filePath',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
    );
  }

  Future<void> cetakPdf() async {
    try {
      isDownloading.value = true;

      final directory = await _reportDirectory();
      final filePath = '${directory.path}${Platform.pathSeparator}'
          'laporan-keuangan-rinjani-${DateTime.now().millisecondsSinceEpoch}.pdf';

      await _adminRepository.downloadLaporanPdf(filePath);
      await _openDownloadedReport(filePath: filePath, label: 'PDF');
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final message = responseData is Map && responseData['message'] != null
          ? responseData['message'].toString()
          : 'Gagal membuat laporan PDF.';

      Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal membuat laporan PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> exportExcel() async {
    try {
      isDownloading.value = true;

      final directory = await _reportDirectory();
      final filePath = '${directory.path}${Platform.pathSeparator}'
          'laporan-keuangan-rinjani-${DateTime.now().millisecondsSinceEpoch}.xls';

      await _adminRepository.downloadLaporanExcel(filePath);
      await _openDownloadedReport(filePath: filePath, label: 'Excel');
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final message = responseData is Map && responseData['message'] != null
          ? responseData['message'].toString()
          : 'Gagal membuat laporan Excel.';

      Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal membuat laporan Excel: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDownloading.value = false;
    }
  }
}
