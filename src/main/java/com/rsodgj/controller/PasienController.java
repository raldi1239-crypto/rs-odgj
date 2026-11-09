package com.rsodgj.controller;

import com.rsodgj.dao.BangsalDAO;
import com.rsodgj.dao.PasienDAO;
import com.rsodgj.dao.RekamMedisDAO;
import com.rsodgj.dao.UserDAO;
import com.rsodgj.model.Pasien;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/pasien")
public class PasienController extends HttpServlet {
    private static final int UKURAN_HALAMAN = 10;
    private static final List<String> RISIKO = Arrays.asList("Rendah", "Sedang", "Tinggi", "Isolasi");
    private static final List<String> STATUS = Arrays.asList("Rawat Inap", "Rawat Jalan", "Pulang");

    private final PasienDAO pasienDAO = new PasienDAO();
    private final BangsalDAO bangsalDAO = new BangsalDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RekamMedisDAO rekamDAO = new RekamMedisDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String aksi = Teks.bersih(req.getParameter("aksi"));
        switch (aksi) {
            case "tambah": formBaru(req, res); break;
            case "ubah": formUbah(req, res); break;
            case "detail": detail(req, res); break;
            default: daftar(req, res);
        }
    }

    private void daftar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String q = Teks.bersih(req.getParameter("q"));
        String risiko = RISIKO.contains(req.getParameter("risiko")) ? req.getParameter("risiko") : "";
        String status = STATUS.contains(req.getParameter("status")) ? req.getParameter("status") : "";
        int total = pasienDAO.hitung(q, risiko, status);
        int totalHalaman = Math.max(1, (int) Math.ceil(total / (double) UKURAN_HALAMAN));
        int halaman = Math.min(Rute.halaman(req.getParameter("hal")), totalHalaman);

        req.setAttribute("listPasien", pasienDAO.cari(q, risiko, status, "terbaru", (halaman - 1) * UKURAN_HALAMAN, UKURAN_HALAMAN));
        req.setAttribute("total", total);
        req.setAttribute("halaman", halaman);
        req.setAttribute("totalHalaman", totalHalaman);
        req.setAttribute("q", q);
        req.setAttribute("risiko", risiko);
        req.setAttribute("status", status);
        Rute.tampil(req, res, "admin/pasien_list");
    }

    private void siapkanForm(HttpServletRequest req) {
        req.setAttribute("listBangsal", bangsalDAO.semua());
        req.setAttribute("listDokter", userDAO.dokterAktif());
    }

    private void formBaru(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Pasien p = new Pasien();
        p.setTanggalMasuk(new java.sql.Date(System.currentTimeMillis()));
        p.setStatusRawat("Rawat Inap");
        p.setTingkatRisiko("Rendah");
        p.setJenisKelamin("L");
        req.setAttribute("pasien", p);
        siapkanForm(req);
        Rute.tampil(req, res, "admin/pasien_form");
    }

    private void formUbah(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Pasien p = pasienDAO.cari(Teks.toInt(req.getParameter("id"), 0));
        if (p == null) { Rute.gagal(req, "Data pasien tidak ditemukan."); res.sendRedirect(req.getContextPath() + "/admin/pasien"); return; }
        req.setAttribute("pasien", p);
        siapkanForm(req);
        Rute.tampil(req, res, "admin/pasien_form");
    }

    private void detail(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int id = Teks.toInt(req.getParameter("id"), 0);
        Pasien p = pasienDAO.cari(id);
        if (p == null) { Rute.gagal(req, "Data pasien tidak ditemukan."); res.sendRedirect(req.getContextPath() + "/admin/pasien"); return; }
        req.setAttribute("pasien", p);
        req.setAttribute("riwayat", rekamDAO.byPasien(id));
        Rute.tampil(req, res, "admin/pasien_detail");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String aksi = Teks.bersih(req.getParameter("aksi"));
        if ("hapus".equals(aksi)) {
            int id = Teks.toInt(req.getParameter("id"), 0);
            if (pasienDAO.hapus(id)) Rute.sukses(req, "Data pasien beserta rekam medisnya telah dihapus.");
            else Rute.gagal(req, "Data pasien tidak ditemukan.");
            res.sendRedirect(req.getContextPath() + "/admin/pasien");
            return;
        }
        simpan(req, res);
    }

    private void simpan(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int id = Teks.toInt(req.getParameter("id"), 0);
        boolean baru = id == 0;

        Pasien p = new Pasien();
        p.setIdPasien(id);
        p.setNik(Teks.bersih(req.getParameter("nik")));
        p.setNamaPasien(Teks.bersih(req.getParameter("namaPasien")));
        p.setJenisKelamin(Teks.bersih(req.getParameter("jenisKelamin")));
        p.setTanggalLahir(Teks.toDate(req.getParameter("tanggalLahir")));
        p.setAlamat(Teks.atauNull(req.getParameter("alamat")));
        p.setNamaKeluarga(Teks.atauNull(req.getParameter("namaKeluarga")));
        p.setTeleponKeluarga(Teks.atauNull(req.getParameter("teleponKeluarga")));
        p.setDiagnosaUtama(Teks.atauNull(req.getParameter("diagnosaUtama")));
        p.setTingkatRisiko(Teks.bersih(req.getParameter("tingkatRisiko")));
        p.setStatusRawat(Teks.bersih(req.getParameter("statusRawat")));
        p.setIdBangsal(Teks.toIntObj(req.getParameter("idBangsal")));
        p.setIdDokter(Teks.toIntObj(req.getParameter("idDokter")));
        p.setTanggalMasuk(Teks.toDate(req.getParameter("tanggalMasuk")));
        p.setTanggalKeluar(Teks.toDate(req.getParameter("tanggalKeluar")));

        String error = validasi(p);
        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("pasien", p);
            siapkanForm(req);
            Rute.tampil(req, res, "admin/pasien_form");
            return;
        }

        // aturan bisnis menurut status rawat
        if ("Rawat Inap".equals(p.getStatusRawat())) {
            p.setTanggalKeluar(null);
        } else {
            p.setIdBangsal(null);
            if ("Pulang".equals(p.getStatusRawat())) {
                if (p.getTanggalKeluar() == null) p.setTanggalKeluar(new java.sql.Date(System.currentTimeMillis()));
            } else {
                p.setTanggalKeluar(null);
            }
        }

        if (baru) pasienDAO.tambah(p); else pasienDAO.ubah(p);
        Rute.sukses(req, baru ? "Pasien " + p.getNamaPasien() + " berhasil didaftarkan." : "Data pasien berhasil diperbarui.");
        res.sendRedirect(req.getContextPath() + "/admin/pasien");
    }

    private String validasi(Pasien p) {
        if (!p.getNik().matches("\\d{16}")) return "NIK harus terdiri dari 16 digit angka.";
        if (p.getNamaPasien().length() < 3) return "Nama pasien minimal 3 karakter.";
        if (!"L".equals(p.getJenisKelamin()) && !"P".equals(p.getJenisKelamin())) return "Pilih jenis kelamin.";
        if (p.getTanggalLahir() == null) return "Tanggal lahir belum diisi dengan benar.";
        if (p.getTanggalLahir().after(new java.util.Date())) return "Tanggal lahir tidak boleh di masa depan.";
        if (p.getTanggalMasuk() == null) return "Tanggal masuk belum diisi dengan benar.";
        if (!RISIKO.contains(p.getTingkatRisiko())) return "Tingkat risiko tidak valid.";
        if (!STATUS.contains(p.getStatusRawat())) return "Status rawat tidak valid.";
        if (p.getTeleponKeluarga() != null && !p.getTeleponKeluarga().matches("[0-9+\\-\\s]{6,20}")) return "Nomor telepon keluarga tidak valid.";
        if (p.getTanggalKeluar() != null && p.getTanggalKeluar().before(p.getTanggalMasuk())) return "Tanggal keluar tidak boleh lebih awal dari tanggal masuk.";
        if (pasienDAO.nikAda(p.getNik(), p.getIdPasien())) return "NIK " + p.getNik() + " sudah terdaftar atas pasien lain.";

        if ("Rawat Inap".equals(p.getStatusRawat())) {
            if (p.getIdBangsal() == null) return "Pilih bangsal untuk pasien rawat inap.";
            com.rsodgj.model.Bangsal b = bangsalDAO.cari(p.getIdBangsal());
            if (b == null) return "Bangsal tidak ditemukan.";
            if (bangsalDAO.terisi(b.getIdBangsal(), p.getIdPasien()) >= b.getKapasitas())
                return b.getNamaBangsal() + " sudah penuh (" + b.getKapasitas() + " tempat tidur). Pilih bangsal lain.";
        }
        return null;
    }
}
