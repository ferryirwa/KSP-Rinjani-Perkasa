<?php
declare(strict_types=1);
require 'koneksi.php';

if (isset($_SESSION['admin'])) {
    header('Location: dashboard.php');
    exit;
}

$nama = '';
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nama = trim((string) ($_POST['nama'] ?? ''));
    $email = trim((string) ($_POST['email'] ?? ''));
    $password = (string) ($_POST['password'] ?? '');
    $konfirmasi = (string) ($_POST['konfirmasi_password'] ?? '');

    if (!verify_csrf()) {
        $error = 'Permintaan tidak valid. Silakan coba lagi.';
    } elseif (mb_strlen($nama) < 3) {
        $error = 'Nama minimal terdiri dari 3 karakter.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Masukkan alamat email yang valid.';
    } elseif (strlen($password) < 6) {
        $error = 'Kata sandi minimal terdiri dari 6 karakter.';
    } elseif ($password !== $konfirmasi) {
        $error = 'Konfirmasi kata sandi tidak sama.';
    } else {
        try {
            $query = $pdo->prepare('INSERT INTO admins (nama, email, password) VALUES (?, ?, ?)');
            $query->execute([$nama, $email, password_hash($password, PASSWORD_DEFAULT)]);
            flash('success', 'Akun admin berhasil dibuat. Silakan masuk.');
            header('Location: login.php');
            exit;
        } catch (PDOException $exception) {
            $error = 'Email tersebut sudah terdaftar.';
        }
    }
}
?>
<!doctype html>
<html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Daftar Admin | Koperasi Kita</title><link rel="stylesheet" href="style.css"></head>
<body class="auth-page"><main class="auth-card"><div class="brand">Koperasi Kita</div><h1>Buat akun admin</h1><p>Daftarkan akun untuk mulai mengelola anggota.</p>
<?php if (!empty($error)): ?><div class="alert error"><?= e($error) ?></div><?php endif; ?>
<form method="post"><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><label for="nama">Nama lengkap</label><input id="nama" name="nama" value="<?= e($nama) ?>" required><label for="email">Email</label><input id="email" type="email" name="email" value="<?= e($email) ?>" required><label for="password">Kata sandi</label><input id="password" type="password" name="password" minlength="6" required><label for="konfirmasi_password">Konfirmasi kata sandi</label><input id="konfirmasi_password" type="password" name="konfirmasi_password" minlength="6" required><button type="submit">Daftar</button></form><p class="auth-footer">Sudah punya akun? <a href="login.php">Masuk di sini</a></p></main></body></html>
