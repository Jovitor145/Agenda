package com.agenda.servlet;

import com.agenda.dao.UsuarioDAO;
import com.agenda.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        // 1. Busca o usuário pelo email
        Usuario u = usuarioDAO.findByEmail(email);

        // 2. Verifica: Usuário existe e senha bate com o hash
        if (u != null && BCrypt.checkpw(senha, u.getSenha())) {
            
            HttpSession session = req.getSession();
            session.setAttribute("usuario", u);
            resp.sendRedirect(req.getContextPath() + "/home");
            
        } else {
            req.setAttribute("erro", "Email ou senha inválidos");
            req.getRequestDispatcher("/paginas/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/paginas/login.jsp").forward(req, resp);
    }
}