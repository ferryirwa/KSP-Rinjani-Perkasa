import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../modules/notifikasi/controllers/notifikasi_controller.dart';
import '../../modules/tracking_pengajuan/controllers/tracking_pengajuan_controller.dart';
import '../../routes/app_routes.dart';
import '../../../firebase_options.dart';
import '../repositories/auth_repository.dart';
import 'storage_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handler ini wajib berada di level atas agar tetap dapat dipanggil saat
  // aplikasi berada di background atau sudah ditutup.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

/// Menangani token perangkat dan pesan FCM tanpa mengubah tampilan aplikasi.
class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final AuthRepository _authRepository = AuthRepository();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  bool _isReady = false;

  Future<void> initialize() async {
    if (_isReady) return;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      _isReady = true;
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      _foregroundSubscription ??=
          FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      _openedSubscription ??=
          FirebaseMessaging.onMessageOpenedApp.listen(_openTrackingFromMessage);
      _tokenRefreshSubscription ??=
          _messaging.onTokenRefresh.listen(_syncRefreshedToken);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _openTrackingFromMessage(initialMessage),
        );
      }
    } catch (error) {
      // Firebase bersifat fitur tambahan; kegagalan konfigurasi tidak boleh
      // menghalangi pengguna untuk masuk dan memakai aplikasi.
      if (kDebugMode) {
        debugPrint('[FCM] Belum siap: $error');
      }
    }
  }

  Future<String?> getToken() async {
    if (!_isReady) return null;

    try {
      return await _messaging.getToken();
    } catch (error) {
      if (kDebugMode) debugPrint('[FCM] Gagal mengambil token: $error');
      return null;
    }
  }

  /// Dipanggil setelah login berhasil agar backend mengenali perangkat ini.
  Future<void> syncTokenAfterLogin() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return;

    try {
      await _authRepository.updateFirebaseToken(token);
    } catch (error) {
      if (kDebugMode) debugPrint('[FCM] Gagal menyimpan token: $error');
    }
  }

  Future<void> _syncRefreshedToken(String token) async {
    final authToken = await StorageService.getToken();
    if (authToken == null || authToken.isEmpty) return;

    try {
      await _authRepository.updateFirebaseToken(token);
    } catch (error) {
      if (kDebugMode) debugPrint('[FCM] Gagal memperbarui token: $error');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _refreshTracking(message);

    if (Get.isRegistered<NotifikasiController>()) {
      Get.find<NotifikasiController>().fetchNotifikasi(showError: false);
    }

    final title = message.notification?.title ?? 'Notifikasi koperasi';
    final body = message.notification?.body ?? 'Ada pembaruan data terbaru.';
    Get.snackbar(title, body, snackPosition: SnackPosition.TOP);
  }

  void _refreshTracking(RemoteMessage message) {
    final loanId = message.data['loan_id']?.toString();
    if (loanId == null || !Get.isRegistered<TrackingPengajuanController>()) {
      return;
    }

    final controller = Get.find<TrackingPengajuanController>();
    if (controller.pinjamanId?.toString() == loanId) {
      controller.fetchTrackingPengajuan();
    }
  }

  void _openTrackingFromMessage(RemoteMessage message) {
    final loanId = message.data['loan_id']?.toString();
    if (loanId == null || loanId.isEmpty) {
      Get.toNamed(AppRoutes.notifikasi);
      return;
    }

    Get.toNamed(
      AppRoutes.trackingPengajuan,
      arguments: {'pinjaman_id': loanId},
    );
  }
}
