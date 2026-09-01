import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

import '../constants/app_colors.dart';

/// A GetX facade that keeps every in-app notification consistent.
///
/// Controllers import this object as `Get`, so existing navigation and state
/// helpers still work through GetX extensions while `snackbar` uses this
/// application's visual treatment.
// ignore: non_constant_identifier_names
final Get = _AppGet();

class _AppGet extends getx.GetInterface {
  getx.SnackbarController snackbar(
    String title,
    String message, {
    Duration? duration,
    getx.SnackPosition? snackPosition,
  }) {
    final notification = _NotificationStyle.from(title);

    if (getx.Get.isSnackbarOpen) {
      getx.Get.closeCurrentSnackbar();
    }

    return getx.Get.rawSnackbar(
      snackPosition: getx.SnackPosition.TOP,
      snackStyle: getx.SnackStyle.FLOATING,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
      borderRadius: 16,
      backgroundColor: Colors.white,
      borderColor: notification.color.withValues(alpha: 0.22),
      borderWidth: 1,
      leftBarIndicatorColor: notification.color,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 18,
          offset: const Offset(0, 7),
        ),
      ],
      icon: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: notification.color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(notification.icon, color: notification.color, size: 21),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12.5,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration ?? const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      animationDuration: const Duration(milliseconds: 350),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      barBlur: 0,
      overlayColor: Colors.transparent,
    );
  }
}

class _NotificationStyle {
  const _NotificationStyle(this.color, this.icon);

  final Color color;
  final IconData icon;

  factory _NotificationStyle.from(String title) {
    final normalized = title.toLowerCase();

    if (normalized.contains('berhasil') || normalized.contains('sukses')) {
      return const _NotificationStyle(
        AppColors.success,
        Icons.check_circle_rounded,
      );
    }

    if (normalized.contains('lengkap') ||
        normalized.contains('perhatian') ||
        normalized.contains('valid')) {
      return const _NotificationStyle(
        AppColors.warning,
        Icons.info_rounded,
      );
    }

    if (normalized.contains('gagal') || normalized.contains('error')) {
      return const _NotificationStyle(
        AppColors.danger,
        Icons.error_rounded,
      );
    }

    return const _NotificationStyle(AppColors.info, Icons.info_rounded);
  }
}
