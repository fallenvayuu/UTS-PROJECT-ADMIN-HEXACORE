import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import { initDb, pool } from './db.js'

const PORT = Number(process.env.PORT || 3000)
const KATEGORI = ['Novel', 'Komik', 'Pelajaran', 'Kuliah', 'Agama', 'Anak', 'Majalah', 'Langka', 'Kamus', 'Lainnya']
const KOLOM = 'id, tanggal, judul, kategori, penulis, jumlah, pemasok, harga'

const app = express()
app.use(cors()) // web (Vite) dan mobile (Flutter Chrome) beda origin dengan API
app.use(express.json())

// Bungkus handler async supaya error masuk ke error handler di bawah.
const h = (fn) => (req, res, next) => fn(req, res, next).catch(next)

// ---------- Validasi (aturan sama dengan form web & mobile) ----------
function tanggalValid(s) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(s)) return false
  const d = new Date(s + 'T00:00:00Z')
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === s
}

function validasi(b = {}) {
  const errors = {}
  const tanggal = String(b.tanggal ?? '').trim()
  const judul = String(b.judul ?? '').trim()
  const penulis = String(b.penulis ?? '').trim()
  const pemasok = String(b.pemasok ?? '').trim()
  const kategori = b.kategori
  const kosong = (v) => v === undefined || v === null || String(v).trim() === ''
  const jumlah = Number(b.jumlah)
  const harga = Number(b.harga)

  if (!tanggalValid(tanggal)) errors.tanggal = 'Tanggal wajib diisi (format YYYY-MM-DD).'
  if (!judul) errors.judul = 'Judul buku wajib diisi.'
  else if (judul.length > 150) errors.judul = 'Judul buku maksimal 150 karakter.'
  if (!KATEGORI.includes(kategori)) errors.kategori = `Kategori harus salah satu dari: ${KATEGORI.join(', ')}.`
  if (!penulis) errors.penulis = 'Penulis wajib diisi.'
  else if (penulis.length > 100) errors.penulis = 'Penulis maksimal 100 karakter.'
  if (kosong(b.jumlah) || !Number.isInteger(jumlah) || jumlah <= 0) errors.jumlah = 'Jumlah harus bilangan bulat lebih dari 0.'
  if (pemasok.length > 100) errors.pemasok = 'Pemasok maksimal 100 karakter.'
  if (kosong(b.harga) || !Number.isInteger(harga) || harga < 0) errors.harga = 'Harga harus bilangan bulat, tidak boleh kosong atau negatif.'

  return { errors, value: { tanggal, judul, kategori, penulis, jumlah, pemasok, harga } }
}

function parseId(req, res) {
  const id = Number(req.params.id)
  if (!Number.isInteger(id) || id <= 0) {
    res.status(400).json({ message: 'ID tidak valid.' })
    return null
  }
  return id
}

const gagalValidasi = (res, errors) =>
  res.status(400).json({ message: Object.values(errors)[0], errors })

const ambil = async (id) => {
  const [rows] = await pool.query(`SELECT ${KOLOM} FROM buku WHERE id = ?`, [id])
  return rows[0]
}

// ---------- Routes ----------
app.get('/health', (req, res) => res.json({ status: 'ok' }))

app.get('/buku', h(async (req, res) => {
  const [rows] = await pool.query(`SELECT ${KOLOM} FROM buku ORDER BY tanggal DESC, id DESC`)
  res.json(rows)
}))

app.get('/buku/:id', h(async (req, res) => {
  const id = parseId(req, res); if (id === null) return
  const row = await ambil(id)
  if (!row) return res.status(404).json({ message: 'Data tidak ditemukan.' })
  res.json(row)
}))

app.post('/buku', h(async (req, res) => {
  const { errors, value: v } = validasi(req.body)
  if (Object.keys(errors).length) return gagalValidasi(res, errors)
  const [r] = await pool.query(
    'INSERT INTO buku (tanggal, judul, kategori, penulis, jumlah, pemasok, harga) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [v.tanggal, v.judul, v.kategori, v.penulis, v.jumlah, v.pemasok, v.harga],
  )
  res.status(201).json(await ambil(r.insertId))
}))

app.put('/buku/:id', h(async (req, res) => {
  const id = parseId(req, res); if (id === null) return
  const { errors, value: v } = validasi(req.body)
  if (Object.keys(errors).length) return gagalValidasi(res, errors)
  if (!(await ambil(id))) return res.status(404).json({ message: 'Data tidak ditemukan.' })
  await pool.query(
    'UPDATE buku SET tanggal = ?, judul = ?, kategori = ?, penulis = ?, jumlah = ?, pemasok = ?, harga = ? WHERE id = ?',
    [v.tanggal, v.judul, v.kategori, v.penulis, v.jumlah, v.pemasok, v.harga, id],
  )
  res.json(await ambil(id))
}))

app.delete('/buku/:id', h(async (req, res) => {
  const id = parseId(req, res); if (id === null) return
  const [r] = await pool.query('DELETE FROM buku WHERE id = ?', [id])
  if (r.affectedRows === 0) return res.status(404).json({ message: 'Data tidak ditemukan.' })
  res.status(204).end()
}))

app.use((req, res) => res.status(404).json({ message: 'Endpoint tidak ditemukan.' }))

// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  if (err.type === 'entity.parse.failed') return res.status(400).json({ message: 'Body JSON tidak valid.' })
  console.error(err)
  res.status(500).json({ message: 'Terjadi kesalahan pada server.' })
})

// ---------- Start ----------
initDb()
  .then(() => app.listen(PORT, () => console.log(`API Pasar Buku Wilis jalan di http://localhost:${PORT}`)))
  .catch((err) => {
    if (err.code === 'ECONNREFUSED') {
      console.error('Tidak bisa konek ke MySQL. Pastikan MySQL sudah dinyalakan (XAMPP/Laragon: Start MySQL).')
    } else if (err.code === 'ER_ACCESS_DENIED_ERROR') {
      console.error('Login MySQL ditolak. Cek DB_USER / DB_PASSWORD di file backend/.env.')
    } else {
      console.error(err)
    }
    process.exit(1)
  })
