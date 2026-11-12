// Klien API untuk backend Pasar Buku Wilis (Express + MySQL).
// Alamat bisa diganti lewat web/.env: VITE_API_URL=http://localhost:3000
const BASE = import.meta.env.VITE_API_URL || 'http://localhost:3000'

async function req(path, { body, ...opts } = {}) {
  let res
  try {
    res = await fetch(BASE + path, {
      ...opts,
      // Content-Type hanya dikirim bila ada body (menghindari preflight CORS di GET)
      ...(body !== undefined && { headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) }),
    })
  } catch {
    throw new Error(`Tidak bisa terhubung ke server (${BASE}). Pastikan backend sudah berjalan.`)
  }
  if (res.status === 204) return null
  const json = await res.json().catch(() => ({}))
  if (!res.ok) throw new Error(json.message || `Permintaan gagal (${res.status}).`)
  return json
}

export const getBuku = () => req('/buku')
export const createBuku = (item) => req('/buku', { method: 'POST', body: item })
export const updateBuku = (id, item) => req(`/buku/${id}`, { method: 'PUT', body: item })
export const deleteBuku = (id) => req(`/buku/${id}`, { method: 'DELETE' })
