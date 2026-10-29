/* ===== 1. Slide sambutan (3 titik) ===== */
const slides = document.querySelectorAll(".slide");
const dots = document.querySelectorAll(".dot");
let indeks = 0;
let timer;

function tampilkanSlide(i) {
  indeks = i;
  slides.forEach((s, n) => s.classList.toggle("aktif", n === i));
  dots.forEach((d, n) => d.classList.toggle("aktif", n === i));
}
function mulaiOtomatis() {
  clearInterval(timer);
  timer = setInterval(() => tampilkanSlide((indeks + 1) % slides.length), 4000); // 4000 = 4 detik
}
dots.forEach((d, n) => d.addEventListener("click", () => { tampilkanSlide(n); mulaiOtomatis(); }));
if (slides.length) mulaiOtomatis();

/* ===== 2. Tombol lihat/sembunyikan password ===== */
document.querySelectorAll(".toggle-pw").forEach((btn) => {
  btn.addEventListener("click", () => {
    const input = document.getElementById(btn.dataset.target);
    const tersembunyi = input.type === "password";
    input.type = tersembunyi ? "text" : "password";
    btn.textContent = tersembunyi ? "Sembunyi" : "Lihat";
  });
});

/* ===== 3. Inisialisasi Supabase & Fungsi Bantu ===== */
const SUPABASE_URL = 'https://vdvlymemoqkgdpzgndhr.supabase.co';
const SUPABASE_KEY = 'sb_publishable_-xh3JEbtYgQ5ERgIf3VWGg_L5ETk7_d';
const supabaseClient = (window.supabase && typeof window.supabase.createClient === "function")
  ? window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY)
  : null;

function setError(input, pesan) {
  const field = input.closest(".field");
  field.classList.toggle("salah", !!pesan);
  field.querySelector(".pesan-error").textContent = pesan || "";
  return !pesan;
}
function notif(teks, jenis) {
  const el = document.getElementById("notif");
  el.textContent = teks;
  el.className = "notif tampil " + jenis;
}
// Penyimpanan lokal sebagai cadangan (fallback offline)
const ambilUser = () => JSON.parse(localStorage.getItem("users") || "[]");
const simpanUser = (u) => localStorage.setItem("users", JSON.stringify(u));

/* ===== 4. Form Registrasi (Tersimpan ke Database Supabase) ===== */
const formRegistrasi = document.getElementById("formRegistrasi");
if (formRegistrasi) {
  formRegistrasi.addEventListener("submit", async (e) => {
    e.preventDefault();
    const f = formRegistrasi;
    const btnDaftar = f.querySelector("button[type='submit']");
    const nama = f.nama.value.trim();
    const username = f.username.value.trim();
    const password = f.password.value;

    const ok = [
      setError(f.nama, nama ? "" : "Nama lengkap wajib diisi"),
      setError(f.username, username.length >= 4 ? "" : "Username minimal 4 karakter"),
      setError(f.password, password.length >= 6 ? "" : "Password minimal 6 karakter"),
      setError(f.setuju, f.setuju.checked ? "" : "Centang persetujuan untuk melanjutkan"),
    ].every(Boolean);
    if (!ok) return;

    btnDaftar.disabled = true;
    btnDaftar.textContent = "Mendaftarkan ke Database...";

    try {
      // 1. Cek apakah username sudah dipakai di database Supabase
      if (supabaseClient) {
        const { data: existingUser, error: errCek } = await supabaseClient
          .from("users")
          .select("id, username")
          .eq("username", username)
          .maybeSingle();

        if (existingUser) {
          setError(f.username, "Username sudah dipakai, silakan pilih yang lain");
          btnDaftar.disabled = false;
          btnDaftar.textContent = "Daftar";
          return;
        }

        // 2. Simpan data registrasi ke dalam tabel database 'users'
        const { error: errInsert } = await supabaseClient
          .from("users")
          .insert([{ nama, username, password }]);

        if (errInsert) {
          console.warn("Gagal menyimpan ke tabel Supabase, simpan ke lokal:", errInsert);
        }
      }

      // Simpan cadangan ke localStorage
      const users = ambilUser();
      if (!users.some((u) => u.username === username)) {
        users.push({ nama, username, password });
        simpanUser(users);
      }

      // Simpan akun pengguna yang aktif login
      localStorage.setItem("currentUser", JSON.stringify({ nama, username }));

      notif("Pendaftaran berhasil dan tersimpan di database! Mengalihkan...", "sukses");
      setTimeout(() => (location.href = "login.html"), 1200);
    } catch (err) {
      console.error("Kesalahan registrasi:", err);
      notif("Terjadi kesalahan: " + (err.message || err), "gagal");
      btnDaftar.disabled = false;
      btnDaftar.textContent = "Daftar";
    }
  });
}

/* ===== 5. Form Login (Verifikasi Database Supabase) ===== */
const formLogin = document.getElementById("formLogin");
if (formLogin) {
  formLogin.addEventListener("submit", async (e) => {
    e.preventDefault();
    const f = formLogin;
    const btnLogin = f.querySelector("button[type='submit']");
    const username = f.username.value.trim();
    const password = f.password.value;

    const ok = [
      setError(f.username, username ? "" : "Username wajib diisi"),
      setError(f.password, password ? "" : "Password wajib diisi"),
    ].every(Boolean);
    if (!ok) return;

    btnLogin.disabled = true;
    btnLogin.textContent = "Memeriksa Akun...";

    try {
      let user = null;

      // 1. Verifikasi dengan tabel database Supabase
      if (supabaseClient) {
        const { data, error } = await supabaseClient
          .from("users")
          .select("id, nama, username")
          .eq("username", username)
          .eq("password", password)
          .maybeSingle();

        if (!error && data) {
          user = data;
        }
      }

      // 2. Fallback verifikasi lokal jika offline
      if (!user) {
        const userLokal = ambilUser().find((u) => u.username === username && u.password === password);
        if (userLokal) {
          user = { nama: userLokal.nama, username: userLokal.username };
        }
      }

      if (!user) {
        btnLogin.disabled = false;
        btnLogin.textContent = "Login";
        return notif("Username atau password salah.", "gagal");
      }

      // Simpan sesi login aktif
      localStorage.setItem("currentUser", JSON.stringify({ nama: user.nama, username: user.username }));

      notif(`Selamat datang, ${user.nama}!`, "sukses");
      setTimeout(() => (location.href = "index.html"), 1000);
    } catch (err) {
      console.error("Kesalahan login:", err);
      btnLogin.disabled = false;
      btnLogin.textContent = "Login";
      notif("Gagal melakukan login: " + (err.message || err), "gagal");
    }
  });
}
