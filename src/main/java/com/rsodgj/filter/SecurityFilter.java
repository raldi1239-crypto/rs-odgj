package com.rsodgj.filter;

import com.rsodgj.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Menjaga semua halaman terproteksi:
 *  - wajib login
 *  - /admin/*  hanya untuk Admin
 *  - /klinis/* hanya untuk Dokter dan Perawat
 *  - setiap POST wajib membawa token CSRF
 *  - halaman tidak boleh disimpan cache (tombol Back setelah logout)
 *  - memindahkan pesan flash dari session ke request
 */
@WebFilter(urlPatterns = {"/admin/*", "/klinis/*", "/akun"})
public class SecurityFilter implements Filter {

    @Override public void init(FilterConfig cfg) {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("userAktif");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?sesi=habis");
            return;
        }

        String path = request.getServletPath();
        boolean ok = true;
        if (path.startsWith("/admin")) ok = user.isAdmin();
        else if (path.startsWith("/klinis")) ok = user.isKlinis();
        if (!ok) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            Object token = session.getAttribute("csrfToken");
            String kiriman = request.getParameter("_csrf");
            if (token == null || !token.equals(kiriman)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Token keamanan tidak valid. Muat ulang halaman lalu coba lagi.");
                return;
            }
        }

        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        Object jenis = session.getAttribute("flashJenis");
        if (jenis != null) {
            request.setAttribute("flashJenis", jenis);
            request.setAttribute("flashPesan", session.getAttribute("flashPesan"));
            session.removeAttribute("flashJenis");
            session.removeAttribute("flashPesan");
        }
        chain.doFilter(req, res);
    }

    @Override public void destroy() {}
}
