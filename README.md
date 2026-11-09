# RS ODGJ - Sistem Informasi Rumah Sakit

Aplikasi web (Java Servlet + JSP + MySQL) untuk Rumah Sakit Orang Dengan Gangguan Jiwa.

## Kebutuhan
- JDK 8+ dan Maven
- Apache Tomcat 9 (javax.servlet)
- MySQL / MariaDB
- Koneksi internet (Tailwind, Font Awesome, Google Fonts dimuat dari CDN)

## Cara menjalankan
1. Import `database/db_rs_odgj.sql` ke MySQL.
2. Jika perlu, ubah akses DB lewat environment variable `DB_URL`, `DB_USER`, `DB_PASS`
   (bawaan: root tanpa password di localhost:3306).
3. `mvn clean package` lalu salin `target/rs-odgj.war` ke folder `webapps` Tomcat 9.
4. Buka http://localhost:8080/rs-odgj/

## Akun contoh
| Peran   | Username | Password    |
|---------|----------|-------------|
| Admin   | admin    | admin123    |
| Dokter  | dokter   | dokter123   |
| Perawat | perawat  | perawat123  |

Segera ganti password lewat menu Akun saya.

## Fitur
**Admin**: dashboard (peta tempat tidur, distribusi risiko, tren pasien), data pasien (cari, filter, paginasi,
tambah/ubah/hapus, detail, ekspor CSV), bangsal (kapasitas dan hunian), laporan periode (cetak),
manajemen pengguna (tambah, aktif/nonaktif, reset password).

**Dokter dan Perawat**: dashboard prioritas pasien, daftar pasien berurutan menurut risiko, rekam medis
(tanda vital, keluhan, observasi, diagnosa, terapi, kondisi). Dokter dapat memperbarui tingkat risiko.

**Keamanan**: password ter-hash SHA-256, akses per peran, token CSRF, perlindungan session fixation,
output di-escape (anti XSS), halaman terproteksi tidak di-cache, semua query memakai PreparedStatement.
