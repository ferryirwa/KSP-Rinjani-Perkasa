<?php
declare(strict_types=1);

/** Ubah nilainya sesuai konfigurasi MySQL/phpMyAdmin yang digunakan. */
const DB_HOST = 'localhost';
const DB_PORT = '3306';
const DB_NAME = 'koperasi_sederhana';
const DB_USER = 'root';
const DB_PASS = '';

try {
    $pdo = new PDO(
        sprintf('mysql:host=%s;port=%s;dbname=%s;charset=utf8mb4', DB_HOST, DB_PORT, DB_NAME),
        DB_USER,
        DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );
} catch (PDOException $exception) {
    exit('Koneksi database gagal. Pastikan database sudah diimpor dan konfigurasi di koneksi.php sudah benar.');
}

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

function e(?string $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

function flash(string $key, ?string $message = null): ?string
{
    if ($message !== null) {
        $_SESSION['flash'][$key] = $message;
        return null;
    }

    $message = $_SESSION['flash'][$key] ?? null;
    unset($_SESSION['flash'][$key]);
    return $message;
}

function csrf_token(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }

    return $_SESSION['csrf_token'];
}

function verify_csrf(): bool
{
    return isset($_POST['csrf_token'])
        && hash_equals($_SESSION['csrf_token'] ?? '', (string) $_POST['csrf_token']);
}

function require_login(): void
{
    if (!isset($_SESSION['admin'])) {
        flash('error', 'Silakan masuk terlebih dahulu.');
        header('Location: login.php');
        exit;
    }
}
