package com.rsodgj.controller;

import com.rsodgj.dao.PasienDAO;
import com.rsodgj.dao.RekamMedisDAO;
import com.rsodgj.model.Pasien;
import com.rsodgj.model.RekamMedis;
import com.rsodgj.model.User;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

@WebServlet("/klinis/pasien")
public class KlinisPasienController extends HttpServlet {
    private static final int UKURAN_HALAMAN = 12;
    private static final List<String> RISIKO = Arrays.asList("Rendah", "Sedang", "Tinggi", "Isolasi");
    private static final List<String> STATUS = Arrays.asList("Rawat Inap", "Rawat Jalan", "Pulang");
    private static final List<String> KONDISI = Arrays.asList("Membaik", "Stabil", "Memburuk");

    private final PasienDAO pasienDAO = new PasienDAO();
    private final RekamMedisDAO rekamDAO = new RekamMedisDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int id = Teks.toInt(req.getParameter("id"), 0);
        if (id > 0) detail(req, res, id); else daftar(req, res);
    }

    private void daftar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String q = Teks.bersih(req.getParameter("q"));
        String risiko = RISIKO.contains(req.getParameter("risiko")) ? req.getParameter("risiko") : "";
        String status = STATUS.contains(req.getParameter("status")) ? req.getParameter("status") : "";
        int total = pasienDAO.hitung(q, risiko, status);
        int totalHalaman = Math.max(1, (int) Math.ceil(total / (double) UKURAN_HALAMAN));
        int halaman = Math.min(Rute.halaman(req.getParameter("hal")), totalHalaman);

        req.setAttribute("listPasien", pasienDAO.cari(q, risiko, status, "risiko", (halaman - 1) * UKURAN_HALAMAN, UKURAN_HALAMAN));
        req.setAttribute("total", total);
        req.setAttribute("halaman", halaman);
        req.setAttribute("totalHalaman", totalHalaman);
        req.setAttribute("q", q);
        req.setAttribute("risiko", risiko);
        req.setAttribute("status", status);
        Rute.tampil(req, res, "klinis/pasien_list");
    }

    private void detail(HttpServletRequest req, HttpServletResponse res, int id) throws ServletException, IOException {
        Pasien p = pasienDAO.cari(id);
        if (p == null) { Rute.gagal(req, "Data pasien tidak ditemukan."); res.sendRedirect(req.getContextPath() + "/klinis/pasien"); return; }
        req.setAttribute("pasien", p);
        req.setAttribute("riwayat", rekamDAO.byPasien(id));
        Rute.tampil(req, res, "klinis/pasien_detail");
    }

    /** Menyimpan catatan rekam medis baru. */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        User saya = (User) req.getSession().getAttribute("userAktif");
        int id = Teks.toInt(req.getParameter("idPasien"), 0);
        Pasien p = pasienDAO.cari(id);
        String kembali = req.getContextPath() + "/klinis/pasien?id=" + id;
        if (p == null) { Rute.gagal(req, "Data pasien tidak ditemukan."); res.sendRedirect(req.getContextPath() + "/klinis/pasien"); return; }

        RekamMedis r = new RekamMedis();
        r.setIdPasien(id);
        r.setKeluhan(Teks.atauNull(req.getParameter("keluhan")));
        r.setObservasi(Teks.atauNull(req.getParameter("observasi")));
        r.setDiagnosa(Teks.atauNull(req.getParameter("diagnosa")));
        r.setTerapi(Teks.atauNull(req.getParameter("terapi")));
        r.setTekananDarah(Teks.atauNull(req.getParameter("tekananDarah")));
        r.setNadi(Teks.toIntObj(req.getParameter("nadi")));
        r.setKondisi(Teks.bersih(req.getParameter("kondisi")));
        String suhuStr = Teks.bersih(req.getParameter("suhu")).replace(',', '.');
        try { r.setSuhu(suhuStr.isEmpty() ? null : new BigDecimal(suhuStr)); } catch (NumberFormatException e) { r.setSuhu(new BigDecimal("-1")); }

        String error = null;
        if (r.getKeluhan() == null && r.getObservasi() == null) error = "Isi minimal keluhan atau hasil observasi.";
        else if (!KONDISI.contains(r.getKondisi())) error = "Pilih kondisi pasien.";
        else if (r.getTekananDarah() != null && !r.getTekananDarah().matches("\\d{2,3}/\\d{2,3}")) error = "Format tekanan darah harus seperti 120/80.";
        else if (r.getNadi() != null && (r.getNadi() < 20 || r.getNadi() > 250)) error = "Nadi harus antara 20 dan 250 kali per menit.";
        else if (r.getSuhu() != null && (r.getSuhu().compareTo(new BigDecimal("30")) < 0 || r.getSuhu().compareTo(new BigDecimal("45")) > 0)) error = "Suhu tubuh harus antara 30 dan 45 °C.";

        if (error != null) { Rute.gagal(req, error); res.sendRedirect(kembali + "#catatan-baru"); return; }

        rekamDAO.tambah(r, saya.getIdUser());

        // hanya dokter yang boleh memperbarui tingkat risiko
        String risiko = Teks.bersih(req.getParameter("tingkatRisiko"));
        if ("Dokter".equals(saya.getRole()) && RISIKO.contains(risiko) && !risiko.equals(p.getTingkatRisiko())) {
            pasienDAO.ubahRisiko(id, risiko);
        }
        Rute.sukses(req, "Catatan rekam medis berhasil disimpan.");
        res.sendRedirect(kembali);
    }
}
