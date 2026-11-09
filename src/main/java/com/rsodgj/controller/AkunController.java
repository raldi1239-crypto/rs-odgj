package com.rsodgj.controller;

import com.rsodgj.dao.UserDAO;
import com.rsodgj.model.User;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/akun")
public class AkunController extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Rute.tampil(req, res, "akun/profil");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        User saya = (User) session.getAttribute("userAktif");
        String aksi = Teks.bersih(req.getParameter("aksi"));

        if ("nama".equals(aksi)) {
            String nama = Teks.bersih(req.getParameter("namaLengkap"));
            if (nama.length() < 3) Rute.gagal(req, "Nama lengkap minimal 3 karakter.");
            else { dao.ubahNama(saya.getIdUser(), nama); saya.setNamaLengkap(nama); Rute.sukses(req, "Nama berhasil diperbarui."); }
        } else if ("sandi".equals(aksi)) {
            String lama = req.getParameter("lama") == null ? "" : req.getParameter("lama");
            String baru = req.getParameter("baru") == null ? "" : req.getParameter("baru");
            String ulang = req.getParameter("ulang") == null ? "" : req.getParameter("ulang");
            if (baru.length() < 6) Rute.gagal(req, "Password baru minimal 6 karakter.");
            else if (!baru.equals(ulang)) Rute.gagal(req, "Konfirmasi password tidak sama.");
            else if (!dao.gantiPassword(saya.getIdUser(), lama, baru)) Rute.gagal(req, "Password lama tidak sesuai.");
            else Rute.sukses(req, "Password berhasil diganti.");
        }
        res.sendRedirect(req.getContextPath() + "/akun");
    }
}
