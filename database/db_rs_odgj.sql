-- =====================================================================
--  RS ODGJ - Sistem Informasi Rumah Sakit
--  Jalankan seluruh file ini di MySQL / MariaDB (phpMyAdmin > Import)
-- =====================================================================
DROP DATABASE IF EXISTS db_rs_odgj;
CREATE DATABASE db_rs_odgj CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_rs_odgj;

CREATE TABLE users (
    id_user      INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(50)  NOT NULL UNIQUE,
    password     CHAR(64)     NOT NULL,              -- SHA-256 (hex)
    nama_lengkap VARCHAR(100) NOT NULL,
    role         ENUM('Admin','Dokter','Perawat') NOT NULL,
    status_aktif BOOLEAN      NOT NULL DEFAULT TRUE,
    dibuat_pada  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bangsal (
    id_bangsal   INT AUTO_INCREMENT PRIMARY KEY,
    nama_bangsal VARCHAR(60)  NOT NULL UNIQUE,
    jenis        ENUM('Tenang','Intermediate','Akut','Isolasi') NOT NULL,
    kapasitas    INT          NOT NULL,
    keterangan   VARCHAR(200)
);

CREATE TABLE pasien (
    id_pasien        INT AUTO_INCREMENT PRIMARY KEY,
    nik              VARCHAR(16)  NOT NULL UNIQUE,
    nama_pasien      VARCHAR(100) NOT NULL,
    jenis_kelamin    ENUM('L','P') NOT NULL,
    tanggal_lahir    DATE         NOT NULL,
    alamat           VARCHAR(255),
    nama_keluarga    VARCHAR(100),
    telepon_keluarga VARCHAR(20),
    diagnosa_utama   VARCHAR(120),
    tingkat_risiko   ENUM('Rendah','Sedang','Tinggi','Isolasi') NOT NULL DEFAULT 'Rendah',
    status_rawat     ENUM('Rawat Inap','Rawat Jalan','Pulang') NOT NULL DEFAULT 'Rawat Inap',
    id_bangsal       INT NULL,
    id_dokter        INT NULL,
    tanggal_masuk    DATE         NOT NULL,
    tanggal_keluar   DATE NULL,
    FOREIGN KEY (id_bangsal) REFERENCES bangsal(id_bangsal) ON DELETE SET NULL,
    FOREIGN KEY (id_dokter)  REFERENCES users(id_user)      ON DELETE SET NULL
);

CREATE TABLE rekam_medis (
    id_rekam      INT AUTO_INCREMENT PRIMARY KEY,
    id_pasien     INT NOT NULL,
    id_petugas    INT NULL,
    waktu_catat   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    keluhan       TEXT,
    observasi     TEXT,
    diagnosa      VARCHAR(120),
    terapi        TEXT,
    tekanan_darah VARCHAR(10),
    nadi          INT NULL,
    suhu          DECIMAL(3,1) NULL,
    kondisi       ENUM('Membaik','Stabil','Memburuk') NOT NULL DEFAULT 'Stabil',
    FOREIGN KEY (id_pasien)  REFERENCES pasien(id_pasien) ON DELETE CASCADE,
    FOREIGN KEY (id_petugas) REFERENCES users(id_user)    ON DELETE SET NULL
);

-- ------------------------------ DATA AWAL ------------------------------
-- Akun login (password disimpan ter-hash SHA-256):
--   admin   / admin123
--   dokter  / dokter123
--   perawat / perawat123
INSERT INTO users (username, password, nama_lengkap, role) VALUES
('admin',   SHA2('admin123',256),   'Administrator Utama',        'Admin'),
('dokter',  SHA2('dokter123',256),  'dr. Aldi Pratama, Sp.KJ',    'Dokter'),
('dokter2', SHA2('dokter123',256),  'dr. Sinta Maharani, Sp.KJ',  'Dokter'),
('perawat', SHA2('perawat123',256), 'Ns. Rina Wulandari, S.Kep',  'Perawat');

INSERT INTO bangsal (nama_bangsal, jenis, kapasitas, keterangan) VALUES
('Bangsal Melati',  'Tenang',       30, 'Pasien stabil dalam tahap pemulihan'),
('Bangsal Mawar',   'Intermediate', 28, 'Observasi lanjutan dan terapi rutin'),
('Bangsal Anggrek', 'Akut',         24, 'Penanganan fase akut dengan pengawasan ketat'),
('Ruang Isolasi',   'Isolasi',      12, 'Pasien berisiko membahayakan diri sendiri atau orang lain');

INSERT INTO pasien (nik, nama_pasien, jenis_kelamin, tanggal_lahir, alamat, nama_keluarga, telepon_keluarga, diagnosa_utama, tingkat_risiko, status_rawat, id_bangsal, id_dokter, tanggal_masuk) VALUES
('3276010101900001','Budi Santoso','L','1990-01-01','Jl. Margonda Raya No. 12, Depok','Siti Santoso','081211110001','Skizofrenia paranoid','Tinggi','Rawat Inap',3,2,DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
('3276010202850002','Dewi Lestari','P','1985-02-02','Jl. Kemang Raya No. 7, Bogor','Agus Lestari','081211110002','Gangguan bipolar','Sedang','Rawat Inap',2,2,DATE_SUB(CURDATE(), INTERVAL 12 DAY)),
('3276010303780003','Hendra Wijaya','L','1978-03-03','Jl. Cinere Raya No. 3, Depok','Lina Wijaya','081211110003','Depresi mayor','Rendah','Rawat Inap',1,3,DATE_SUB(CURDATE(), INTERVAL 20 DAY)),
('3276010404950004','Maya Anggraini','P','1995-04-04','Jl. Sawangan No. 21, Depok','Dedi Anggraini','081211110004','Gangguan psikotik akut','Isolasi','Rawat Inap',4,3,DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
('3276010505880005','Rudi Hartono','L','1988-05-05','Jl. Raya Bogor Km 30, Depok','Tati Hartono','081211110005','Skizofrenia residual','Rendah','Rawat Jalan',NULL,2,DATE_SUB(CURDATE(), INTERVAL 40 DAY)),
('3276010606920006','Ani Setiawati','P','1992-06-06','Jl. Pemuda No. 9, Depok','Yoga Setiawan','081211110006','Gangguan kecemasan menyeluruh','Rendah','Pulang',NULL,3,DATE_SUB(CURDATE(), INTERVAL 60 DAY)),
('3276010707750007','Joko Susilo','L','1975-07-07','Jl. Juanda No. 45, Depok','Retno Susilo','081211110007','Gangguan skizoafektif','Sedang','Rawat Inap',2,2,DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
('3276010808990008','Putri Ramadhani','P','1999-08-08','Jl. Boulevard Grand Depok City','Hasan Ramadhani','081211110008','Gangguan stres pasca trauma','Sedang','Rawat Inap',1,3,DATE_SUB(CURDATE(), INTERVAL 15 DAY));

UPDATE pasien SET tanggal_keluar = DATE_SUB(CURDATE(), INTERVAL 30 DAY) WHERE status_rawat = 'Pulang';

INSERT INTO rekam_medis (id_pasien, id_petugas, waktu_catat, keluhan, observasi, diagnosa, terapi, tekanan_darah, nadi, suhu, kondisi) VALUES
(1,2,DATE_SUB(NOW(), INTERVAL 4 DAY),'Halusinasi pendengaran, gelisah','Pasien tampak waspada dan bicara sendiri','Skizofrenia paranoid','Haloperidol 5 mg 2x1, terapi kelompok','130/85',92,36.8,'Memburuk'),
(1,4,DATE_SUB(NOW(), INTERVAL 1 DAY),'Tidur terganggu','Lebih tenang setelah obat, masih curiga pada petugas','Skizofrenia paranoid','Lanjutkan terapi, pantau efek samping','125/80',84,36.6,'Stabil'),
(2,2,DATE_SUB(NOW(), INTERVAL 3 DAY),'Suasana hati naik turun','Bicara cepat, jam tidur berkurang','Gangguan bipolar','Lithium 400 mg 2x1','120/80',78,36.5,'Membaik'),
(4,3,DATE_SUB(NOW(), INTERVAL 1 DAY),'Agitasi berat, mengamuk','Perlu pengawasan 1:1','Gangguan psikotik akut','Injeksi haloperidol, observasi ketat','140/90',104,37.0,'Memburuk'),
(3,4,DATE_SUB(NOW(), INTERVAL 2 DAY),'Murung, nafsu makan menurun','Mulai mau berinteraksi dengan pasien lain','Depresi mayor','Sertraline 50 mg 1x1','118/76',72,36.4,'Membaik');
