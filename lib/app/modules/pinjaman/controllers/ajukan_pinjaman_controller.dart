import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Get;
import 'package:image_picker/image_picker.dart';

import 'package:rinjani/app/core/utils/app_get.dart';
import '../../../data/repositories/anggota_repository.dart';
import '../../../routes/app_routes.dart';

class AjukanPinjamanController extends GetxController {
  final AnggotaRepository _anggotaRepository = AnggotaRepository();

  final jumlahController = TextEditingController();
  final tenorController = TextEditingController();
  final tujuanController = TextEditingController();
  final nomorKtpController = TextEditingController();
  final usiaController = TextEditingController();
  final lamaBekerjaController = TextEditingController();
  final namaTempatKerjaController = TextEditingController();
  final penghasilanController = TextEditingController();
  final pendapatanTambahanController = TextEditingController();
  final pengeluaranController = TextEditingController();
  final cicilanLainController = TextEditingController();
  final tanggunganController = TextEditingController();

  final _picker = ImagePicker();

  final isLoading = false.obs;
  final jumlahPinjaman = 0.0.obs;
  final tenorBulan = 0.obs;
  final statusPekerjaan = 'full_time'.obs;
  final statusTempatTinggal = 'milik_sendiri'.obs;
  final pendidikanTerakhir = 'high_school'.obs;
  final wilayahDomisili = 'urban'.obs;
  final fotoKtpPath = ''.obs;
  final buktiPenghasilanPath = ''.obs;
  final buktiTempatTinggalPath = ''.obs;

  double get estimasiAngsuran {
    final jumlah = jumlahPinjaman.value;
    final tenor = tenorBulan.value;

    if (jumlah <= 0 || tenor <= 0) {
      return 0;
    }

    const bungaPersen = 1.5;
    final totalBunga = jumlah * (bungaPersen / 100) * tenor;
    final totalTagihan = jumlah + totalBunga;

    return totalTagihan / tenor;
  }

  void updateJumlah(String value) {
    jumlahPinjaman.value = double.tryParse(value.trim()) ?? 0;
  }

  void updateTenor(String value) {
    tenorBulan.value = int.tryParse(value.trim()) ?? 0;
  }

  Future<void> pickDocument(String documentType) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    switch (documentType) {
      case 'foto_ktp':
        fotoKtpPath.value = image.path;
        break;
      case 'bukti_penghasilan':
        buktiPenghasilanPath.value = image.path;
        break;
      case 'bukti_tempat_tinggal':
        buktiTempatTinggalPath.value = image.path;
        break;
    }
  }

  Future<void> submit() async {
    final jumlah = jumlahPinjaman.value;
    final tenor = tenorBulan.value;
    final tujuan = tujuanController.text.trim();
    final nomorKtp = nomorKtpController.text.trim();
    final usia = int.tryParse(usiaController.text.trim()) ?? 0;
    final lamaBekerja = int.tryParse(lamaBekerjaController.text.trim()) ?? -1;
    final penghasilan = double.tryParse(penghasilanController.text.trim()) ?? -1;
    final pendapatanTambahan =
        double.tryParse(pendapatanTambahanController.text.trim()) ?? 0;
    final pengeluaran = double.tryParse(pengeluaranController.text.trim()) ?? -1;
    final cicilanLain = double.tryParse(cicilanLainController.text.trim()) ?? -1;
    final tanggungan = int.tryParse(tanggunganController.text.trim()) ?? -1;

    if (jumlah < 100000) {
      Get.snackbar(
        'Gagal',
        'Jumlah pinjaman minimal Rp 100000.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (tenor < 1 || tenor > 36) {
      Get.snackbar(
        'Gagal',
        'Tenor harus antara 1 sampai 36 bulan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (tujuan.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Tujuan pinjaman wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!RegExp(r'^\d{16}$').hasMatch(nomorKtp)) {
      _showValidationError('Nomor KTP harus terdiri dari 16 digit.');
      return;
    }

    if (usia < 18 || usia > 100) {
      _showValidationError('Usia harus antara 18 sampai 100 tahun.');
      return;
    }

    if (
        lamaBekerja < 0 ||
        penghasilan < 0 ||
        pengeluaran < 0 ||
        cicilanLain < 0 ||
        tanggungan < 0) {
      _showValidationError('Lengkapi data pekerjaan dan kondisi keuangan dengan benar.');
      return;
    }

    if (
        fotoKtpPath.value.isEmpty ||
        buktiPenghasilanPath.value.isEmpty ||
        buktiTempatTinggalPath.value.isEmpty) {
      _showValidationError('Unggah foto KTP, bukti penghasilan, dan bukti tempat tinggal.');
      return;
    }

    try {
      isLoading.value = true;

      final result = await _anggotaRepository.ajukanPinjaman(
        jumlahPinjaman: jumlah,
        tenorBulan: tenor,
        tujuanPinjaman: tujuan,
        nomorKtp: nomorKtp,
        usia: usia,
        statusPekerjaan: statusPekerjaan.value,
        lamaBekerjaBulan: lamaBekerja,
        namaTempatKerja: namaTempatKerjaController.text.trim(),
        penghasilanBulanan: penghasilan,
        pendapatanTambahan: pendapatanTambahan,
        pengeluaranBulanan: pengeluaran,
        cicilanBulananLain: cicilanLain,
        jumlahTanggungan: tanggungan,
        statusTempatTinggal: statusTempatTinggal.value,
        pendidikanTerakhir: pendidikanTerakhir.value,
        wilayahDomisili: wilayahDomisili.value,
        fotoKtpPath: fotoKtpPath.value,
        buktiPenghasilanPath: buktiPenghasilanPath.value,
        buktiTempatTinggalPath: buktiTempatTinggalPath.value,
      );

      final analysis = result['ml_analysis'] is Map
          ? Map<String, dynamic>.from(result['ml_analysis'] as Map)
          : <String, dynamic>{};

      final mlCompleted = result['ml_status'] == 'completed' &&
          analysis['kelayakan_pinjaman'] != null;

      if (!mlCompleted) {
        Get.snackbar(
          'Pengajuan Berhasil',
          'Pengajuan sedang menunggu analisis dan tinjauan admin.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed(AppRoutes.pinjaman);
        return;
      }

      final kelayakan = analysis['kelayakan_pinjaman'] == 'layak'
          ? 'Layak'
          : 'Tidak Layak';
      final riskPercentage = analysis['risk_percentage']?.toString() ?? '-';

      Get.snackbar(
        'Berhasil',
        'Rekomendasi ML: $kelayakan. Risiko: $riskPercentage%. Keputusan akhir oleh admin.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offNamed(AppRoutes.pinjaman);
    } on DioException catch (e) {
      Get.snackbar(
        'Gagal',
        e.response?.data['message'] ?? 'Gagal mengajukan pinjaman.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengajukan pinjaman.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showValidationError(String message) {
    Get.snackbar(
      'Data Belum Lengkap',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    jumlahController.dispose();
    tenorController.dispose();
    tujuanController.dispose();
    nomorKtpController.dispose();
    usiaController.dispose();
    lamaBekerjaController.dispose();
    namaTempatKerjaController.dispose();
    penghasilanController.dispose();
    pendapatanTambahanController.dispose();
    pengeluaranController.dispose();
    cicilanLainController.dispose();
    tanggunganController.dispose();
    super.onClose();
  }
}
