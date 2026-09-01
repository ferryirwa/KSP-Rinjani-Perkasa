import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class AnggotaRepository {
  final ApiService _apiService = ApiService();
Future<Map<String, dynamic>> getTrackingStatus() async {
  final response = await _apiService.get(ApiConstants.trackingStatus);
  return response.data;
}

Future<Map<String, dynamic>> getTrackingPengajuanPinjaman(dynamic id) async {
  final response = await _apiService.get(
    ApiConstants.trackingPengajuanPinjaman(id),
  );

  return response.data;
}

Future<Map<String, dynamic>> getTrackingAngsuranPinjaman(dynamic id) async {
  final response = await _apiService.get(
    ApiConstants.trackingAngsuranPinjaman(id),
  );

  return response.data;
}

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiService.get(ApiConstants.dashboard);
    return response.data;
  }

 Future<Map<String, dynamic>> getProfil() async {
  final response = await _apiService.get(ApiConstants.profil);
  return response.data;
}

Future<Map<String, dynamic>> updateProfil({
  required String noHp,
  required String alamat,
}) async {
  final response = await _apiService.put(
    ApiConstants.profil,
    data: {
      'no_hp': noHp,
      'alamat': alamat,
    },
  );

  return response.data;
}
  Future<Map<String, dynamic>> getSimpanan() async {
    final response = await _apiService.get(ApiConstants.simpanan);
    return response.data;
  }

  Future<Map<String, dynamic>> getPinjaman() async {
    final response = await _apiService.get(ApiConstants.pinjaman);
    return response.data;
  }

  Future<Map<String, dynamic>> ajukanPinjaman({
    required double jumlahPinjaman,
    required int tenorBulan,
    required String tujuanPinjaman,
    required String nomorKtp,
    required int usia,
    required String statusPekerjaan,
    required int lamaBekerjaBulan,
    required String namaTempatKerja,
    required double penghasilanBulanan,
    required double pendapatanTambahan,
    required double pengeluaranBulanan,
    required double cicilanBulananLain,
    required int jumlahTanggungan,
    required String statusTempatTinggal,
    required String pendidikanTerakhir,
    required String wilayahDomisili,
    required String fotoKtpPath,
    required String buktiPenghasilanPath,
    required String buktiTempatTinggalPath,
  }) async {
    final formData = FormData.fromMap({
      'jumlah_pinjaman': jumlahPinjaman,
      'tenor_bulan': tenorBulan,
      'tujuan_pinjaman': tujuanPinjaman,
      'nomor_ktp': nomorKtp,
      'usia': usia,
      'status_pekerjaan': statusPekerjaan,
      'lama_bekerja_bulan': lamaBekerjaBulan,
      'nama_tempat_kerja': namaTempatKerja,
      'penghasilan_bulanan': penghasilanBulanan,
      'pendapatan_tambahan': pendapatanTambahan,
      'pengeluaran_bulanan': pengeluaranBulanan,
      'cicilan_bulanan_lain': cicilanBulananLain,
      'jumlah_tanggungan': jumlahTanggungan,
      'status_tempat_tinggal': statusTempatTinggal,
      'pendidikan_terakhir': pendidikanTerakhir,
      'wilayah_domisili': wilayahDomisili,
      'foto_ktp': await MultipartFile.fromFile(fotoKtpPath),
      'bukti_penghasilan': await MultipartFile.fromFile(buktiPenghasilanPath),
      'bukti_tempat_tinggal': await MultipartFile.fromFile(buktiTempatTinggalPath),
    });

    final response = await _apiService.postMultipart(
      ApiConstants.ajukanPinjaman,
      data: formData,
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getAngsuran() async {
    final response = await _apiService.get(ApiConstants.angsuran);
    return response.data;
  }

  Future<Map<String, dynamic>> bayarAngsuranDemo(dynamic id) async {
    final response = await _apiService.post(
      ApiConstants.bayarAngsuranDemo(id),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getTransaksi() async {
    final response = await _apiService.get(ApiConstants.transaksi);
    return response.data;
  }

  Future<Map<String, dynamic>> getNotifikasi() async {
  final response = await _apiService.get(ApiConstants.notifikasi);
  return response.data;
}

Future<Map<String, dynamic>> bacaNotifikasi(dynamic id) async {
  final response = await _apiService.post(
    ApiConstants.bacaNotifikasi(id),
  );

  return response.data;
}

Future<Map<String, dynamic>> bacaSemuaNotifikasi() async {
  final response = await _apiService.post(
    ApiConstants.bacaSemuaNotifikasi,
  );

  return response.data;
}
}
