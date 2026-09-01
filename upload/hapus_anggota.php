<?php
declare(strict_types=1);
require 'koneksi.php';
require_login();

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !verify_csrf()) {
    flash('error', 'Permintaan penghapusan tidak valid.');
    header('Location: dashboard.php');
    exit;
}

$id = (int) ($_POST['id'] ?? 0);
$query = $pdo->prepare('DELETE FROM anggota WHERE id = ?');
$query->execute([$id]);
flash($query->rowCount() ? 'success' : 'error', $query->rowCount() ? 'Data anggota berhasil dihapus.' : 'Data anggota tidak ditemukan.');
header('Location: dashboard.php');
exit;
