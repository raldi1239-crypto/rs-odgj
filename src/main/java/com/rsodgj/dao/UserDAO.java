package com.rsodgj.dao;

import com.rsodgj.config.KoneksiDB;
import com.rsodgj.model.User;
import com.rsodgj.util.Sandi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private User map(ResultSet rs) throws Exception {
        User u = new User();
        u.setIdUser(rs.getInt("id_user"));
        u.setUsername(rs.getString("username"));
        u.setNamaLengkap(rs.getString("nama_lengkap"));
        u.setRole(rs.getString("role"));
        u.setStatusAktif(rs.getBoolean("status_aktif"));
        u.setDibuatPada(rs.getTimestamp("dibuat_pada"));
        return u;
    }

    /** Mengembalikan user jika username/password cocok dan akun aktif, selain itu null. */
    public User autentikasi(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND status_aktif = TRUE";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, username);
            p.setString(2, Sandi.hash(password));
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (Exception e) { throw new RuntimeException("Gagal mengakses database: " + e.getMessage(), e); }
    }

    public List<User> semua() {
        List<User> list = new ArrayList<>();
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT * FROM users ORDER BY FIELD(role,'Admin','Dokter','Perawat'), nama_lengkap");
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public List<User> dokterAktif() {
        List<User> list = new ArrayList<>();
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT * FROM users WHERE role='Dokter' AND status_aktif=TRUE ORDER BY nama_lengkap");
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    public boolean usernameAda(String username) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT 1 FROM users WHERE username = ?")) {
            p.setString(1, username);
            try (ResultSet rs = p.executeQuery()) { return rs.next(); }
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean tambah(String username, String password, String nama, String role) {
        String sql = "INSERT INTO users (username, password, nama_lengkap, role) VALUES (?,?,?,?)";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, username);
            p.setString(2, Sandi.hash(password));
            p.setString(3, nama);
            p.setString(4, role);
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean setAktif(int id, boolean aktif) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("UPDATE users SET status_aktif = ? WHERE id_user = ?")) {
            p.setBoolean(1, aktif);
            p.setInt(2, id);
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean resetPassword(int id, String passwordBaru) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("UPDATE users SET password = ? WHERE id_user = ?")) {
            p.setString(1, Sandi.hash(passwordBaru));
            p.setInt(2, id);
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    /** Ganti password sendiri; password lama harus benar. */
    public boolean gantiPassword(int id, String lama, String baru) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("UPDATE users SET password = ? WHERE id_user = ? AND password = ?")) {
            p.setString(1, Sandi.hash(baru));
            p.setInt(2, id);
            p.setString(3, Sandi.hash(lama));
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public boolean ubahNama(int id, String nama) {
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement p = c.prepareStatement("UPDATE users SET nama_lengkap = ? WHERE id_user = ?")) {
            p.setString(1, nama);
            p.setInt(2, id);
            return p.executeUpdate() > 0;
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
