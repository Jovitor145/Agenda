/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.agenda.servlet;

import com.agenda.dao.UsuarioDAO;
import com.agenda.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 *
 * @author
 */
@WebServlet(name="CadastroServlet", urlPatterns={"/cadastro"})
public class CadastroServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Mostra o formulário de cadastro
        req.getRequestDispatcher("/paginas/cadastro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        // 1. Validações básicas
        if (nome == null || email == null || senha == null || senha.isEmpty()) {
            req.setAttribute("erro", "Todos os campos são obrigatórios");
            req.getRequestDispatcher("/paginas/cadastro.jsp").forward(req, resp);
            return;
        }

        // 2. Verifica se email já existe
        if (usuarioDAO.emailExiste(email)) {
            req.setAttribute("erro", "Este e-mail já está cadastrado.");
            req.getRequestDispatcher("/paginas/cadastro.jsp").forward(req, resp);
            return;
        }

        // 3. CRIPTOGRAFIA (Hash)
        String senhaHash = BCrypt.hashpw(senha, BCrypt.gensalt());

        // 4. Salva no banco
        Usuario u = new Usuario();
        u.setNome(nome);
        u.setEmail(email);
        u.setSenha(senhaHash);

        if (usuarioDAO.create(u)) {
            // Sucesso: Redireciona para login com mensagem
            req.setAttribute("mensagem", "Cadastro realizado! Faça login.");
            req.getRequestDispatcher("/paginas/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("erro", "Erro ao cadastrar. Tente novamente.");
            req.getRequestDispatcher("/paginas/cadastro.jsp").forward(req, resp);
        }
    }
}