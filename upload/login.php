<?php
declare(strict_types=1);
require 'koneksi.php';

if (isset($_SESSION['admin'])) {
    header('Location: dashboard.php');
    exit;
}

$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf()) {
        $error = 'Permintaan tidak valid. Silakan coba lagi.';
    } else {
        $email = trim((string) ($_POST['email'] ?? ''));
        $password = (string) ($_POST['password'] ?? '');
        $query = $pdo->prepare('SELECT id, nama, email, password FROM admins WHERE email = ? LIMIT 1');
        $query->execute([$email]);
        $admin = $query->fetch();

        if ($admin && password_verify($password, $admin['password'])) {
            session_regenerate_id(true);
            $_SESSION['admin'] = ['id' => $admin['id'], 'nama' => $admin['nama'], 'email' => $admin['email']];
            header('Location: dashboard.php');
            exit;
        }

        $error = 'Email atau kata sandi tidak sesuai.';
    }
}
?>
<!doctype html>
<html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Masuk Admin | Koperasi Kita</title><link rel="stylesheet" href="style.css"></head>
<body class="auth-page"><main class="auth-card"><div class="brand">Koperasi Kita</div><h1>Masuk sebagai admin</h1><p>Kelola data anggota dengan mudah dan aman.</p>
<?php if ($message = flash('success')): ?><div class="alert success"><?= e($message) ?></div><?php endif; ?>
<?php if (!empty($error)): ?><div class="alert error"><?= e($error) ?></div><?php endif; ?>
<?php if ($message = flash('error')): ?><div class="alert error"><?= e($message) ?></div><?php endif; ?>
<form method="post"><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><label for="email">Email</label><input id="email" type="email" name="email" value="<?= e($email) ?>" required autofocus><label for="password">Kata sandi</label><input id="password" type="password" name="password" required><button type="submit">Masuk</button></form><p class="auth-footer">Belum punya akun? <a href="registerasi.php">Daftar admin</a></p></main></body></html>
