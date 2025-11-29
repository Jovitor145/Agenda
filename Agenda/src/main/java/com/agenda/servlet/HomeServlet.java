package com.agenda.servlet;

import com.agenda.dao.AtividadeDAO;
import com.agenda.dao.CategoriaDAO;
import com.agenda.dao.PrioridadeDAO;
import com.agenda.model.Atividade;
import com.agenda.model.Usuario;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private AtividadeDAO atividadeDAO = new AtividadeDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    private PrioridadeDAO prioridadeDAO = new PrioridadeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) { resp.sendRedirect("login"); return; }

        try {
            // 1. Dados
            List<Atividade> atividades = atividadeDAO.listarPorUsuario(usuario.getId());
            List<?> todasCategorias = categoriaDAO.findAll();
            List<?> todasPrioridades = prioridadeDAO.findAll();
            
            LocalDate hoje = LocalDate.now();
            
            // 2. Cálculos Básicos
            long tarefasHoje = atividades.stream()
                .filter(a -> a.getDataVencimento() != null && a.getDataVencimento().isEqual(hoje))
                .filter(a -> !"CONCLUIDO".equals(a.getStatus()))
                .count();

            long concluidas = atividades.stream()
                    .filter(a -> "CONCLUIDO".equals(a.getStatus()))
                    .count();

            // 3. LÓGICA DE USO DETALHADO (Sets de IDs)
            // Coletamos os IDs usados em um Set para facilitar a verificação no JSP
            Set<Integer> idsCategoriasUsadas = atividades.stream()
                    .map(Atividade::getCategoriaId)
                    .filter(id -> id > 0)
                    .collect(Collectors.toSet());

            Set<Integer> idsPrioridadesUsadas = atividades.stream()
                    .map(Atividade::getPrioridadeId)
                    .filter(id -> id > 0)
                    .collect(Collectors.toSet());

            String nomeMes = hoje.getMonth().getDisplayName(TextStyle.FULL, new Locale("pt", "BR"));
            nomeMes = nomeMes.substring(0, 1).toUpperCase() + nomeMes.substring(1);

            // 4. Envio
            req.setAttribute("diaAtual", hoje.getDayOfMonth());
            req.setAttribute("mesAtual", nomeMes);
            req.setAttribute("tarefasHoje", tarefasHoje);
            
            req.setAttribute("atividades", atividades);
            req.setAttribute("categorias", todasCategorias);
            req.setAttribute("prioridades", todasPrioridades);
            
            req.setAttribute("concluidas", concluidas);
            
            // Enviamos os Sets e os Tamanhos
            req.setAttribute("idsCatsUsadas", idsCategoriasUsadas);
            req.setAttribute("idsPriUsadas", idsPrioridadesUsadas);
            req.setAttribute("catsUsadasCount", idsCategoriasUsadas.size());
            req.setAttribute("priUsadasCount", idsPrioridadesUsadas.size());

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("erro", "Erro ao carregar dashboard.");
        }

        req.getRequestDispatcher("/paginas/home.jsp").forward(req, resp);
    }
}