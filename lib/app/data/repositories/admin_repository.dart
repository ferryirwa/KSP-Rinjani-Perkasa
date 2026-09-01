import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class AdminRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConstants.adminLogin,
      data: {
        'email': email,
        'password': password,
      },
      requiresAuth: false,
    );

    final data = response.data;

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const FormatException(
      'Respons login admin dari server bukan JSON yang valid.',
    );
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiService.get(ApiConstants.adminDashboard);
    return response.data;
  }

  Future<Map<String, dynamic>> getAnggota() async {
    final response = await _apiService.get(ApiConstants.adminAnggota);
    return response.data;
  }

  Future<Map<String, dynamic>> tambahAnggota({
    required String nomorAnggota,
    required String nama,
    required String email,
    required String password,
    required String noHp,
    required String alamat,
    required String status,
  }) async {
    final response = await _apiService.post(
      ApiConstants.adminAnggota,
      data: {
        'nomor_anggota': nomorAnggota,
        'nama': nama,
        'email': email,
        'password': password,
        'no_hp': noHp,
        'alamat': alamat,
        'status': status,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>> updateAnggota({
    required dynamic id,
    required String nomorAnggota,
    required String nama,
    required String email,
    String? password,
    required String noHp,
    required String alamat,
    required String status,
  }) async {
    final Map<String, dynamic> data = {
      'nomor_anggota': nomorAnggota,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'alamat': alamat,
      'status': status,
    };

    if (password != null && password.isNotEmpty) {
      data['password'] = password;
    }

    final response = await _apiService.put(
      ApiConstants.adminAnggotaDetail(id),
      data: data,
    );

    return response.data;
  }

  Future<Map<String, dynamic>> hapusAnggota(dynamic id) async {
    final response = await _apiService.delete(
      ApiConstants.adminAnggotaDetail(id),
    );

    return response.data;
  }
Future<Map<String, dynamic>> getSimpanan() async {
  final response = await _apiService.get(ApiConstants.adminSimpanan);
  return response.data;
}

Future<Map<String, dynamic>> tambahSimpanan({
  required int anggotaId,
  required String jenisSimpanan,
  required double jumlah,
  required String tanggalSimpanan,
  required String keterangan,
}) async {
  final response = await _apiService.post(
    ApiConstants.adminSimpanan,
    data: {
      'anggota_id': anggotaId,
      'jenis_simpanan': jenisSimpanan,
      'jumlah': jumlah,
      'tanggal_simpanan': tanggalSimpanan,
      'keterangan': keterangan,
    },
  );

  return response.data;
}
Future<Map<String, dynamic>> getPinjaman() async {
  final response = await _apiService.get(ApiConstants.adminPinjaman);
  return response.data;
}

Future<Map<String, dynamic>> updateStatusPinjaman({
  required dynamic id,
  required String status,
  String? catatan,
}) async {
  final response = await _apiService.put(
    ApiConstants.adminUpdateStatusPinjaman(id),
    data: {
      'status': status,
      'catatan': catatan,
    },
  );

  return response.data;
}
Future<Map<String, dynamic>> getRiskPinjaman(
  int id,
) async {
  final response = await _apiService.post(
    ApiConstants.adminRiskPinjaman(id),
  );

  final rawData = response.data;

  if (rawData is! Map) {
    throw const FormatException(
      'Format respons risiko tidak valid.',
    );
  }

  return Map<String, dynamic>.from(rawData);
}
Future<Map<String, dynamic>> getAngsuran() async {
  final response = await _apiService.get(ApiConstants.adminAngsuran);
  return response.data;
}

Future<Map<String, dynamic>> bayarAngsuran(dynamic id) async {
  final response = await _apiService.post(
    ApiConstants.adminBayarAngsuran(id),
  );

  return response.data;
}
Future<Map<String, dynamic>> getLaporanKeuangan() async {
  final response = await _apiService.get(ApiConstants.adminLaporanKeuangan);
  return response.data;
}

Future<void> downloadLaporanPdf(String savePath) async {
  await _apiService.download(
    ApiConstants.adminLaporanKeuanganPdf,
    savePath,
  );
}

Future<void> downloadLaporanExcel(String savePath) async {
  await _apiService.download(
    ApiConstants.adminLaporanKeuanganExcel,
    savePath,
  );
}
Future<Map<String, dynamic>> getPengaturan() async {
  final res = await _apiService.get(ApiConstants.adminPengaturan);
  final data = res.data;

  if (data is Map && data['data'] is Map) {
    return Map<String, dynamic>.from(data['data'] as Map);
  }

  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }

  throw const FormatException('Format respons pengaturan tidak valid.');
}

Future<void> updatePengaturan(Map<String, dynamic> data) async {
  await _apiService.post(ApiConstants.adminPengaturan, data: data);
}
Future<Map<String, dynamic>> getAdminProfile() async {
  final response = await _apiService.get(ApiConstants.adminProfile);

  final data = response.data;

  if (data is Map && data['data'] is Map) {
    return Map<String, dynamic>.from(data['data']);
  }

  return {};
}

Future<void> changeAdminPassword({
  required String currentPassword,
  required String password,
  required String passwordConfirmation,
}) async {
  await _apiService.post(
    ApiConstants.adminChangePassword,
    data: {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    },
  );
}

Future<Map<String, dynamic>> uploadAdminPhoto(String filePath) async {
  final formData = FormData.fromMap({
    'photo': await MultipartFile.fromFile(filePath),
  });

  final response = await _apiService.postMultipart(
    ApiConstants.adminProfilePhoto,
    data: formData,
  );

  final data = response.data;

  if (data is Map && data['data'] is Map) {
    return Map<String, dynamic>.from(data['data']);
  }

  return {};
}

Future<void> logout() async {
  await _apiService.post(ApiConstants.adminLogout);
}

}
