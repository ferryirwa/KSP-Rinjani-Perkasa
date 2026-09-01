import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/admin_anggota_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_card.dart';

class AdminAnggotaView extends StatefulWidget {
  const AdminAnggotaView({super.key});

  @override
  State<AdminAnggotaView> createState() => _AdminAnggotaViewState();
}

class _AdminAnggotaViewState extends State<AdminAnggotaView> {
  final AdminAnggotaController controller = Get.find<AdminAnggotaController>();
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'semua';
  String searchQuery = '';

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color green = AppColors.success;
  static const Color red = AppColors.danger;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    return status.toLowerCase() == 'aktif' ? green : red;
  }

  String _statusText(String status) {
    return status.toLowerCase() == 'aktif' ? 'Aktif' : 'Nonaktif';
  }

  List<Map<String, dynamic>> _filteredAnggota() {
    final allData = controller.anggotas.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    return allData.where((anggota) {
      final status = anggota['status']?.toString().toLowerCase() ?? '';
      final nama = anggota['nama']?.toString().toLowerCase() ?? '';
      final nomorAnggota =
          anggota['nomor_anggota']?.toString().toLowerCase() ?? '';
      final noHp = anggota['no_hp']?.toString().toLowerCase() ?? '';
      final email = anggota['email']?.toString().toLowerCase() ?? '';

      final keyword = searchQuery.toLowerCase();

      final cocokSearch = keyword.isEmpty ||
          nama.contains(keyword) ||
          nomorAnggota.contains(keyword) ||
          noHp.contains(keyword) ||
          email.contains(keyword);

      final cocokFilter =
          selectedFilter == 'semua' || status == selectedFilter;

      return cocokSearch && cocokFilter;
    }).toList();
  }

  Widget _topHeader() {
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
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KoperasiKu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String title, String value) {
    final bool active = selectedFilter == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? primary : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : dark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _searchAndFilterPanel(int totalData) {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Anggota',
            style: TextStyle(
              color: dark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari anggota (nama / ID / no. HP)',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primary, width: 1.2),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _filterButton('Semua', 'semua'),
              const SizedBox(width: 8),
              _filterButton('Aktif', 'aktif'),
              const SizedBox(width: 8),
              _filterButton('Nonaktif', 'nonaktif'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 15,
                      color: primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: controller.goToTambahAnggota,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text(
                'Tambah Anggota',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Daftar Anggota ($totalData)',
            style: const TextStyle(
              color: dark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        style: const TextStyle(
          color: dark,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
          prefixIcon: Icon(icon, color: primary, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditAnggotaDialog(Map<String, dynamic> anggota) async {
    final nomorAnggotaController = TextEditingController(
      text: anggota['nomor_anggota']?.toString() ?? '',
    );
    final namaController = TextEditingController(
      text: anggota['nama']?.toString() ?? '',
    );
    final emailController = TextEditingController(
      text: anggota['email']?.toString() ?? '',
    );
    final passwordController = TextEditingController();
    final noHpController = TextEditingController(
      text: anggota['no_hp']?.toString() ?? '',
    );
    final alamatController = TextEditingController(
      text: anggota['alamat']?.toString() ?? '',
    );
    String status = anggota['status']?.toString() == 'nonaktif'
        ? 'nonaktif'
        : 'aktif';

    await Get.dialog<void>(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.edit_rounded, color: primary),
            SizedBox(width: 8),
            Text(
              'Edit Anggota',
              style: TextStyle(
                color: dark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField(
                      controller: nomorAnggotaController,
                      label: 'Nomor Anggota',
                      icon: Icons.confirmation_number_rounded,
                    ),
                    _dialogField(
                      controller: namaController,
                      label: 'Nama Lengkap',
                      icon: Icons.person_rounded,
                    ),
                    _dialogField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _dialogField(
                      controller: passwordController,
                      label: 'Password Baru (opsional)',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                    ),
                    _dialogField(
                      controller: noHpController,
                      label: 'No HP',
                      icon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    _dialogField(
                      controller: alamatController,
                      label: 'Alamat',
                      icon: Icons.location_on_rounded,
                      maxLines: 2,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      decoration: InputDecoration(
                        labelText: 'Status Akun',
                        labelStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                        prefixIcon: Icon(
                          status == 'aktif'
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: status == 'aktif' ? green : red,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: primary, width: 1.2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'aktif',
                          child: Text('Aktif'),
                        ),
                        DropdownMenuItem(
                          value: 'nonaktif',
                          child: Text('Nonaktif'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            status = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () async {
                      final saved = await controller.updateAnggota(
                        id: anggota['id'],
                        nomorAnggota: nomorAnggotaController.text.trim(),
                        nama: namaController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        noHp: noHpController.text.trim(),
                        alamat: alamatController.text.trim(),
                        status: status,
                      );

                      if (saved) {
                        Get.back();
                      }
                    },
              icon: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(
                controller.isSubmitting.value ? 'Menyimpan...' : 'Simpan',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: primary.withValues(alpha: 0.55),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    nomorAnggotaController.dispose();
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    noHpController.dispose();
    alamatController.dispose();
  }

  Future<void> _showHapusAnggotaDialog(Map<String, dynamic> anggota) async {
    final nama = anggota['nama']?.toString() ?? 'anggota ini';

    await Get.dialog<void>(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: red),
            SizedBox(width: 8),
            Text(
              'Hapus Anggota',
              style: TextStyle(
                color: dark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: Text(
          'Yakin ingin menghapus $nama? Data yang berelasi juga akan ikut terhapus dari database.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.35,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () async {
                      final deleted = await controller.hapusAnggota(
                        anggota['id'],
                      );

                      if (deleted) {
                        Get.back();
                      }
                    },
              icon: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.delete_rounded, size: 18),
              label: Text(
                controller.isSubmitting.value ? 'Menghapus...' : 'Hapus',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                disabledBackgroundColor: red.withValues(alpha: 0.55),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
    );
  }

  Widget _anggotaItem(Map<String, dynamic> anggota) {
    final status = anggota['status']?.toString() ?? '-';
    final nama = anggota['nama']?.toString() ?? '-';
    final nomorAnggota = anggota['nomor_anggota']?.toString() ?? '-';
    final noHp = anggota['no_hp']?.toString() ?? '-';

    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(18),
      color: cardColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: primary.withValues(alpha: 0.12),
            child: Text(
              nama.isNotEmpty ? nama[0].toUpperCase() : 'A',
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
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
                  'ID: $nomorAnggota',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  noHp,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionButton(
                    icon: Icons.edit_rounded,
                    color: primary,
                    onTap: () => _showEditAnggotaDialog(anggota),
                  ),
                  const SizedBox(width: 6),
                  _actionButton(
                    icon: Icons.delete_rounded,
                    color: red,
                    onTap: () => _showHapusAnggotaDialog(anggota),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return PremiumCard(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      padding: const EdgeInsets.all(28),
      borderRadius: BorderRadius.circular(22),
      color: cardColor,
      child: const Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            'Data anggota tidak ditemukan.',
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
          Get.offNamed(AppRoutes.adminDashboard);
        } else if (index == 1) {
          controller.fetchAnggota();
        } else if (index == 2) {
          Get.offNamed(AppRoutes.adminSimpanan);
        } else if (index == 3) {
          Get.offNamed(AppRoutes.adminPinjaman);
        } else if (index == 4) {
          Get.offNamed(AppRoutes.adminLaporanKeuangan);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Anggota',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.savings_rounded),
          label: 'Simpanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wallet_rounded),
          label: 'Pinjaman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Laporan',
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
        child: Column(
          children: [
            _topHeader(),
            Expanded(
              child: Obx(() {
                final filteredData = _filteredAnggota();

                return RefreshIndicator(
                  color: primary,
                  onRefresh: controller.fetchAnggota,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 14, bottom: 18),
                    children: [
                      _searchAndFilterPanel(filteredData.length),

                      if (controller.isLoading.value &&
                          controller.anggotas.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 90),
                          child: Center(
                            child: CircularProgressIndicator(color: primary),
                          ),
                        )
                      else if (filteredData.isEmpty)
                        _emptyState()
                      else
                        ...filteredData.map(_anggotaItem),

                      if (controller.isLoading.value &&
                          controller.anggotas.isNotEmpty)
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
          ],
        ),
      ),
    );
  }
}
