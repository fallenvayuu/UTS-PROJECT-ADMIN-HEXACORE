import { useState, useEffect } from 'react'
import { parts as seed, kategori } from './data'

const rp = (n) => 'Rp ' + Number(n).toLocaleString('id-ID')
const kosong = { tanggal: '', nama: '', kategori: 'LCD', tipe: '', jumlah: '', supplier: '', harga: '' }
const STOK_MENIPIS = 5

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
        <h1>Hexacore Sparepart</h1>
        <p className="muted">Masuk sebagai admin untuk mengelola barang masuk.</p>
        <label>Username<input value={f.user} onChange={(e) => setF({ ...f, user: e.target.value })} /></label>
        <label>Password<input type="password" value={f.pass} onChange={(e) => setF({ ...f, pass: e.target.value })} /></label>
        {err && <p className="error">{err}</p>}
        <button className="btn">Masuk</button>
      </form>
    </div>
  )
}

function Dashboard({ data }) {
  const totalUnit = data.reduce((s, d) => s + Number(d.jumlah), 0)
  const menipis = data.filter((d) => d.jumlah < STOK_MENIPIS)
  const nilai = data.reduce((s, d) => s + d.jumlah * d.harga, 0)
  const kartu = [
    ['Jenis part', data.length],
    ['Total unit masuk', totalUnit],
    ['Stok menipis', menipis.length],
    ['Nilai pembelian', rp(nilai)],
  ]
  return (
    <>
      <h2>Dashboard</h2>
      <div className="cards">
        {kartu.map(([l, v]) => (
          <div className="panel card" key={l}><span className="muted">{l}</span><strong>{v}</strong></div>
        ))}
      </div>
      <h3>Barang masuk terbaru</h3>
      <Tabel rows={[...data].sort((a, b) => b.tanggal.localeCompare(a.tanggal)).slice(0, 5)} />
      {menipis.length > 0 && (
        <p className="warn">Stok menipis: {menipis.map((m) => m.nama).join(', ')}.</p>
      )}
    </>
  )
}

function Tabel({ rows, aksi }) {
  if (!rows.length) return <p className="muted">Belum ada data. Tambahkan barang masuk lewat form.</p>
  return (
    <div className="scroll">
      <table>
        <thead>
          <tr><th>Tanggal</th><th>Nama part</th><th>Kategori</th><th>Tipe HP</th><th>Jumlah</th><th>Supplier</th><th>Harga</th>{aksi && <th></th>}</tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{r.tanggal}</td><td>{r.nama}</td><td>{r.kategori}</td><td>{r.tipe}</td>
              <td className={r.jumlah < STOK_MENIPIS ? 'low' : ''}>{r.jumlah}</td>
              <td>{r.supplier}</td><td>{rp(r.harga)}</td>
              {aksi && <td className="act">{aksi(r)}</td>}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

function Kelola({ data, setData }) {
  const [form, setForm] = useState(kosong)
  const [editId, setEditId] = useState(null)
  const [errs, setErrs] = useState({})
  const [cari, setCari] = useState('')

  const validasi = () => {
    const e = {}
    if (!form.tanggal) e.tanggal = 'Tanggal wajib diisi.'
    if (!form.nama.trim()) e.nama = 'Nama part wajib diisi.'
    if (!form.tipe.trim()) e.tipe = 'Tipe HP wajib diisi.'
    if (!(Number(form.jumlah) > 0)) e.jumlah = 'Jumlah harus angka lebih dari 0.'
    if (!(Number(form.harga) >= 0) || form.harga === '') e.harga = 'Harga tidak boleh kosong atau negatif.'
    return e
  }
  const simpan = (e) => {
    e.preventDefault()
    const v = validasi()
    setErrs(v)
    if (Object.keys(v).length) return
    const item = { ...form, jumlah: Number(form.jumlah), harga: Number(form.harga) }
    if (editId) setData(data.map((d) => (d.id === editId ? { ...item, id: editId } : d)))
    else setData([...data, { ...item, id: Date.now() }])
    setForm(kosong); setEditId(null)
  }
  const ubah = (r) => { setForm(r); setEditId(r.id); setErrs({}); window.scrollTo(0, 0) }
  const hapus = (r) => window.confirm(`Hapus ${r.nama}?`) && setData(data.filter((d) => d.id !== r.id))
  const set = (k) => (e) => setForm({ ...form, [k]: e.target.value })
  const field = (k, label, type = 'text') => (
    <label>{label}<input type={type} value={form[k]} onChange={set(k)} />{errs[k] && <span className="error">{errs[k]}</span>}</label>
  )
  const rows = data.filter((d) => (d.nama + d.tipe + d.supplier).toLowerCase().includes(cari.toLowerCase()))

  return (
    <>
      <h2>Kelola barang masuk</h2>
      <form onSubmit={simpan} className="panel form">
        {field('tanggal', 'Tanggal datang', 'date')}
        {field('nama', 'Nama part')}
        <label>Kategori<select value={form.kategori} onChange={set('kategori')}>{kategori.map((k) => <option key={k}>{k}</option>)}</select></label>
        {field('tipe', 'Tipe HP')}
        {field('jumlah', 'Jumlah', 'number')}
        {field('supplier', 'Supplier')}
        {field('harga', 'Harga beli (Rp)', 'number')}
        <div className="row">
          <button className="btn">{editId ? 'Simpan perubahan' : 'Tambah barang masuk'}</button>
          {editId && <button type="button" className="btn ghost" onClick={() => { setForm(kosong); setEditId(null); setErrs({}) }}>Batal</button>}
        </div>
      </form>
      <input className="search" placeholder="Cari nama part, tipe HP, atau supplier" value={cari} onChange={(e) => setCari(e.target.value)} />
      <Tabel rows={rows} aksi={(r) => (<><button className="link" onClick={() => ubah(r)}>Ubah</button><button className="link danger" onClick={() => hapus(r)}>Hapus</button></>)} />
    </>
  )
}

export default function App() {
  const [user, setUser] = useState(null)
  const [page, setPage] = useState('dashboard')
  const [data, setData] = useState(() => {
    try { return JSON.parse(localStorage.getItem('hexacore-data')) || seed } catch { return seed }
  })
  useEffect(() => { try { localStorage.setItem('hexacore-data', JSON.stringify(data)) } catch {} }, [data])

  if (!user) return <Login onLogin={setUser} />
  return (
    <div className="app">
      <aside>
        <div className="brand">Hexacore</div>
        <button className={page === 'dashboard' ? 'on' : ''} onClick={() => setPage('dashboard')}>Dashboard</button>
        <button className={page === 'kelola' ? 'on' : ''} onClick={() => setPage('kelola')}>Kelola data</button>
        <button onClick={() => setUser(null)}>Keluar</button>
      </aside>
      <main>{page === 'dashboard' ? <Dashboard data={data} /> : <Kelola data={data} setData={setData} />}</main>
    </div>
  )
}
