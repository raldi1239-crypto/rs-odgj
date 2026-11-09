package com.rsodgj.dao;

import com.rsodgj.config.KoneksiDB;
import com.rsodgj.model.Bangsal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BangsalDAO {

    private static final String SELECT =
        "SELECT b.*, (SELECT COUNT(*) FROM pasien p WHERE p.id_bangsal = b.id_bangsal AND p.status_rawat = 'Rawat Inap') AS terisi FROM bangsal b";

    private Bangsal map(ResultSet rs) throws Exception {
        Bangsal b = new Bangsal();
        b.setIdBangsal(rs.getInt("id_bangsal"));
        b.setNamaBangsal(rs.getString("nama_bangsal"));
        b.setJenis(rs.getString("jenis"));
        b.setKapasitas(rs.getInt("kapasitas"));
        b.setKeterangan(rs.getString("keterangan"));
        b.setTerisi(rs.getInt("terisi"));
        return b;
    }

    public List<Bangsal> semua() {
        List<Bangsal> list = new ArrayList<>();
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement(SELECT + " ORDER BY b.nama_bangsal");
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public Bangsal cari(int id) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement(SELECT + " WHERE b.id_bangsal = ?")) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) { return rs.next() ? map(rs) : null; }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean namaAda(String nama, int kecualiId) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT 1 FROM bangsal WHERE nama_bangsal = ? AND id_bangsal <> ?")) {
            p.setString(1, nama);
            p.setInt(2, kecualiId);
            try (ResultSet rs = p.executeQuery()) { return rs.next(); }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean tambah(Bangsal b) {
        String sql = "INSERT INTO bangsal (nama_bangsal, jenis, kapasitas, keterangan) VALUES (?,?,?,?)";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, b.getNamaBangsal());
            p.setString(2, b.getJenis());
            p.setInt(3, b.getKapasitas());
            p.setString(4, b.getKeterangan());
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean ubah(Bangsal b) {
        String sql = "UPDATE bangsal SET nama_bangsal=?, jenis=?, kapasitas=?, keterangan=? WHERE id_bangsal=?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, b.getNamaBangsal());
            p.setString(2, b.getJenis());
            p.setInt(3, b.getKapasitas());
            p.setString(4, b.getKeterangan());
            p.setInt(5, b.getIdBangsal());
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean hapus(int id) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("DELETE FROM bangsal WHERE id_bangsal = ?")) {
            p.setInt(1, id);
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    /** Jumlah pasien rawat inap di bangsal, tidak menghitung pasien tertentu (untuk proses ubah data). */
    public int terisi(int idBangsal, int kecualiPasien) {
        String sql = "SELECT COUNT(*) FROM pasien WHERE id_bangsal = ? AND status_rawat = 'Rawat Inap' AND id_pasien <> ?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, idBangsal);
            p.setInt(2, kecualiPasien);
            try (ResultSet rs = p.executeQuery()) { rs.next(); return rs.getInt(1); }
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
