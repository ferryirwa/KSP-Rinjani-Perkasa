<?php
require 'koneksi.php';
header('Location: ' . (empty($_SESSION['admin']) ? 'login.php' : 'dashboard.php'));
exit;
