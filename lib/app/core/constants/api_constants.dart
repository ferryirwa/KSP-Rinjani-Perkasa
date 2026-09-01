import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  /*
    IP laptop/PC saat ini:
    172.16.9.75

    Android Emulator:
    flutter run --dart-define=USE_EMULATOR=true

    HP fisik:
    flutter run

    Override manual:
    flutter run \
      --dart-define=API_BASE_URL=http://172.16.9.75:8000/api/
  */

  static const String _apiBaseUrlFromEnv =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const bool _useEmulator =
      bool.fromEnvironment(
    'USE_EMULATOR',
    defaultValue: false,
  );

  /*
   * Semua base URL wajib memiliki garis miring
   * pada bagian akhir.
   */
static const String _physicalDeviceBaseUrl =
    'https://ksprinjani-perkasa.my.id/api/';
static const String _webBaseUrl =
    'https://ksprinjani-perkasa.my.id/api/';
static const String _emulatorBaseUrl =
    'https://ksprinjani-perkasa.my.id/api/';

  static String _normalizeBaseUrl(String url) {
    final trimmedUrl = url.trim();

    if (trimmedUrl.endsWith('/')) {
      return trimmedUrl;
    }

    return '$trimmedUrl/';
  }

  static List<String> get baseUrls {
    if (_apiBaseUrlFromEnv.isNotEmpty) {
      return [
        _normalizeBaseUrl(
          _apiBaseUrlFromEnv,
        ),
      ];
    }

    if (kIsWeb) {
      return [
        _normalizeBaseUrl(
          _webBaseUrl,
        ),
      ];
    }

    if (defaultTargetPlatform ==
            TargetPlatform.android &&
        _useEmulator) {
      return [
        _normalizeBaseUrl(
          _emulatorBaseUrl,
        ),
        _normalizeBaseUrl(
          _physicalDeviceBaseUrl,
        ),
      ];
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return [
        _normalizeBaseUrl(
          _physicalDeviceBaseUrl,
        ),
        _normalizeBaseUrl(
          _emulatorBaseUrl,
        ),
      ];
    }

    return [
      _normalizeBaseUrl(
        _physicalDeviceBaseUrl,
      ),
    ];
  }

  static String get baseUrl {
    return baseUrls.first;
  }

  // =========================================================
  // AUTENTIKASI ANGGOTA
  // =========================================================

  static const String login = 'login';
  static const String logout = 'logout';
  static const String firebaseToken = 'anggota/firebase-token';

  // =========================================================
  // ANGGOTA
  // =========================================================

  static const String dashboard =
      'anggota/dashboard';

  static const String profil =
      'anggota/profil';

  static const String simpanan =
      'anggota/simpanan';

  static const String pinjaman =
      'anggota/pinjaman';

  static const String ajukanPinjaman =
      'anggota/pinjaman/ajukan';

  static const String angsuran =
      'anggota/angsuran';

  static const String transaksi =
      'anggota/transaksi';

  static const String notifikasi =
      'anggota/notifikasi';

  static const String trackingStatus =
      'anggota/tracking-status';

  static String bayarAngsuranDemo(
    dynamic id,
  ) {
    return 'anggota/angsuran/$id/bayar-demo';
  }

  static String trackingPengajuanPinjaman(
    dynamic id,
  ) {
    return 'anggota/pinjaman/'
        '$id/tracking-pengajuan';
  }

  static String trackingAngsuranPinjaman(
    dynamic id,
  ) {
    return 'anggota/pinjaman/'
        '$id/tracking-angsuran';
  }

  static String trackingPinjaman(
    dynamic id,
  ) {
    return trackingPengajuanPinjaman(id);
  }

  static String bacaNotifikasi(
    dynamic id,
  ) {
    return 'anggota/notifikasi/$id/baca';
  }

  static const String bacaSemuaNotifikasi =
      'anggota/notifikasi/baca-semua';

  // =========================================================
  // ADMIN
  // =========================================================

  static const String adminLogin =
      'admin/login';

  static const String adminLogout =
      'admin/logout';

  static const String adminDashboard =
      'admin/dashboard';

  static const String adminAnggota =
      'admin/anggota';

  static const String adminSimpanan =
      'admin/simpanan';

  static const String adminPinjaman =
      'admin/pinjaman';

  static String adminAnggotaDetail(
    dynamic id,
  ) {
    return 'admin/anggota/$id';
  }


  static String adminUpdateStatusPinjaman(
    dynamic id,
  ) {
    return 'admin/pinjaman/$id/status';
  }

  /*
   * Endpoint GET untuk membaca hasil ML
   * berdasarkan loan_application_id.
   */
  static String adminRiskPinjaman(
    dynamic id,
  ) {
    return 'admin/pinjaman/$id/risk';
  }

  // =========================================================
  // ANGSURAN ADMIN
  // =========================================================

  static const String adminAngsuran =
      'admin/angsuran';

  static String adminBayarAngsuran(
    dynamic id,
  ) {
    return 'admin/angsuran/$id/bayar';
  }

  // =========================================================
  // LAPORAN
  // =========================================================

  static const String adminLaporanKeuangan =
      'admin/laporan-keuangan';

  static const String adminLaporanKeuanganPdf =
      'admin/laporan-keuangan/pdf';

  static const String adminLaporanKeuanganExcel =
      'admin/laporan-keuangan/excel';

  // =========================================================
  // PENGATURAN
  // =========================================================

  static const String adminPengaturan =
      'admin/pengaturan-koperasi';

  // =========================================================
  // PROFIL ADMIN
  // =========================================================

  static const String adminProfile =
      'admin/profile';

  static const String adminChangePassword =
      'admin/change-password';

  static const String adminProfilePhoto =
      'admin/profile-photo';

  // =========================================================
  // MACHINE LEARNING
  // =========================================================

  static const String mlHealth =
      'ml/health';

}
