package com.agenda.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class SessionFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Libera recursos estáticos, login E CADASTRO
        if (path.startsWith("/assets/")
                || path.equals("/login")
                || path.equals("/cadastro") // liberar o cadastro
                || path.endsWith(".css")
                || path.endsWith(".js")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            // Redireciona para o Servlet '/login'
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    public void destroy() {}
}