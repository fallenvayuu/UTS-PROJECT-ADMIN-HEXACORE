import mysql from 'mysql2/promise'

const cfg = {
  host: process.env.DB_HOST || '127.0.0.1',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
}
const DB_NAME = process.env.DB_NAME || 'pasar_buku_wilis'

// Data contoh, hanya dimasukkan saat tabel baru pertama kali dibuat.
// Urutan kolom: tanggal, judul, kategori, penulis, jumlah (eksemplar), pemasok, harga kulak per eksemplar.
const seed = [
  ['2026-10-06', 'Bumi Manusia', 'Novel', 'Pramoedya Ananta Toer', 12, 'Pak Harjo', 35000],
  ['2026-10-07', 'Laskar Pelangi', 'Novel', 'Andrea Hirata', 15, 'Pak Harjo', 28000],
  ['2026-10-08', 'Kalkulus Jilid 1', 'Kuliah', 'Edwin J. Purcell', 3, 'Bu Lestari', 85000],
  ['2026-10-09', 'Detektif Conan Vol. 40', 'Komik', 'Gosho Aoyama', 24, 'Bu Lestari', 6000],
  ['2026-10-10', 'Majalah Bobo (bundel lawas)', 'Majalah', 'Redaksi Bobo', 2, 'CV Aksara Lama', 45000],
  ['2026-10-11', 'Max Havelaar (cetakan lawas)', 'Langka', 'Multatuli', 2, 'CV Aksara Lama', 120000],
  ['2026-10-12', 'Kimia SMA Kelas XI', 'Pelajaran', 'Tim Penyusun', 8, 'Bu Lestari', 22000],
  ['2026-10-13', 'Tafsir Al-Azhar Jilid 1', 'Agama', 'Hamka', 6, 'Pak Harjo', 90000],
]

export let pool

export async function initDb() {
  // 1) pastikan database ada
  const conn = await mysql.createConnection(cfg)
  await conn.query(`CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4`)
  await conn.end()

  // 2) pool koneksi; dateStrings supaya kolom DATE keluar sebagai 'YYYY-MM-DD'
  pool = mysql.createPool({
    ...cfg,
    database: DB_NAME,
    dateStrings: true,
    waitForConnections: true,
    connectionLimit: 10,
  })

  // 3) buat tabel; isi data contoh hanya jika tabelnya baru
  const [ada] = await pool.query("SHOW TABLES LIKE 'buku'")
  await pool.query(`
    CREATE TABLE IF NOT EXISTS buku (
      id        INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
      tanggal   DATE         NOT NULL,
      judul     VARCHAR(150) NOT NULL,
      kategori  VARCHAR(30)  NOT NULL,
      penulis   VARCHAR(100) NOT NULL,
      jumlah    INT UNSIGNED NOT NULL,
      pemasok   VARCHAR(100) NOT NULL DEFAULT '',
      harga     INT UNSIGNED NOT NULL DEFAULT 0
    ) CHARACTER SET utf8mb4
  `)
  if (ada.length === 0) {
    await pool.query('INSERT INTO buku (tanggal, judul, kategori, penulis, jumlah, pemasok, harga) VALUES ?', [seed])
    console.log(`Tabel buku dibuat dan diisi ${seed.length} data contoh.`)
  }
}
