<?php
declare(strict_types=1);
require 'koneksi.php';

$_SESSION = [];
session_destroy();
session_start();
flash('success', 'Anda telah keluar dari akun.');
header('Location: login.php');
exit;
