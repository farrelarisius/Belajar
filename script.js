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

/* ===== 3. Fungsi bantu ===== */
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
// Penyimpanan sederhana di browser (hanya untuk latihan, bukan untuk produksi)
const ambilUser = () => JSON.parse(localStorage.getItem("users") || "[]");
const simpanUser = (u) => localStorage.setItem("users", JSON.stringify(u));

/* ===== 4. Form registrasi ===== */
const formRegistrasi = document.getElementById("formRegistrasi");
if (formRegistrasi) {
  formRegistrasi.addEventListener("submit", (e) => {
    e.preventDefault();
    const f = formRegistrasi;
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

    const users = ambilUser();
    if (users.some((u) => u.username === username)) {
      setError(f.username, "Username sudah dipakai");
      return;
    }
    users.push({ nama, username, password });
    simpanUser(users);
    notif("Pendaftaran berhasil. Mengalihkan ke halaman login...", "sukses");
    setTimeout(() => (location.href = "login.html"), 1200);
  });
}

/* ===== 5. Form login ===== */
const formLogin = document.getElementById("formLogin");
if (formLogin) {
  formLogin.addEventListener("submit", (e) => {
    e.preventDefault();
    const f = formLogin;
    const username = f.username.value.trim();
    const password = f.password.value;

    const ok = [
      setError(f.username, username ? "" : "Username wajib diisi"),
      setError(f.password, password ? "" : "Password wajib diisi"),
    ].every(Boolean);
    if (!ok) return;

    const user = ambilUser().find((u) => u.username === username && u.password === password);
    if (!user) return notif("Username atau password salah.", "gagal");

    notif(`Selamat datang, ${user.nama}!`, "sukses");
    setTimeout(() => (location.href = "index.html"), 1000);
  });
}
