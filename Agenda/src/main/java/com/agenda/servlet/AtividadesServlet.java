package com.agenda.servlet;

import com.agenda.dao.AtividadeDAO;
import com.agenda.dao.CategoriaDAO;
import com.agenda.dao.PrioridadeDAO;
import com.agenda.model.Atividade;
import com.agenda.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name="AtividadesServlet", urlPatterns={"/atividades"})
public class AtividadesServlet extends HttpServlet {

    private AtividadeDAO atividadeDAO = new AtividadeDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    private PrioridadeDAO prioridadeDAO = new PrioridadeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) { resp.sendRedirect("login"); return; }

        String acao = req.getParameter("acao");
        String idStr = req.getParameter("id");

        // Lógica de Ações (Editar, Excluir, Status)
        if (acao != null && idStr != null) {
            int id = Integer.parseInt(idStr);
            
            switch (acao) {
                case "editar":
                    // Busca a atividade e manda para o JSP preencher o form
                    Atividade a = atividadeDAO.buscarPorId(id, usuario.getId());
                    req.setAttribute("atividadeEdit", a);
                    break;
                    
                case "excluir":
                    atividadeDAO.excluir(id, usuario.getId());
                    resp.sendRedirect("atividades"); // Reload limpo
                    return;
                    
                case "concluir":
                    atividadeDAO.atualizarStatus(id, usuario.getId(), "CONCLUIDO");
                    resp.sendRedirect("atividades");
                    return;
                    
                case "reabrir":
                    atividadeDAO.atualizarStatus(id, usuario.getId(), "PENDENTE");
                    resp.sendRedirect("atividades");
                    return;
            }
        }

        // Carregamento padrão da lista
        req.setAttribute("atividades", atividadeDAO.listarPorUsuario(usuario.getId()));
        req.setAttribute("categorias", categoriaDAO.findAll());
        req.setAttribute("prioridades", prioridadeDAO.findAll());

        req.getRequestDispatcher("/paginas/atividades.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) { resp.sendRedirect("login"); return; }

        // Recebe os dados
        String idStr = req.getParameter("id"); // Campo Hidden
        String titulo = req.getParameter("titulo");
        String descricao = req.getParameter("descricao");
        String dataStr = req.getParameter("data");
        String catIdStr = req.getParameter("categoria");
        String priIdStr = req.getParameter("prioridade");

        Atividade a = new Atividade();
        a.setTitulo(titulo);
        a.setDescricao(descricao);
        a.setUsuarioId(usuario.getId());

        try {
            if (dataStr != null && !dataStr.isEmpty()) a.setDataVencimento(LocalDate.parse(dataStr));
            if (catIdStr != null && !catIdStr.isEmpty()) a.setCategoriaId(Integer.parseInt(catIdStr));
            if (priIdStr != null && !priIdStr.isEmpty()) a.setPrioridadeId(Integer.parseInt(priIdStr));

            if (idStr != null && !idStr.isEmpty()) {
                // EDIÇÃO
                a.setId(Integer.parseInt(idStr));
                Atividade antiga = atividadeDAO.buscarPorId(a.getId(), usuario.getId());
                a.setStatus(antiga.getStatus()); 
                
                atividadeDAO.atualizar(a);
            } else {
                // CRIAÇÃO
                a.setStatus("PENDENTE");
                atividadeDAO.salvar(a);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("atividades");
    }
}