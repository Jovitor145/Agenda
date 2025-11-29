package com.agenda.servlet;

import com.agenda.dao.AtividadeDAO;
import com.agenda.model.Atividade;
import com.agenda.model.Usuario;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CalendarioServlet", urlPatterns = {"/calendario"})
public class CalendarioServlet extends HttpServlet {

    private AtividadeDAO atividadeDAO = new AtividadeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            resp.sendRedirect("login");
            return;
        }

        // 1. Controle de Navegação (Mês/Ano)
        LocalDate dataBase = LocalDate.now();
        
        String mesParam = req.getParameter("mes");
        String anoParam = req.getParameter("ano");

        if (mesParam != null && anoParam != null) {
            try {
                int m = Integer.parseInt(mesParam);
                int a = Integer.parseInt(anoParam);
                dataBase = LocalDate.of(a, m, 1);
            } catch (NumberFormatException e) {
                // Se der erro, mantém data atual
            }
        }

        // Dados do mês atual selecionado
        YearMonth yearMonth = YearMonth.from(dataBase);
        int diasNoMes = yearMonth.lengthOfMonth();
        
        // Calcular dia da semana que começa o mês (1 = Seg, 7 = Dom)
        // Convertendo para padrão onde Domingo = 0 ou 1 para facilitar loop visual
        DayOfWeek diaSemanaEnum = yearMonth.atDay(1).getDayOfWeek();
        int espacosVazios = diaSemanaEnum.getValue(); 
        if (espacosVazios == 7) espacosVazios = 0; // Se começar no Domingo, array 0

        // 2. Buscar Dados e Filtrar
        List<Atividade> todasAtividades = atividadeDAO.listarPorUsuario(usuario.getId());

        // Agrupa atividades por DATA (Key: LocalDate, Value: List<Atividade>)
        Map<LocalDate, List<Atividade>> tarefasPorDia = todasAtividades.stream()
                .filter(a -> a.getDataVencimento() != null)
                // Filtra apenas tarefas do mês/ano visualizado para otimizar renderização
                .filter(a -> YearMonth.from(a.getDataVencimento()).equals(yearMonth))
                .collect(Collectors.groupingBy(Atividade::getDataVencimento));

        // 3. Preparar Variáveis para o JSP
        String nomeMes = yearMonth.getMonth().getDisplayName(TextStyle.FULL, new Locale("pt", "BR"));
        nomeMes = nomeMes.substring(0, 1).toUpperCase() + nomeMes.substring(1);

        req.setAttribute("anoAtual", yearMonth.getYear());
        req.setAttribute("mesAtual", yearMonth.getMonthValue());
        req.setAttribute("nomeMes", nomeMes);
        
        req.setAttribute("diasNoMes", diasNoMes);
        req.setAttribute("espacosVazios", espacosVazios); // Padding inicial
        req.setAttribute("mapaTarefas", tarefasPorDia);
        req.setAttribute("hoje", LocalDate.now()); // Para destacar o dia atual

        // Navegação (Anterior / Próximo)
        req.setAttribute("dataAnterior", dataBase.minusMonths(1));
        req.setAttribute("dataProxima", dataBase.plusMonths(1));

        req.getRequestDispatcher("/paginas/calendario.jsp").forward(req, resp);
    }
}