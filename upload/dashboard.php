<?php
declare(strict_types=1);
require 'koneksi.php';
require_login();

$cari = trim((string) ($_GET['cari'] ?? ''));
$sql = 'SELECT * FROM anggota';
$parameters = [];

if ($cari !== '') {
    $sql .= ' WHERE nama LIKE ? OR nomor_anggota LIKE ? OR email LIKE ?';
    $keyword = "%{$cari}%";
    $parameters = [$keyword, $keyword, $keyword];
}

$sql .= ' ORDER BY id DESC';
$query = $pdo->prepare($sql);
$query->execute($parameters);
$anggota = $query->fetchAll();
?>
<!doctype html>
<html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Dashboard Admin | Koperasi Kita</title><link rel="stylesheet" href="style.css"></head>
<body>
<header class="topbar"><div><strong>Koperasi Kita</strong><span>Panel Admin</span></div><div>Halo, <?= e($_SESSION['admin']['nama']) ?> &middot; <a href="logout.php">Keluar</a></div></header>
<main class="container">
    <div class="page-title"><div><h1>Data Anggota</h1><p>Kelola seluruh informasi anggota koperasi.</p></div><a class="button" href="anggota_form.php">+ Tambah anggota</a></div>
    <?php if ($message = flash('success')): ?><div class="alert success"><?= e($message) ?></div><?php endif; ?>
    <?php if ($message = flash('error')): ?><div class="alert error"><?= e($message) ?></div><?php endif; ?>
    <form class="search" method="get"><input name="cari" placeholder="Cari nama, nomor, atau email..." value="<?= e($cari) ?>"><button type="submit">Cari</button><?php if ($cari !== ''): ?><a class="reset" href="dashboard.php">Reset</a><?php endif; ?></form>
    <div class="table-wrap"><table><thead><tr><th>No.</th><th>Anggota</th><th>Kontak</th><th>Alamat</th><th>Status</th><th>Aksi</th></tr></thead><tbody>
    <?php foreach ($anggota as $nomor => $item): ?><tr><td><?= $nomor + 1 ?></td><td><strong><?= e($item['nama']) ?></strong><br><small><?= e($item['nomor_anggota']) ?></small></td><td><?= e($item['email']) ?><br><small><?= e($item['no_hp'] ?: '-') ?></small></td><td><?= e($item['alamat'] ?: '-') ?></td><td><span class="badge <?= $item['status'] === 'aktif' ? 'active' : '' ?>"><?= e(ucfirst($item['status'])) ?></span></td><td class="actions"><a href="anggota_form.php?id=<?= (int) $item['id'] ?>">Ubah</a><form method="post" action="hapus_anggota.php" onsubmit="return confirm('Hapus data anggota ini?');"><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><input type="hidden" name="id" value="<?= (int) $item['id'] ?>"><button class="delete" type="submit">Hapus</button></form></td></tr><?php endforeach; ?>
    <?php if ($anggota === []): ?><tr><td colspan="6" class="empty">Data anggota belum tersedia.</td></tr><?php endif; ?>
    </tbody></table></div>
</main>
</body></html>
