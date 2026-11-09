package com.rsodgj.dao;

import com.rsodgj.config.KoneksiDB;
import com.rsodgj.model.Ringkasan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/** Menghimpun angka-angka untuk dashboard. */
public class RingkasanDAO {

    private static final String[] BULAN = {"Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"};

    private int satu(Connection c, String sql) throws Exception {
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public Ringkasan ambil() {
        Ringkasan r = new Ringkasan();
        try (Connection c = KoneksiDB.getConnection()) {
            r.setTotalPasien(satu(c, "SELECT COUNT(*) FROM pasien"));
            r.setRawatInap(satu(c, "SELECT COUNT(*) FROM pasien WHERE status_rawat='Rawat Inap'"));
            r.setRawatJalan(satu(c, "SELECT COUNT(*) FROM pasien WHERE status_rawat='Rawat Jalan'"));
            r.setPulang(satu(c, "SELECT COUNT(*) FROM pasien WHERE status_rawat='Pulang'"));
            r.setPasienBerisiko(satu(c, "SELECT COUNT(*) FROM pasien WHERE status_rawat<>'Pulang' AND tingkat_risiko IN ('Tinggi','Isolasi')"));
            r.setKapasitas(satu(c, "SELECT COALESCE(SUM(kapasitas),0) FROM bangsal"));
            r.setTerisi(satu(c, "SELECT COUNT(*) FROM pasien WHERE status_rawat='Rawat Inap' AND id_bangsal IS NOT NULL"));
            r.setMasukBulanIni(satu(c, "SELECT COUNT(*) FROM pasien WHERE YEAR(tanggal_masuk)=YEAR(CURDATE()) AND MONTH(tanggal_masuk)=MONTH(CURDATE())"));
            r.setCatatanHariIni(satu(c, "SELECT COUNT(*) FROM rekam_medis WHERE DATE(waktu_catat)=CURDATE()"));

            Map<String, Integer> risiko = new LinkedHashMap<>();
            for (String k : new String[]{"Rendah", "Sedang", "Tinggi", "Isolasi"}) risiko.put(k, 0);
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT tingkat_risiko, COUNT(*) FROM pasien WHERE status_rawat<>'Pulang' GROUP BY tingkat_risiko");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) risiko.put(rs.getString(1), rs.getInt(2));
            }
            r.setRisiko(risiko);

            // tren pasien masuk 6 bulan terakhir
            Map<String, Integer> tren = new LinkedHashMap<>();
            Map<String, String> kunci = new LinkedHashMap<>();
            LocalDate now = LocalDate.now().withDayOfMonth(1);
            for (int i = 5; i >= 0; i--) {
                LocalDate d = now.minusMonths(i);
                String k = String.format("%d-%02d", d.getYear(), d.getMonthValue());
                kunci.put(k, BULAN[d.getMonthValue() - 1]);
                tren.put(BULAN[d.getMonthValue() - 1], 0);
            }
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT DATE_FORMAT(tanggal_masuk,'%Y-%m') ym, COUNT(*) FROM pasien " +
                    "WHERE tanggal_masuk >= DATE_SUB(DATE_FORMAT(CURDATE(),'%Y-%m-01'), INTERVAL 5 MONTH) GROUP BY ym");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String label = kunci.get(rs.getString(1));
                    if (label != null) tren.put(label, rs.getInt(2));
                }
            }
            r.setTren(tren);
        } catch (Exception e) { throw new RuntimeException(e); }
        return r;
    }
}
