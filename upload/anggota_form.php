<?php
declare(strict_types=1);
require 'koneksi.php';
require_login();

$anggota = ['id' => '', 'nomor_anggota' => '', 'nama' => '', 'email' => '', 'no_hp' => '', 'alamat' => '', 'status' => 'aktif'];
$id = (int) ($_GET['id'] ?? 0);

if ($id > 0) {
    $query = $pdo->prepare('SELECT * FROM anggota WHERE id = ?');
    $query->execute([$id]);
    $anggota = $query->fetch() ?: $anggota;
    if ($anggota['id'] === '') { flash('error', 'Data anggota tidak ditemukan.'); header('Location: dashboard.php'); exit; }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $anggota = array_merge($anggota, $_POST);
    $id = (int) ($_POST['id'] ?? 0);
    $nomorAnggota = trim((string) ($_POST['nomor_anggota'] ?? ''));
    $nama = trim((string) ($_POST['nama'] ?? ''));
    $email = trim((string) ($_POST['email'] ?? ''));
    $noHp = trim((string) ($_POST['no_hp'] ?? ''));
    $alamat = trim((string) ($_POST['alamat'] ?? ''));
    $status = ($_POST['status'] ?? '') === 'nonaktif' ? 'nonaktif' : 'aktif';

    if (!verify_csrf()) $error = 'Permintaan tidak valid. Silakan coba lagi.';
    elseif ($nomorAnggota === '' || $nama === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) $error = 'Nomor anggota, nama, dan email wajib diisi dengan benar.';
    else try {
        if ($id > 0) {
            $query = $pdo->prepare('UPDATE anggota SET nomor_anggota=?, nama=?, email=?, no_hp=?, alamat=?, status=? WHERE id=?');
            $query->execute([$nomorAnggota, $nama, $email, $noHp, $alamat, $status, $id]);
            flash('success', 'Data anggota berhasil diperbarui.');
        } else {
            $query = $pdo->prepare('INSERT INTO anggota (nomor_anggota, nama, email, no_hp, alamat, status) VALUES (?, ?, ?, ?, ?, ?)');
            $query->execute([$nomorAnggota, $nama, $email, $noHp, $alamat, $status]);
            flash('success', 'Anggota baru berhasil ditambahkan.');
        }
        header('Location: dashboard.php'); exit;
    } catch (PDOException $exception) { $error = 'Nomor anggota atau email sudah digunakan.'; }
}
?>
<!doctype html>
<html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title><?= $anggota['id'] ? 'Ubah' : 'Tambah' ?> Anggota | Koperasi Kita</title><link rel="stylesheet" href="style.css"></head>
<body><header class="topbar"><div><strong>Koperasi Kita</strong><span>Panel Admin</span></div><a href="dashboard.php">&larr; Kembali</a></header>
<main class="container"><section class="form-card"><h1><?= $anggota['id'] ? 'Ubah data anggota' : 'Tambah anggota baru' ?></h1><p>Lengkapi informasi anggota dengan benar.</p>
<?php if (!empty($error)): ?><div class="alert error"><?= e($error) ?></div><?php endif; ?>
<form method="post" class="grid-form"><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><input type="hidden" name="id" value="<?= (int) $anggota['id'] ?>"><label>Nomor anggota<input name="nomor_anggota" required value="<?= e($anggota['nomor_anggota']) ?>" placeholder="AGT-001"></label><label>Nama lengkap<input name="nama" required value="<?= e($anggota['nama']) ?>"></label><label>Email<input type="email" name="email" required value="<?= e($anggota['email']) ?>"></label><label>No. HP<input name="no_hp" value="<?= e($anggota['no_hp']) ?>"></label><label class="full">Alamat<textarea name="alamat" rows="3"><?= e($anggota['alamat']) ?></textarea></label><label>Status<select name="status"><option value="aktif" <?= $anggota['status'] === 'aktif' ? 'selected' : '' ?>>Aktif</option><option value="nonaktif" <?= $anggota['status'] === 'nonaktif' ? 'selected' : '' ?>>Nonaktif</option></select></label><div class="full"><button type="submit">Simpan data</button><a class="cancel" href="dashboard.php">Batal</a></div></form>
</section></main></body></html>
