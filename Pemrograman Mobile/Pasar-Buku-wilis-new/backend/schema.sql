-- Opsional: server.js sudah membuat database + tabel + data contoh otomatis
-- saat pertama kali dijalankan. File ini hanya referensi / untuk impor manual.
CREATE DATABASE IF NOT EXISTS pasar_buku_wilis CHARACTER SET utf8mb4;
USE pasar_buku_wilis;

CREATE TABLE IF NOT EXISTS buku (
  id        INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tanggal   DATE         NOT NULL,           -- tanggal buku datang ke lapak
  judul     VARCHAR(150) NOT NULL,
  kategori  VARCHAR(30)  NOT NULL,           -- Novel, Komik, Pelajaran, dst.
  penulis   VARCHAR(100) NOT NULL,
  jumlah    INT UNSIGNED NOT NULL,           -- eksemplar
  pemasok   VARCHAR(100) NOT NULL DEFAULT '', -- pengepul / kolektor / penerbit
  harga     INT UNSIGNED NOT NULL DEFAULT 0  -- harga kulak per eksemplar (Rp)
) CHARACTER SET utf8mb4;
