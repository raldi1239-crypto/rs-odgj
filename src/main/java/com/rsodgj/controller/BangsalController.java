package com.rsodgj.controller;

import com.rsodgj.dao.BangsalDAO;
import com.rsodgj.model.Bangsal;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/bangsal")
public class BangsalController extends HttpServlet {
    private static final List<String> JENIS = Arrays.asList("Tenang", "Intermediate", "Akut", "Isolasi");
    private final BangsalDAO dao = new BangsalDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("listBangsal", dao.semua());
        Rute.tampil(req, res, "admin/bangsal");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String aksi = Teks.bersih(req.getParameter("aksi"));
        int id = Teks.toInt(req.getParameter("id"), 0);
        String kembali = req.getContextPath() + "/admin/bangsal";

        if ("hapus".equals(aksi)) {
            Bangsal b = dao.cari(id);
            if (b == null) Rute.gagal(req, "Bangsal tidak ditemukan.");
            else if (b.getTerisi() > 0) Rute.gagal(req, b.getNamaBangsal() + " masih dihuni " + b.getTerisi() + " pasien. Pindahkan pasien terlebih dahulu.");
            else { dao.hapus(id); Rute.sukses(req, b.getNamaBangsal() + " berhasil dihapus."); }
            res.sendRedirect(kembali);
            return;
        }

        Bangsal b = new Bangsal();
        b.setIdBangsal(id);
        b.setNamaBangsal(Teks.bersih(req.getParameter("namaBangsal")));
        b.setJenis(Teks.bersih(req.getParameter("jenis")));
        b.setKapasitas(Teks.toInt(req.getParameter("kapasitas"), 0));
        b.setKeterangan(Teks.atauNull(req.getParameter("keterangan")));

        String error = null;
        if (b.getNamaBangsal().length() < 3) error = "Nama bangsal minimal 3 karakter.";
        else if (!JENIS.contains(b.getJenis())) error = "Jenis bangsal tidak valid.";
        else if (b.getKapasitas() < 1 || b.getKapasitas() > 500) error = "Kapasitas harus antara 1 dan 500 tempat tidur.";
        else if (dao.namaAda(b.getNamaBangsal(), id)) error = "Nama bangsal sudah dipakai.";
        else if (id > 0) {
            Bangsal lama = dao.cari(id);
            if (lama == null) error = "Bangsal tidak ditemukan.";
            else if (b.getKapasitas() < lama.getTerisi()) error = "Kapasitas tidak boleh di bawah jumlah pasien yang sedang dirawat (" + lama.getTerisi() + ").";
        }

        if (error != null) { Rute.gagal(req, error); res.sendRedirect(kembali); return; }
        if (id == 0) { dao.tambah(b); Rute.sukses(req, b.getNamaBangsal() + " berhasil ditambahkan."); }
        else { dao.ubah(b); Rute.sukses(req, "Data " + b.getNamaBangsal() + " berhasil diperbarui."); }
        res.sendRedirect(kembali);
    }
}
