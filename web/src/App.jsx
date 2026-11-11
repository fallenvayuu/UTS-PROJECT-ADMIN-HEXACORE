import { useState, useEffect, useCallback } from 'react'
import { kategori } from './data'
import { getBuku, createBuku, updateBuku, deleteBuku } from './api'

const rp = (n) => 'Rp ' + Number(n).toLocaleString('id-ID')
const kosong = { tanggal: '', judul: '', kategori: 'Novel', penulis: '', jumlah: '', pemasok: '', harga: '' }
const STOK_MENIPIS = 5

// Logo: buku terbuka, digambar dengan warna teks sekitarnya.
function Logo({ size = 28 }) {
  return (
    <svg className="logo" width={size} height={size} viewBox="0 0 32 32" fill="none" stroke="currentColor"
      strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M16 8C13 5.8 9 5.2 5 5.7V23.7C9 23.2 13 23.8 16 26C19 23.8 23 23.2 27 23.7V5.7C23 5.2 19 5.8 16 8Z" />
      <path d="M16 8V26" />
    </svg>
  )
}

function Login({ onLogin }) {
  const [f, setF] = useState({ user: '', pass: '' })
  const [err, setErr] = useState('')
  const kirim = (e) => {
    e.preventDefault()
    if (!f.user.trim() || !f.pass) return setErr('Username dan password wajib diisi.')
    if (f.user !== 'admin' || f.pass !== 'admin123') return setErr('Username atau password salah. Gunakan admin / admin123.')
    onLogin(f.user)
  }
  return (
    <div className="login">
      <form onSubmit={kirim} className="panel login-box">
        <div className="title-page">
          <Logo size={44} />
          <h1>Pasar Buku Wilis</h1>
          <p className="muted">Catatan buku masuk lapak</p>
        </div>
        <p className="muted">Masuk sebagai admin untuk mengelola buku masuk.</p>
        <label>Username<input value={f.user} onChange={(e) => setF({ ...f, user: e.target.value })} /></label>
        <label>Password<input type="password" value={f.pass} onChange={(e) => setF({ ...f, pass: e.target.value })} /></label>
        {err && <p className="error">{err}</p>}
        <button className="btn">Masuk</button>
      </form>
    </div>
  )
}

function Dashboard({ data }) {
  const totalEks = data.reduce((s, d) => s + Number(d.jumlah), 0)
  const menipis = data.filter((d) => d.jumlah < STOK_MENIPIS)
  const nilai = data.reduce((s, d) => s + d.jumlah * d.harga, 0)
  const kartu = [
    ['Judul buku', data.length],
    ['Total eksemplar masuk', totalEks],
    ['Stok menipis', menipis.length],
    ['Nilai kulakan', rp(nilai)],
  ]
  return (
    <>
      <h2>Dashboard</h2>
      <p className="muted lead">Ringkasan buku yang masuk ke lapak.</p>
      <div className="cards">
        {kartu.map(([l, v]) => (
          <div className="panel card" key={l}><span className="muted">{l}</span><strong>{v}</strong></div>
        ))}
      </div>
      <h3>Buku masuk terbaru</h3>
      <Tabel rows={[...data].sort((a, b) => b.tanggal.localeCompare(a.tanggal)).slice(0, 5)} />
      {menipis.length > 0 && (
        <p className="warn">Stok menipis (kurang dari {STOK_MENIPIS} eksemplar): {menipis.map((m) => m.judul).join(', ')}.</p>
      )}
    </>
  )
}

function Tabel({ rows, aksi }) {
  if (!rows.length) return <p className="muted">Belum ada buku tercatat. Tambahkan buku masuk lewat form.</p>
  return (
    <div className="scroll">
      <table>
        <thead>
          <tr>
            <th>Tanggal</th><th>Judul</th><th>Kategori</th><th>Penulis</th>
            <th className="num">Jumlah</th><th>Pemasok</th><th className="num">Harga kulak</th>{aksi && <th></th>}
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => {
            const tipis = r.jumlah < STOK_MENIPIS
            return (
              <tr key={r.id}>
                <td>{r.tanggal}</td><td className="judul">{r.judul}</td><td>{r.kategori}</td><td className="penulis">{r.penulis}</td>
                <td className={'num' + (tipis ? ' low' : '')}>{r.jumlah}{tipis && <span className="tag">menipis</span>}</td>
                <td className="pemasok">{r.pemasok}</td><td className="num">{rp(r.harga)}</td>
                {aksi && <td className="act">{aksi(r)}</td>}
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}

function Kelola({ data, onSimpan, onHapus }) {
  const [form, setForm] = useState(kosong)
  const [editId, setEditId] = useState(null)
  const [errs, setErrs] = useState({})
  const [cari, setCari] = useState('')
  const [proses, setProses] = useState(false)
  const [galat, setGalat] = useState('')

  const validasi = () => {
    const e = {}
    if (!form.tanggal) e.tanggal = 'Tanggal wajib diisi.'
    if (!form.judul.trim()) e.judul = 'Judul buku wajib diisi.'
    if (!form.penulis.trim()) e.penulis = 'Penulis wajib diisi.'
    if (!(Number(form.jumlah) > 0)) e.jumlah = 'Jumlah harus angka lebih dari 0.'
    if (!(Number(form.harga) >= 0) || form.harga === '') e.harga = 'Harga tidak boleh kosong atau negatif.'
    return e
  }
  const simpan = async (e) => {
    e.preventDefault()
    const v = validasi()
    setErrs(v); setGalat('')
    if (Object.keys(v).length) return
    const item = {
      tanggal: form.tanggal, judul: form.judul.trim(), kategori: form.kategori,
      penulis: form.penulis.trim(), pemasok: form.pemasok.trim(),
      jumlah: Number(form.jumlah), harga: Number(form.harga),
    }
    setProses(true)
    try {
      await onSimpan(item, editId)
      setForm(kosong); setEditId(null)
    } catch (err) {
      setGalat(err.message)
    } finally {
      setProses(false)
    }
  }
  const ubah = (r) => { setForm(r); setEditId(r.id); setErrs({}); setGalat(''); window.scrollTo(0, 0) }
  const hapus = async (r) => {
    if (!window.confirm(`Hapus "${r.judul}" dari catatan?`)) return
    try {
      await onHapus(r)
      if (editId === r.id) { setForm(kosong); setEditId(null) }
    } catch (err) {
      setGalat(err.message)
    }
  }
  const set = (k) => (e) => setForm({ ...form, [k]: e.target.value })
  const field = (k, label, type = 'text', placeholder = '') => (
    <label>{label}<input type={type} value={form[k]} placeholder={placeholder} onChange={set(k)} />{errs[k] && <span className="error">{errs[k]}</span>}</label>
  )
  const rows = data.filter((d) => (d.judul + d.penulis + d.pemasok).toLowerCase().includes(cari.toLowerCase()))

  return (
    <>
      <h2>Kelola buku masuk</h2>
      <p className="muted lead">Catat buku yang baru datang dari pemasok, ubah, atau hapus catatan lama.</p>
      <form onSubmit={simpan} className="panel form">
        {field('tanggal', 'Tanggal datang', 'date')}
        {field('judul', 'Judul buku', 'text', 'mis. Bumi Manusia')}
        <label>Kategori<select value={form.kategori} onChange={set('kategori')}>{kategori.map((k) => <option key={k}>{k}</option>)}</select></label>
        {field('penulis', 'Penulis', 'text', 'mis. Pramoedya Ananta Toer')}
        {field('jumlah', 'Jumlah (eksemplar)', 'number')}
        {field('pemasok', 'Pemasok', 'text', 'pengepul / kolektor / penerbit')}
        {field('harga', 'Harga kulak per eksemplar (Rp)', 'number')}
        <div className="row">
          <button className="btn" disabled={proses}>{proses ? 'Menyimpan...' : editId ? 'Simpan perubahan' : 'Tambah buku masuk'}</button>
          {editId && <button type="button" className="btn ghost" onClick={() => { setForm(kosong); setEditId(null); setErrs({}); setGalat('') }}>Batal</button>}
        </div>
        {galat && <p className="error">{galat}</p>}
      </form>
      <input className="search" placeholder="Cari judul, penulis, atau pemasok" value={cari} onChange={(e) => setCari(e.target.value)} />
      <Tabel rows={rows} aksi={(r) => (<><button className="link" onClick={() => ubah(r)}>Ubah</button><button className="link danger" onClick={() => hapus(r)}>Hapus</button></>)} />
    </>
  )
}

export default function App() {
  const [user, setUser] = useState(null)
  const [page, setPage] = useState('dashboard')
  const [data, setData] = useState([])
  const [memuat, setMemuat] = useState(true)
  const [galat, setGalat] = useState('')

  // Judul tab browser (supaya tidak bergantung pada index.html).
  useEffect(() => { document.title = 'Pasar Buku Wilis' }, [])

  const muat = useCallback(async () => {
    try {
      setData(await getBuku())
      setGalat('')
    } catch (err) {
      setGalat(err.message)
    } finally {
      setMemuat(false)
    }
  }, [])

  // Ambil data saat login, lalu segarkan tiap 5 detik supaya input dari mobile ikut muncul.
  useEffect(() => {
    if (!user) return
    muat()
    const t = setInterval(muat, 5000)
    return () => clearInterval(t)
  }, [user, muat])

  const simpan = async (item, id) => {
    if (id) await updateBuku(id, item)
    else await createBuku(item)
    await muat()
  }
  const hapus = async (r) => { await deleteBuku(r.id); await muat() }

  if (!user) return <Login onLogin={setUser} />
  return (
    <div className="app">
      <aside>
        <div className="brand">
          <Logo size={30} />
          <div>
            <div className="brand-name">Pasar Buku Wilis</div>
            <div className="brand-sub">Buku bekas · Malang</div>
          </div>
        </div>
        <button className={page === 'dashboard' ? 'on' : ''} onClick={() => setPage('dashboard')}>Dashboard</button>
        <button className={page === 'kelola' ? 'on' : ''} onClick={() => setPage('kelola')}>Kelola buku</button>
        <button onClick={() => setUser(null)}>Keluar</button>
      </aside>
      <main>
        {galat && <p className="error banner">{galat}</p>}
        {memuat && !galat
          ? <p className="muted">Memuat data...</p>
          : page === 'dashboard'
            ? <Dashboard data={data} />
            : <Kelola data={data} onSimpan={simpan} onHapus={hapus} />}
      </main>
    </div>
  )
}
