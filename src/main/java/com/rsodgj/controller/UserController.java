package com.rsodgj.controller;

import com.rsodgj.dao.UserDAO;
import com.rsodgj.model.User;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/pengguna")
public class UserController extends HttpServlet {
    private static final List<String> ROLE = Arrays.asList("Admin", "Dokter", "Perawat");
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("listUser", dao.semua());
        Rute.tampil(req, res, "admin/pengguna");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        User saya = (User) req.getSession().getAttribute("userAktif");
        String aksi = Teks.bersih(req.getParameter("aksi"));
        int id = Teks.toInt(req.getParameter("id"), 0);
        String kembali = req.getContextPath() + "/admin/pengguna";

        switch (aksi) {
            case "tambah": {
                String username = Teks.bersih(req.getParameter("username"));
                String nama = Teks.bersih(req.getParameter("namaLengkap"));
                String role = Teks.bersih(req.getParameter("role"));
                String sandi = req.getParameter("password") == null ? "" : req.getParameter("password");
                if (!username.matches("[A-Za-z0-9_.]{3,30}")) Rute.gagal(req, "Username 3-30 karakter, hanya huruf, angka, titik, dan garis bawah.");
                else if (nama.length() < 3) Rute.gagal(req, "Nama lengkap minimal 3 karakter.");
                else if (!ROLE.contains(role)) Rute.gagal(req, "Peran tidak valid.");
                else if (sandi.length() < 6) Rute.gagal(req, "Password minimal 6 karakter.");
                else if (dao.usernameAda(username)) Rute.gagal(req, "Username \"" + username + "\" sudah dipakai.");
                else { dao.tambah(username, sandi, nama, role); Rute.sukses(req, "Akun " + username + " berhasil dibuat."); }
                break;
            }
            case "status": {
                if (id == saya.getIdUser()) Rute.gagal(req, "Anda tidak dapat menonaktifkan akun yang sedang dipakai.");
                else {
                    boolean aktif = "1".equals(req.getParameter("aktif"));
                    dao.setAktif(id, aktif);
                    Rute.sukses(req, aktif ? "Akun diaktifkan kembali." : "Akun dinonaktifkan.");
                }
                break;
            }
            case "reset": {
                String sandi = req.getParameter("password") == null ? "" : req.getParameter("password");
                if (sandi.length() < 6) Rute.gagal(req, "Password baru minimal 6 karakter.");
                else { dao.resetPassword(id, sandi); Rute.sukses(req, "Password berhasil diatur ulang."); }
                break;
            }
            default: Rute.gagal(req, "Aksi tidak dikenal.");
        }
        res.sendRedirect(kembali);
    }
}
