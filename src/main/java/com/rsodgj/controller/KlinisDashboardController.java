package com.rsodgj.controller;

import com.rsodgj.dao.PasienDAO;
import com.rsodgj.dao.RekamMedisDAO;
import com.rsodgj.dao.RingkasanDAO;
import com.rsodgj.model.User;
import com.rsodgj.util.Rute;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/klinis/dashboard")
public class KlinisDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        User saya = (User) req.getSession().getAttribute("userAktif");
        PasienDAO pasienDAO = new PasienDAO();
        req.setAttribute("ringkasan", new RingkasanDAO().ambil());
        req.setAttribute("prioritas", pasienDAO.cari(null, null, "Rawat Inap", "risiko", 0, 6));
        req.setAttribute("catatanTerbaru", new RekamMedisDAO().terbaru(6));
        req.setAttribute("ditangani", "Dokter".equals(saya.getRole()) ? pasienDAO.hitungDitangani(saya.getIdUser()) : -1);
        Rute.tampil(req, res, "klinis/dashboard");
    }
}
