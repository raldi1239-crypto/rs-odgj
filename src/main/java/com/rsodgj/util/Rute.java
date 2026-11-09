package com.rsodgj.util;

import com.rsodgj.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/** Fungsi bantu untuk perpindahan halaman dan pesan notifikasi (flash). */
public final class Rute {
    private Rute() {}

    public static String beranda(User u) {
        return u != null && u.isAdmin() ? "/admin/dashboard" : "/klinis/dashboard";
    }

    public static void tampil(HttpServletRequest req, HttpServletResponse res, String view) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/" + view + ".jsp").forward(req, res);
    }

    public static void sukses(HttpServletRequest req, String pesan) { flash(req, "sukses", pesan); }
    public static void gagal(HttpServletRequest req, String pesan) { flash(req, "gagal", pesan); }

    private static void flash(HttpServletRequest req, String jenis, String pesan) {
        HttpSession s = req.getSession(false);
        if (s != null) { s.setAttribute("flashJenis", jenis); s.setAttribute("flashPesan", pesan); }
    }

    public static int halaman(String param) { return Math.max(1, Teks.toInt(param, 1)); }
}
