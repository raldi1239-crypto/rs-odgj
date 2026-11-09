package com.rsodgj.dao;

import com.rsodgj.config.KoneksiDB;
import com.rsodgj.model.Pasien;
import com.rsodgj.util.Teks;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PasienDAO {

    private static final String SELECT =
        "SELECT p.*, b.nama_bangsal, u.nama_lengkap AS nama_dokter FROM pasien p " +
        "LEFT JOIN bangsal b ON p.id_bangsal = b.id_bangsal " +
        "LEFT JOIN users u ON p.id_dokter = u.id_user";

    private static final String FROM_COUNT = "SELECT COUNT(*) FROM pasien p";

    private Pasien map(ResultSet rs) throws Exception {
        Pasien p = new Pasien();
        p.setIdPasien(rs.getInt("id_pasien"));
        p.setNik(rs.getString("nik"));
        p.setNamaPasien(rs.getString("nama_pasien"));
        p.setJenisKelamin(rs.getString("jenis_kelamin"));
        p.setTanggalLahir(rs.getDate("tanggal_lahir"));
        p.setAlamat(rs.getString("alamat"));
        p.setNamaKeluarga(rs.getString("nama_keluarga"));
        p.setTeleponKeluarga(rs.getString("telepon_keluarga"));
        p.setDiagnosaUtama(rs.getString("diagnosa_utama"));
        p.setTingkatRisiko(rs.getString("tingkat_risiko"));
        p.setStatusRawat(rs.getString("status_rawat"));
        int b = rs.getInt("id_bangsal");
        p.setIdBangsal(rs.wasNull() ? null : b);
        int d = rs.getInt("id_dokter");
        p.setIdDokter(rs.wasNull() ? null : d);
        p.setTanggalMasuk(rs.getDate("tanggal_masuk"));
        p.setTanggalKeluar(rs.getDate("tanggal_keluar"));
        p.setNamaBangsal(rs.getString("nama_bangsal"));
        p.setNamaDokter(rs.getString("nama_dokter"));
        return p;
    }

    private String where(String q, String risiko, String status, List<Object> params) {
        StringBuilder w = new StringBuilder(" WHERE 1=1");
        if (q != null && !q.isEmpty()) {
            w.append(" AND (p.nama_pasien LIKE ? OR p.nik LIKE ? OR CONCAT('RM-', LPAD(p.id_pasien, 6, '0')) LIKE ? OR p.diagnosa_utama LIKE ?)");
            String like = "%" + q + "%";
            params.add(like); params.add(like); params.add(like); params.add(like);
        }
        if (risiko != null && !risiko.isEmpty()) { w.append(" AND p.tingkat_risiko = ?"); params.add(risiko); }
        if (status != null && !status.isEmpty()) { w.append(" AND p.status_rawat = ?"); params.add(status); }
        return w.toString();
    }

    private void isi(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
    }

    private String urutan(String urut) {
        if ("risiko".equals(urut)) {
            return " ORDER BY (p.status_rawat = 'Pulang'), FIELD(p.tingkat_risiko,'Isolasi','Tinggi','Sedang','Rendah'), p.tanggal_masuk DESC";
        }
        return " ORDER BY p.tanggal_masuk DESC, p.id_pasien DESC";
    }

    public int hitung(String q, String risiko, String status) {
        List<Object> params = new ArrayList<>();
        String sql = FROM_COUNT + where(q, risiko, status, params);
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            isi(ps, params);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    /** limit <= 0 berarti tanpa batas (dipakai untuk ekspor). */
    public List<Pasien> cari(String q, String risiko, String status, String urut, int offset, int limit) {
        List<Object> params = new ArrayList<>();
        String sql = SELECT + where(q, risiko, status, params) + urutan(urut);
        if (limit > 0) sql += " LIMIT " + limit + " OFFSET " + Math.max(0, offset);
        List<Pasien> list = new ArrayList<>();
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            isi(ps, params);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public Pasien cari(int id) {
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(SELECT + " WHERE p.id_pasien = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? map(rs) : null; }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public List<Pasien> terbaru(int limit) {
        return cari(null, null, null, "terbaru", 0, limit);
    }

    /** Pasien yang masuk pada rentang tanggal (untuk laporan). */
    public List<Pasien> masukPada(java.sql.Date dari, java.sql.Date sampai) {
        List<Pasien> list = new ArrayList<>();
        String sql = SELECT + " WHERE p.tanggal_masuk BETWEEN ? AND ? ORDER BY p.tanggal_masuk DESC, p.id_pasien DESC";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, dari);
            ps.setDate(2, sampai);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public boolean nikAda(String nik, int kecualiId) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT 1 FROM pasien WHERE nik = ? AND id_pasien <> ?")) {
            ps.setString(1, nik);
            ps.setInt(2, kecualiId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    private void isiForm(PreparedStatement ps, Pasien p) throws Exception {
        ps.setString(1, p.getNik());
        ps.setString(2, p.getNamaPasien());
        ps.setString(3, p.getJenisKelamin());
        ps.setDate(4, p.getTanggalLahir());
        ps.setString(5, p.getAlamat());
        ps.setString(6, p.getNamaKeluarga());
        ps.setString(7, p.getTeleponKeluarga());
        ps.setString(8, p.getDiagnosaUtama());
        ps.setString(9, p.getTingkatRisiko());
        ps.setString(10, p.getStatusRawat());
        if (p.getIdBangsal() == null) ps.setNull(11, Types.INTEGER); else ps.setInt(11, p.getIdBangsal());
        if (p.getIdDokter() == null) ps.setNull(12, Types.INTEGER); else ps.setInt(12, p.getIdDokter());
        ps.setDate(13, p.getTanggalMasuk());
        ps.setDate(14, p.getTanggalKeluar());
    }

    public boolean tambah(Pasien p) {
        String sql = "INSERT INTO pasien (nik, nama_pasien, jenis_kelamin, tanggal_lahir, alamat, nama_keluarga, telepon_keluarga, " +
                     "diagnosa_utama, tingkat_risiko, status_rawat, id_bangsal, id_dokter, tanggal_masuk, tanggal_keluar) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            isiForm(ps, p);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean ubah(Pasien p) {
        String sql = "UPDATE pasien SET nik=?, nama_pasien=?, jenis_kelamin=?, tanggal_lahir=?, alamat=?, nama_keluarga=?, telepon_keluarga=?, " +
                     "diagnosa_utama=?, tingkat_risiko=?, status_rawat=?, id_bangsal=?, id_dokter=?, tanggal_masuk=?, tanggal_keluar=? WHERE id_pasien=?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            isiForm(ps, p);
            ps.setInt(15, p.getIdPasien());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean hapus(int id) {
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement("DELETE FROM pasien WHERE id_pasien = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    /** Jumlah pasien aktif (belum pulang) yang ditangani seorang dokter. */
    public int hitungDitangani(int idDokter) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM pasien WHERE id_dokter = ? AND status_rawat <> 'Pulang'")) {
            ps.setInt(1, idDokter);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean ubahRisiko(int idPasien, String risiko) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE pasien SET tingkat_risiko = ? WHERE id_pasien = ?")) {
            ps.setString(1, risiko);
            ps.setInt(2, idPasien);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
