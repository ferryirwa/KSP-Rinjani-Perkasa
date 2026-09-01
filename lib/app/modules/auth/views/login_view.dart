import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  static const Color primary = AppColors.primary;
  static const Color dark = AppColors.textPrimary;
  static const Color softBrown = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color gold = AppColors.accent;
  static const Color green = AppColors.success;

  Widget _topHeader(bool isAdmin) {
    return Container(
      width: double.infinity,
      height: 285,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -28,
            left: -48,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 34,
            right: -36,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -25,
            right: -25,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: 105,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.language_rounded, size: 18, color: dark),
                  SizedBox(width: 6),
                  Text(
                    'ID',
                    style: TextStyle(
                      color: dark,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryDark,
                        AppColors.primaryDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.30),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(
                    isAdmin
                        ? Icons.admin_panel_settings_rounded
                        : Icons.account_balance_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Selamat Datang di',
                  style: TextStyle(
                    color: primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'KSP Rinjani Perkasa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dark,
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleSelector() {
    return Obx(() {
      final selectedRole = controller.selectedRole.value;

      return Row(
        children: [
          Expanded(
            child: _roleButton(
              role: LoginRole.anggota,
              selectedRole: selectedRole,
              title: 'Anggota',
              subtitle: 'Akun koperasi',
              icon: Icons.person_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _roleButton(
              role: LoginRole.admin,
              selectedRole: selectedRole,
              title: 'Admin',
              subtitle: 'Pengelola',
              icon: Icons.admin_panel_settings_rounded,
            ),
          ),
        ],
      );
    });
  }

  Widget _roleButton({
    required LoginRole role,
    required LoginRole selectedRole,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = selectedRole == role;

    return InkWell(
      borderRadius: BorderRadius.circular(17),
      onTap: controller.isLoading.value
          ? null
          : () {
              controller.selectRole(role);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected ? gold : AppColors.border,
            width: selected ? 1.7 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? primary.withValues(alpha: 0.20)
                  : Colors.black.withValues(alpha: 0.035),
              blurRadius: selected ? 14 : 9,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.16) : softBrown,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.white : dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: primary, size: 21),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
    );
  }

  Widget _loginCard(bool isAdmin) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Login sebagai',
            style: TextStyle(
              color: dark,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _roleSelector(),
          const SizedBox(height: 18),
          TextField(
            controller: controller.loginController,
            keyboardType:
                isAdmin ? TextInputType.emailAddress : TextInputType.text,
            decoration: _inputDecoration(
              label: isAdmin ? 'Email Admin' : 'Nomor Anggota / Email',
              icon: isAdmin ? Icons.email_rounded : Icons.person_rounded,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.passwordController,
            obscureText: true,
            decoration: _inputDecoration(
              label: 'Password',
              icon: Icons.lock_rounded,
              suffixIcon: const Icon(
                Icons.visibility_off_rounded,
                color: AppColors.textMuted,
                size: 21,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              isAdmin
                  ? 'Gunakan akun admin terdaftar'
                  : 'Hubungi admin jika lupa password',
              style: const TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            return SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed:
                    controller.isLoading.value ? null : controller.login,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.3,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(
                  controller.isLoading.value
                      ? 'Memproses...'
                      : isAdmin
                          ? 'Login Admin'
                          : 'Login Anggota',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: primary.withValues(alpha: 0.55),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: green,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              const Text(
                'Data Anda aman dan terlindungi',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: softBrown,
    resizeToAvoidBottomInset: false,
    body: SafeArea(
      child: Obx(() {
        final isAdmin = controller.selectedRole.value == LoginRole.admin;

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              _topHeader(isAdmin),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Column(
                    children: [
                      _loginCard(isAdmin),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                        
                        ),
                      ),
                    ],
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

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, 42);

    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.50,
      35,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      70,
      size.width,
      28,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}