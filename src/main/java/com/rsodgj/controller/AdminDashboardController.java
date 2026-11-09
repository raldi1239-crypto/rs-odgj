package com.rsodgj.controller;

import com.rsodgj.dao.BangsalDAO;
import com.rsodgj.dao.PasienDAO;
import com.rsodgj.dao.RingkasanDAO;
import com.rsodgj.util.Rute;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("ringkasan", new RingkasanDAO().ambil());
        req.setAttribute("listBangsal", new BangsalDAO().semua());
        req.setAttribute("pasienTerbaru", new PasienDAO().terbaru(6));
        Rute.tampil(req, res, "admin/dashboard");
    }
}
