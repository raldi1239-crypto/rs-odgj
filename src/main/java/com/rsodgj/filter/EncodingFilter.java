package com.rsodgj.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

/** Memastikan semua request/response memakai UTF-8. */
@WebFilter(urlPatterns = "/*")
public class EncodingFilter implements Filter {
    @Override public void init(FilterConfig cfg) {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        chain.doFilter(req, res);
    }

    @Override public void destroy() {}
}
