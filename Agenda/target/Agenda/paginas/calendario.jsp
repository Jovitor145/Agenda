<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../componentes/header.jsp" %>
<link href="../assets/css/style.css" rel="stylesheet" type="text/css"/>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold text-primary mb-0 text-capitalize">
        <i class="bi bi-calendar3 me-2"></i> ${nomeMes} <span class="text-dark">${anoAtual}</span>
    </h2>
    
    <div class="btn-group">
        <a href="?mes=${dataAnterior.monthValue}&ano=${dataAnterior.year}" class="btn btn-outline-secondary">
            <i class="bi bi-chevron-left"></i> Anterior
        </a>
        <a href="?mes=${dataProxima.monthValue}&ano=${dataProxima.year}" class="btn btn-outline-secondary">
            Próximo <i class="bi bi-chevron-right"></i>
        </a>
    </div>
</div>

<div class="card shadow-sm border-0 p-3">
    
    <div class="calendar-grid mb-2">
        <div class="calendar-day-header text-danger">Domingo</div>
        <div class="calendar-day-header">Segunda</div>
        <div class="calendar-day-header">Terça</div>
        <div class="calendar-day-header">Quarta</div>
        <div class="calendar-day-header">Quinta</div>
        <div class="calendar-day-header">Sexta</div>
        <div class="calendar-day-header">Sábado</div>
    </div>

    <div class="calendar-grid">

        <c:forEach begin="1" end="${espacosVazios}">
            <div class="calendar-day empty"></div>
        </c:forEach>

        <c:forEach var="dia" begin="1" end="${diasNoMes}">
            
            <c:set var="dataLoop" value="${anoAtual}-${mesAtual < 10 ? '0' : ''}${mesAtual}-${dia < 10 ? '0' : ''}${dia}" />
            
            <c:set var="isHoje" value="${dataLoop == hoje.toString()}" />

            <div class="calendar-day ${isHoje ? 'today' : ''}">
                
                <div class="d-flex justify-content-between">
                    <span class="day-number ${isHoje ? 'text-primary' : ''}">${dia}</span>
                    <c:if test="${isHoje}"><span class="badge bg-primary" style="font-size: 0.6em">Hoje</span></c:if>
                </div>

                <div class="task-dots mt-2">
                    <%
                        // Pequeno scriptlet auxiliar para pegar a lista do mapa por data
                        java.util.Map<java.time.LocalDate, java.util.List<com.agenda.model.Atividade>> mapa = 
                            (java.util.Map) request.getAttribute("mapaTarefas");
                        
                        int d = (Integer) pageContext.getAttribute("dia");
                        int m = (Integer) request.getAttribute("mesAtual");
                        int a = (Integer) request.getAttribute("anoAtual");
                        java.time.LocalDate dataCurrent = java.time.LocalDate.of(a, m, d);
                        
                        java.util.List<com.agenda.model.Atividade> tarefasDia = mapa.get(dataCurrent);
                        pageContext.setAttribute("tarefasDia", tarefasDia);
                    %>

                    <c:if test="${not empty tarefasDia}">
                        <c:forEach var="t" items="${tarefasDia}">
                            
                            <c:choose>
                                <c:when test="${t.status == 'CONCLUIDO'}">
                                    <c:set var="cssClass" value="task-concluida" />
                                </c:when>
                                <c:when test="${t.dataVencimento.toString() < hoje.toString()}">
                                    <c:set var="cssClass" value="task-atrasada" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="cssClass" value="task-pendente" />
                                </c:otherwise>
                            </c:choose>

                            <a href="${pageContext.request.contextPath}/atividades?acao=editar&id=${t.id}" 
                               class="task-item ${cssClass}" 
                               title="${t.titulo}: ${t.descricao}">
                                ${t.titulo}
                            </a>

                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </c:forEach>

    </div>
</div>

<div class="mt-4 text-end">
    <small class="text-muted me-3"><span class="badge bg-primary opacity-25 text-primary">■</span> Pendente</small>
    <small class="text-muted me-3"><span class="badge bg-success opacity-25 text-success">■</span> Concluído</small>
    <small class="text-muted"><span class="badge bg-danger opacity-25 text-danger">■</span> Atrasado</small>
</div>

<%@ include file="../componentes/footer.jsp" %>