package com.rsodgj.dao;

import com.rsodgj.config.KoneksiDB;
import com.rsodgj.model.RekamMedis;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class RekamMedisDAO {

    private static final String SELECT =
        "SELECT r.*, pa.nama_pasien, u.nama_lengkap AS nama_petugas, u.role AS role_petugas FROM rekam_medis r " +
        "JOIN pasien pa ON r.id_pasien = pa.id_pasien LEFT JOIN users u ON r.id_petugas = u.id_user";

    private RekamMedis map(ResultSet rs) throws Exception {
        RekamMedis r = new RekamMedis();
        r.setIdRekam(rs.getInt("id_rekam"));
        r.setIdPasien(rs.getInt("id_pasien"));
        r.setNamaPasien(rs.getString("nama_pasien"));
        r.setNamaPetugas(rs.getString("nama_petugas"));
        r.setRolePetugas(rs.getString("role_petugas"));
        r.setWaktuCatat(rs.getTimestamp("waktu_catat"));
        r.setKeluhan(rs.getString("keluhan"));
        r.setObservasi(rs.getString("observasi"));
        r.setDiagnosa(rs.getString("diagnosa"));
        r.setTerapi(rs.getString("terapi"));
        r.setTekananDarah(rs.getString("tekanan_darah"));
        int nadi = rs.getInt("nadi");
        r.setNadi(rs.wasNull() ? null : nadi);
        r.setSuhu(rs.getBigDecimal("suhu"));
        r.setKondisi(rs.getString("kondisi"));
        return r;
    }

    public List<RekamMedis> byPasien(int idPasien) {
        List<RekamMedis> list = new ArrayList<>();
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + " WHERE r.id_pasien = ? ORDER BY r.waktu_catat DESC, r.id_rekam DESC")) {
            ps.setInt(1, idPasien);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public List<RekamMedis> terbaru(int limit) {
        List<RekamMedis> list = new ArrayList<>();
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + " ORDER BY r.waktu_catat DESC, r.id_rekam DESC LIMIT " + limit);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public boolean tambah(RekamMedis r, int idPetugas) {
        String sql = "INSERT INTO rekam_medis (id_pasien, id_petugas, keluhan, observasi, diagnosa, terapi, tekanan_darah, nadi, suhu, kondisi) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, r.getIdPasien());
            ps.setInt(2, idPetugas);
            ps.setString(3, r.getKeluhan());
            ps.setString(4, r.getObservasi());
            ps.setString(5, r.getDiagnosa());
            ps.setString(6, r.getTerapi());
            ps.setString(7, r.getTekananDarah());
            if (r.getNadi() == null) ps.setNull(8, Types.INTEGER); else ps.setInt(8, r.getNadi());
            if (r.getSuhu() == null) ps.setNull(9, Types.DECIMAL); else ps.setBigDecimal(9, r.getSuhu());
            ps.setString(10, r.getKondisi());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
