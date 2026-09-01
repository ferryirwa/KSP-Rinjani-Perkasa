import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/simpanan/bindings/simpanan_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/simpanan/views/simpanan_view.dart';
import '../modules/pinjaman/views/pinjaman_view.dart';
import '../modules/pinjaman/views/ajukan_pinjaman_view.dart';
import '../modules/angsuran/views/angsuran_view.dart';
import '../modules/tracking/views/tracking_view.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/pinjaman/bindings/pinjaman_binding.dart';
import '../modules/pinjaman/bindings/ajukan_pinjaman_binding.dart';
import '../modules/angsuran/bindings/angsuran_binding.dart';
import '../modules/tracking/bindings/tracking_binding.dart';
import '../modules/tracking_pengajuan/bindings/tracking_pengajuan_binding.dart';
import '../modules/tracking_pengajuan/views/tracking_pengajuan_view.dart';

import '../modules/tracking_angsuran/bindings/tracking_angsuran_binding.dart';
import '../modules/tracking_angsuran/views/tracking_angsuran_view.dart';
import '../modules/transaksi/bindings/transaksi_binding.dart';
import '../modules/transaksi/views/transaksi_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/profil/bindings/profil_binding.dart';

import '../modules/admin_auth/bindings/admin_auth_binding.dart';
import '../modules/admin_auth/views/admin_login_view.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admin_anggota/bindings/admin_anggota_binding.dart';
import '../modules/admin_anggota/views/admin_anggota_view.dart';
import '../modules/admin_tambah_anggota/bindings/admin_tambah_anggota_binding.dart';
import '../modules/admin_tambah_anggota/views/admin_tambah_anggota_view.dart';
import '../modules/admin_simpanan/bindings/admin_simpanan_binding.dart';
import '../modules/admin_simpanan/views/admin_simpanan_view.dart';
import '../modules/admin_tambah_simpanan/bindings/admin_tambah_simpanan_binding.dart';
import '../modules/admin_tambah_simpanan/views/admin_tambah_simpanan_view.dart';
import '../modules/admin_pinjaman/bindings/admin_pinjaman_binding.dart';
import '../modules/admin_pinjaman/views/admin_pinjaman_view.dart';
import '../modules/admin_angsuran/bindings/admin_angsuran_binding.dart';
import '../modules/admin_angsuran/views/admin_angsuran_view.dart';
import '../modules/admin_laporan_keuangan/bindings/admin_laporan_keuangan_binding.dart';
import '../modules/admin_laporan_keuangan/views/admin_laporan_keuangan_view.dart';
import '../modules/admin_pengaturan/bindings/admin_pengaturan_binding.dart';
import '../modules/admin_pengaturan/views/admin_pengaturan_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.simpanan,
      page: () => const SimpananView(),
      binding: SimpananBinding(),
    ),
    GetPage(
      name: AppRoutes.pinjaman,
      page: () => const PinjamanView(),
      binding: PinjamanBinding(),
    ),
    GetPage(
      name: AppRoutes.ajukanPinjaman,
      page: () => const AjukanPinjamanView(),
      binding: AjukanPinjamanBinding(),
    ),
    GetPage(
      name: AppRoutes.angsuran,
      page: () => const AngsuranView(),
      binding: AngsuranBinding(),
    ),
    GetPage(
  name: AppRoutes.transaksi,
  page: () => const TransaksiView(),
  binding: TransaksiBinding(),
),
   GetPage(
  name: AppRoutes.tracking,
  page: () => const TrackingView(),
  binding: TrackingBinding(),
),
GetPage(
  name: AppRoutes.trackingPengajuan,
  page: () => const TrackingPengajuanView(),
  binding: TrackingPengajuanBinding(),
),
GetPage(
  name: AppRoutes.trackingAngsuran,
  page: () => const TrackingAngsuranView(),
  binding: TrackingAngsuranBinding(),
),
   GetPage(
  name: AppRoutes.notifikasi,
  page: () => const NotifikasiView(),
  binding: NotifikasiBinding(),
),
GetPage(
  name: AppRoutes.profil,
  page: () => const ProfilView(),
  binding: ProfilBinding(),
),
GetPage(
  name: AppRoutes.adminLogin,
  page: () => const AdminLoginView(),
  binding: AdminAuthBinding(),
),
GetPage(
  name: AppRoutes.adminDashboard,
  page: () => const AdminDashboardView(),
  binding: AdminDashboardBinding(),
),
GetPage(
  name: AppRoutes.adminAnggota,
  page: () => const AdminAnggotaView(),
  binding: AdminAnggotaBinding(),
),
GetPage(
  name: AppRoutes.adminTambahAnggota,
  page: () => const AdminTambahAnggotaView(),
  binding: AdminTambahAnggotaBinding(),
),
GetPage(
  name: AppRoutes.adminSimpanan,
  page: () => const AdminSimpananView(),
  binding: AdminSimpananBinding(),
),
GetPage(
  name: AppRoutes.adminTambahSimpanan,
  page: () => const AdminTambahSimpananView(),
  binding: AdminTambahSimpananBinding(),
),
GetPage(
  name: AppRoutes.adminPinjaman,
  page: () => const AdminPinjamanView(),
  binding: AdminPinjamanBinding(),
),
GetPage(
  name: AppRoutes.adminAngsuran,
  page: () => const AdminAngsuranView(),
  binding: AdminAngsuranBinding(),
),  
GetPage(
  name: AppRoutes.adminLaporanKeuangan,
  page: () => const AdminLaporanKeuanganView(),
  binding: AdminLaporanKeuanganBinding(),
),
GetPage(
  name: AppRoutes.adminPengaturan,
  page: () => const AdminPengaturanView(),
  binding: AdminPengaturanBinding(),
),
];
}
