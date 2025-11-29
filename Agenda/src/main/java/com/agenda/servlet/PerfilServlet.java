package com.agenda.servlet;

import com.agenda.dao.UsuarioDAO;
import com.agenda.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="PerfilServlet", urlPatterns={"/perfil"})
public class PerfilServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/paginas/editarPerfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            resp.sendRedirect("login");
            return;
        }

        String nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String senhaNova = req.getParameter("senha");
        String senhaConfirma = req.getParameter("confirmaSenha");

        // Validação básica de campos obrigatórios
        if (nome == null || nome.isEmpty() || email == null || email.isEmpty()) {
            req.setAttribute("erro", "Nome e Email são obrigatórios.");
            req.getRequestDispatcher("/paginas/editarPerfil.jsp").forward(req, resp);
            return;
        }

        // Lógica de Troca de Senha com Hash (BCrypt)
        if (senhaNova != null && !senhaNova.isEmpty()) {
            if (senhaNova.equals(senhaConfirma)) {
                //Criptografa antes de setar
                String hash = BCrypt.hashpw(senhaNova, BCrypt.gensalt());
                usuario.setSenha(hash); 
            } else {
                req.setAttribute("erro", "As senhas não conferem!");
                req.getRequestDispatcher("/paginas/editarPerfil.jsp").forward(req, resp);
                return;
            }
        }
        // Se o campo de senha vier vazio, o sistema ignora e mantém a senha (hash) antiga que já está no objeto

        // Atualiza os outros dados do objeto
        usuario.setNome(nome);
        usuario.setEmail(email);

        try {
            // Persiste as alterações no Banco de Dados (DAO já preparado para UPDATE)
            usuarioDAO.atualizar(usuario);
            
            // Atualiza o objeto na Sessão para refletir a mudança na hora (ex: nome no header)
            session.setAttribute("usuario", usuario);
            
            req.setAttribute("mensagem", "Perfil atualizado com sucesso!");
        } catch (Exception e) {
            // Tratamento de erro (ex: email duplicado no banco)
            e.printStackTrace();
            req.setAttribute("erro", "Erro ao salvar alterações: " + e.getMessage());
        }

        req.getRequestDispatcher("/paginas/editarPerfil.jsp").forward(req, resp);
    }
}