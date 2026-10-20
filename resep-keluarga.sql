-- =====================================================
-- DATABASE RESEP & MENU MASAKAN KELUARGA
-- Kompatibel dengan MySQL / MariaDB
-- =====================================================

DROP DATABASE IF EXISTS resep_keluarga;
CREATE DATABASE resep_keluarga CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE resep_keluarga;

-- =====================================================
-- 1. STRUKTUR TABEL
-- =====================================================

CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(50) NOT NULL
);

CREATE TABLE resep (
    id_resep INT AUTO_INCREMENT PRIMARY KEY,
    nama_resep VARCHAR(100) NOT NULL,
    id_kategori INT NOT NULL,
    asal_daerah VARCHAR(50),
    porsi INT NOT NULL DEFAULT 4,
    waktu_persiapan_menit INT,
    waktu_memasak_menit INT,
    tingkat_kesulitan ENUM('Mudah','Sedang','Sulit') DEFAULT 'Mudah',
    deskripsi TEXT,
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori)
);

CREATE TABLE bahan (
    id_bahan INT AUTO_INCREMENT PRIMARY KEY,
    nama_bahan VARCHAR(80) NOT NULL,
    satuan_default VARCHAR(20)
);

CREATE TABLE resep_bahan (
    id_resep INT NOT NULL,
    id_bahan INT NOT NULL,
    jumlah DECIMAL(10,2) NOT NULL,
    satuan VARCHAR(20) NOT NULL,
    keterangan VARCHAR(100),
    PRIMARY KEY (id_resep, id_bahan),
    FOREIGN KEY (id_resep) REFERENCES resep(id_resep) ON DELETE CASCADE,
    FOREIGN KEY (id_bahan) REFERENCES bahan(id_bahan)
);

CREATE TABLE langkah_memasak (
    id_langkah INT AUTO_INCREMENT PRIMARY KEY,
    id_resep INT NOT NULL,
    urutan INT NOT NULL,
    instruksi TEXT NOT NULL,
    FOREIGN KEY (id_resep) REFERENCES resep(id_resep) ON DELETE CASCADE
);

CREATE TABLE anggota_keluarga (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    peran VARCHAR(30),
    makanan_favorit VARCHAR(100),
    alergi VARCHAR(100)
);

CREATE TABLE menu_mingguan (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    hari ENUM('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu') NOT NULL,
    waktu_makan ENUM('Sarapan','Makan Siang','Makan Malam') NOT NULL,
    id_resep INT NOT NULL,
    catatan VARCHAR(150),
    FOREIGN KEY (id_resep) REFERENCES resep(id_resep)
);

-- =====================================================
-- 2. DATA KATEGORI
-- =====================================================

INSERT INTO kategori (nama_kategori) VALUES
('Sarapan'),
('Lauk Pauk'),
('Sayuran'),
('Sup & Soto'),
('Camilan'),
('Minuman');

-- =====================================================
-- 3. DATA BAHAN
-- =====================================================

INSERT INTO bahan (nama_bahan, satuan_default) VALUES
('Beras putih', 'gram'),            -- 1
('Telur ayam', 'butir'),            -- 2
('Bawang merah', 'siung'),          -- 3
('Bawang putih', 'siung'),          -- 4
('Cabai merah keriting', 'buah'),   -- 5
('Cabai rawit', 'buah'),            -- 6
('Kecap manis', 'sdm'),             -- 7
('Garam', 'sdt'),                   -- 8
('Gula pasir', 'sdt'),              -- 9
('Minyak goreng', 'sdm'),           -- 10
('Daging ayam', 'gram'),            -- 11
('Tahu putih', 'buah'),             -- 12
('Tempe', 'papan'),                 -- 13
('Kangkung', 'ikat'),               -- 14
('Bayam', 'ikat'),                  -- 15
('Santan', 'ml'),                   -- 16
('Kunyit', 'cm'),                   -- 17
('Jahe', 'cm'),                     -- 18
('Lengkuas', 'cm'),                 -- 19
('Daun salam', 'lembar'),           -- 20
('Serai', 'batang'),                -- 21
('Tomat', 'buah'),                  -- 22
('Wortel', 'buah'),                 -- 23
('Kentang', 'buah'),                -- 24
('Ikan nila', 'ekor'),              -- 25
('Jeruk nipis', 'buah'),            -- 26
('Kemiri', 'butir'),                -- 27
('Ketumbar bubuk', 'sdt'),          -- 28
('Merica bubuk', 'sdt'),            -- 29
('Kacang tanah', 'gram'),           -- 30
('Teh celup', 'kantong');           -- 31

-- =====================================================
-- 4. DATA RESEP
-- =====================================================

INSERT INTO resep (nama_resep, id_kategori, asal_daerah, porsi, waktu_persiapan_menit, waktu_memasak_menit, tingkat_kesulitan, deskripsi) VALUES
('Nasi Goreng Telur', 1, 'Nasional', 4, 10, 15, 'Mudah', 'Nasi goreng sederhana dengan telur mata sapi, favorit sarapan keluarga.'),
('Ayam Goreng Kuning', 2, 'Jawa', 5, 20, 30, 'Sedang', 'Ayam goreng berbumbu kunyit yang gurih dan renyah.'),
('Tumis Kangkung Belacan', 3, 'Nasional', 4, 10, 8, 'Mudah', 'Tumisan kangkung pedas gurih, cocok untuk menu harian.'),
('Sayur Bayam Bening', 3, 'Jawa', 4, 10, 15, 'Mudah', 'Sayur bening segar dengan bayam dan wortel.'),
('Soto Ayam Kuning', 4, 'Jawa Timur', 6, 30, 45, 'Sedang', 'Soto ayam berkuah kuning dengan rempah yang harum.'),
('Tempe Tahu Goreng Bacem', 2, 'Yogyakarta', 5, 15, 40, 'Sedang', 'Tempe dan tahu dimasak manis dengan bumbu bacem.'),
('Ikan Nila Bakar Kecap', 2, 'Nasional', 4, 20, 25, 'Sedang', 'Ikan nila bakar dengan olesan bumbu kecap pedas manis.'),
('Gulai Ayam Santan', 2, 'Sumatera', 6, 25, 50, 'Sulit', 'Ayam dimasak dalam kuah santan kaya rempah.'),
('Perkedel Kentang', 5, 'Nasional', 8, 20, 20, 'Mudah', 'Perkedel kentang goreng, cocok untuk camilan atau pendamping.'),
('Es Teh Manis Keluarga', 6, 'Nasional', 4, 5, 5, 'Mudah', 'Minuman teh manis dingin untuk menemani makan siang.');

-- =====================================================
-- 5. DATA BAHAN PER RESEP
-- =====================================================

-- 1. Nasi Goreng Telur
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(1, 1, 600, 'gram', 'nasi dingin sisa semalam'),
(1, 2, 4, 'butir', 'untuk telur mata sapi'),
(1, 3, 5, 'siung', 'dihaluskan'),
(1, 4, 3, 'siung', 'dihaluskan'),
(1, 5, 3, 'buah', 'dihaluskan'),
(1, 7, 3, 'sdm', NULL),
(1, 8, 1, 'sdt', NULL),
(1, 10, 4, 'sdm', NULL);

-- 2. Ayam Goreng Kuning
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(2, 11, 1000, 'gram', 'dipotong 8 bagian'),
(2, 3, 6, 'siung', 'dihaluskan'),
(2, 4, 4, 'siung', 'dihaluskan'),
(2, 17, 3, 'cm', 'dihaluskan'),
(2, 28, 1, 'sdt', NULL),
(2, 20, 2, 'lembar', NULL),
(2, 21, 1, 'batang', 'digeprek'),
(2, 8, 2, 'sdt', NULL),
(2, 10, 300, 'ml', 'untuk menggoreng');

-- 3. Tumis Kangkung Belacan
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(3, 14, 2, 'ikat', 'dipotong 5 cm'),
(3, 3, 4, 'siung', 'diiris'),
(3, 4, 3, 'siung', 'dicincang'),
(3, 5, 4, 'buah', 'diiris serong'),
(3, 8, 1, 'sdt', NULL),
(3, 10, 2, 'sdm', NULL);

-- 4. Sayur Bayam Bening
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(4, 15, 2, 'ikat', 'dipetik daunnya'),
(4, 23, 1, 'buah', 'diiris tipis'),
(4, 3, 4, 'siung', 'diiris'),
(4, 4, 2, 'siung', 'dimemarkan'),
(4, 8, 1, 'sdt', NULL),
(4, 9, 1, 'sdt', NULL);

-- 5. Soto Ayam Kuning
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(5, 11, 800, 'gram', 'direbus utuh'),
(5, 3, 6, 'siung', 'dihaluskan'),
(5, 4, 4, 'siung', 'dihaluskan'),
(5, 17, 3, 'cm', 'dihaluskan'),
(5, 18, 2, 'cm', 'dihaluskan'),
(5, 27, 3, 'butir', 'dihaluskan'),
(5, 21, 2, 'batang', 'digeprek'),
(5, 20, 3, 'lembar', NULL),
(5, 24, 2, 'buah', 'direbus dan dipotong'),
(5, 2, 3, 'butir', 'direbus untuk pelengkap'),
(5, 26, 2, 'buah', 'untuk pelengkap'),
(5, 8, 2, 'sdt', NULL);

-- 6. Tempe Tahu Bacem
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(6, 13, 2, 'papan', 'dipotong persegi'),
(6, 12, 6, 'buah', NULL),
(6, 3, 5, 'siung', 'dihaluskan'),
(6, 4, 3, 'siung', 'dihaluskan'),
(6, 7, 5, 'sdm', NULL),
(6, 20, 3, 'lembar', NULL),
(6, 19, 3, 'cm', 'digeprek'),
(6, 8, 1, 'sdt', NULL);

-- 7. Ikan Nila Bakar Kecap
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(7, 25, 2, 'ekor', 'dibersihkan dan disayat'),
(7, 26, 2, 'buah', 'diperas airnya'),
(7, 7, 4, 'sdm', NULL),
(7, 3, 4, 'siung', 'dihaluskan'),
(7, 4, 3, 'siung', 'dihaluskan'),
(7, 6, 5, 'buah', 'dihaluskan'),
(7, 8, 1, 'sdt', NULL);

-- 8. Gulai Ayam Santan
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(8, 11, 1000, 'gram', 'dipotong 10 bagian'),
(8, 16, 600, 'ml', 'santan kental'),
(8, 3, 8, 'siung', 'dihaluskan'),
(8, 4, 5, 'siung', 'dihaluskan'),
(8, 17, 3, 'cm', 'dihaluskan'),
(8, 18, 3, 'cm', 'dihaluskan'),
(8, 19, 3, 'cm', 'digeprek'),
(8, 21, 2, 'batang', 'digeprek'),
(8, 20, 3, 'lembar', NULL),
(8, 5, 5, 'buah', 'dihaluskan'),
(8, 28, 1, 'sdt', NULL),
(8, 8, 2, 'sdt', NULL);

-- 9. Perkedel Kentang
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(9, 24, 5, 'buah', 'direbus dan dihaluskan'),
(9, 2, 2, 'butir', NULL),
(9, 3, 3, 'siung', 'digoreng'),
(9, 4, 2, 'siung', 'dihaluskan'),
(9, 29, 1, 'sdt', NULL),
(9, 8, 1, 'sdt', NULL),
(9, 10, 200, 'ml', 'untuk menggoreng');

-- 10. Es Teh Manis
INSERT INTO resep_bahan (id_resep, id_bahan, jumlah, satuan, keterangan) VALUES
(10, 31, 4, 'kantong', NULL),
(10, 9, 8, 'sdt', 'sesuai selera');

-- =====================================================
-- 6. LANGKAH MEMASAK
-- =====================================================

INSERT INTO langkah_memasak (id_resep, urutan, instruksi) VALUES
-- Nasi Goreng Telur
(1, 1, 'Haluskan bawang merah, bawang putih, dan cabai.'),
(1, 2, 'Panaskan minyak, tumis bumbu halus hingga harum.'),
(1, 3, 'Masukkan nasi, kecap manis, dan garam. Aduk rata dengan api besar.'),
(1, 4, 'Goreng telur mata sapi, sajikan di atas nasi goreng.'),

-- Ayam Goreng Kuning
(2, 1, 'Ungkep ayam bersama bumbu halus, daun salam, serai, dan sedikit air selama 20 menit.'),
(2, 2, 'Tiriskan ayam hingga agak kering.'),
(2, 3, 'Goreng dalam minyak panas hingga kuning keemasan dan renyah.'),
(2, 4, 'Angkat dan sajikan hangat dengan sambal.'),

-- Tumis Kangkung
(3, 1, 'Tumis bawang merah, bawang putih, dan cabai hingga harum.'),
(3, 2, 'Masukkan kangkung, aduk cepat dengan api besar.'),
(3, 3, 'Tambahkan garam, masak sekitar 2 menit lalu angkat.'),

-- Sayur Bayam Bening
(4, 1, 'Didihkan 1 liter air bersama bawang putih dan bawang merah.'),
(4, 2, 'Masukkan wortel, masak hingga setengah empuk.'),
(4, 3, 'Masukkan bayam, garam, dan gula. Masak 2 menit lalu angkat.'),

-- Soto Ayam Kuning
(5, 1, 'Rebus ayam hingga matang, angkat, suwir-suwir, sisihkan kaldunya.'),
(5, 2, 'Tumis bumbu halus bersama serai dan daun salam hingga harum.'),
(5, 3, 'Masukkan tumisan ke kaldu, masak 20 menit dengan api kecil.'),
(5, 4, 'Sajikan dengan suwiran ayam, kentang, telur rebus, dan perasan jeruk nipis.'),

-- Tempe Tahu Bacem
(6, 1, 'Rebus tempe dan tahu bersama bumbu halus, kecap, daun salam, dan lengkuas.'),
(6, 2, 'Masak dengan api kecil hingga air menyusut dan bumbu meresap (sekitar 30 menit).'),
(6, 3, 'Goreng sebentar atau bakar sebelum disajikan.'),

-- Ikan Nila Bakar
(7, 1, 'Lumuri ikan dengan air jeruk nipis dan garam, diamkan 15 menit.'),
(7, 2, 'Tumis bumbu halus, campur dengan kecap manis.'),
(7, 3, 'Olesi ikan dengan bumbu, bakar sambil sesekali diolesi hingga matang.'),

-- Gulai Ayam
(8, 1, 'Tumis bumbu halus bersama serai, lengkuas, dan daun salam hingga harum.'),
(8, 2, 'Masukkan ayam, aduk hingga berubah warna.'),
(8, 3, 'Tuang santan, masak dengan api kecil sambil sesekali diaduk hingga ayam empuk.'),
(8, 4, 'Koreksi rasa, sajikan hangat dengan nasi.'),

-- Perkedel Kentang
(9, 1, 'Campur kentang halus dengan bumbu dan telur, aduk rata.'),
(9, 2, 'Bentuk bulat pipih.'),
(9, 3, 'Goreng hingga kecokelatan.'),

-- Es Teh Manis
(10, 1, 'Seduh teh dengan air panas, tambahkan gula, aduk.'),
(10, 2, 'Dinginkan, sajikan dengan es batu.');

-- =====================================================
-- 7. ANGGOTA KELUARGA
-- =====================================================

INSERT INTO anggota_keluarga (nama, peran, makanan_favorit, alergi) VALUES
('Budi', 'Ayah', 'Soto Ayam Kuning', NULL),
('Siti', 'Ibu', 'Gulai Ayam Santan', NULL),
('Andi', 'Anak', 'Ayam Goreng Kuning', 'Kacang tanah'),
('Rina', 'Anak', 'Perkedel Kentang', NULL),
('Nenek Aminah', 'Nenek', 'Tempe Tahu Bacem', 'Gula berlebih');

-- =====================================================
-- 8. MENU MINGGUAN
-- =====================================================

INSERT INTO menu_mingguan (hari, waktu_makan, id_resep, catatan) VALUES
('Senin',  'Sarapan',      1,  'Tambah kerupuk'),
('Senin',  'Makan Siang',  2,  NULL),
('Senin',  'Makan Malam',  4,  NULL),
('Selasa', 'Makan Siang',  7,  'Ikan segar dari pasar'),
('Selasa', 'Makan Malam',  3,  NULL),
('Rabu',   'Sarapan',      1,  NULL),
('Rabu',   'Makan Siang',  6,  'Untuk Nenek, kurangi gula'),
('Kamis',  'Makan Siang',  9,  NULL),
('Kamis',  'Makan Malam',  4,  NULL),
('Jumat',  'Makan Siang',  2,  NULL),
('Jumat',  'Makan Malam',  3,  NULL),
('Sabtu',  'Makan Siang',  8,  'Menu spesial akhir pekan'),
('Sabtu',  'Makan Malam',  10, 'Pelengkap minuman'),
('Minggu', 'Sarapan',      5,  'Sarapan bersama keluarga'),
('Minggu', 'Makan Siang',  7,  NULL);

-- =====================================================
-- 9. CONTOH QUERY
-- =====================================================

-- Daftar resep beserta kategori:
-- SELECT r.nama_resep, k.nama_kategori, r.tingkat_kesulitan
-- FROM resep r JOIN kategori k ON r.id_kategori = k.id_kategori;

-- Bahan lengkap untuk satu resep (misal id 5):
-- SELECT b.nama_bahan, rb.jumlah, rb.satuan, rb.keterangan
-- FROM resep_bahan rb JOIN bahan b ON rb.id_bahan = b.id_bahan
-- WHERE rb.id_resep = 5;

-- Menu mingguan:
-- SELECT m.hari, m.waktu_makan, r.nama_resep, m.catatan
-- FROM menu_mingguan m JOIN resep r ON m.id_resep = r.id_resep
-- ORDER BY FIELD(m.hari,'Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu'),
--          FIELD(m.waktu_makan,'Sarapan','Makan Siang','Makan Malam');
