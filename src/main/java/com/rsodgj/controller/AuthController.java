package com.rsodgj.controller;

import com.rsodgj.dao.UserDAO;
import com.rsodgj.model.User;
import com.rsodgj.util.Rute;
import com.rsodgj.util.Teks;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/login")
public class AuthController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = Teks.bersih(req.getParameter("username"));
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");

        User user;
        try {
            user = userDAO.autentikasi(username, password);
        } catch (RuntimeException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Sistem tidak dapat terhubung ke database. Hubungi administrator.");
            req.getRequestDispatcher("/index.jsp").forward(req, res);
            return;
        }

        if (user == null) {
            req.setAttribute("errorMsg", "Username atau password salah, atau akun tidak aktif.");
            req.setAttribute("usernameLama", username);
            req.getRequestDispatcher("/index.jsp").forward(req, res);
            return;
        }

        // buat session baru agar terhindar dari session fixation
        HttpSession lama = req.getSession(false);
        if (lama != null) lama.invalidate();
        HttpSession session = req.getSession(true);
        session.setAttribute("userAktif", user);
        session.setAttribute("csrfToken", UUID.randomUUID().toString());
        res.sendRedirect(req.getContextPath() + Rute.beranda(user));
    }
}
