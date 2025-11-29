<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% request.setAttribute("hoje", java.time.LocalDate.now()); %>

<%@ include file="../componentes/header.jsp" %>

<script src="../assets/js/app.js" type="text/javascript"></script>

<c:set var="popoverCategorias">
    <div class='text-start small'>
        <h6 class='border-bottom pb-2 mb-2'>Status de Uso</h6>
        <ul class='list-unstyled mb-0'>
            <c:forEach var="c" items="${categorias}">
                <li class='mb-1'>
                    <c:choose>
                        <c:when test="${idsCatsUsadas.contains(c.id)}">
                            <i class='bi bi-check-circle-fill text-success me-2'></i><strong>${c.nome}</strong>
                        </c:when>
                        <c:otherwise>
                            <i class='bi bi-circle text-muted me-2 opacity-50'></i><span class='text-muted'>${c.nome}</span>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:forEach>
        </ul>
    </div>
</c:set>

<c:set var="popoverPrioridades">
    <div class='text-start small'>
        <h6 class='border-bottom pb-2 mb-2'>Níveis Utilizados</h6>
        <ul class='list-unstyled mb-0'>
            <c:forEach var="p" items="${prioridades}">
                <li class='mb-1'>
                    <c:choose>
                        <c:when test="${idsPriUsadas.contains(p.id)}">
                            <span class='badge bg-${p.cor} me-2'>✓</span><strong>${p.nome}</strong>
                        </c:when>
                        <c:otherwise>
                            <span class='badge bg-light text-secondary border me-2'>-</span><span class='text-muted'>${p.nome}</span>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:forEach>
        </ul>
    </div>
</c:set>


<h2 class="fw-bold mb-3">Painel</h2>

<div class="row g-3">
    <div class="col-md-8">
        
        <div class="card shadow-sm border-0 bg-primary text-white mb-3">
            <div class="card-body p-4 d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="opacity-75 mb-0">Hoje é dia</h5>
                    <h1 class="display-4 fw-bold mb-0">${diaAtual} <span class="fs-4 fw-normal">${mesAtual}</span></h1>
                    <p class="mb-0 mt-2">
                        <c:choose>
                            <c:when test="${tarefasHoje > 0}">
                                <span class="badge bg-warning text-dark animate-pulse">
                                    <i class="bi bi-exclamation-circle"></i> Você tem ${tarefasHoje} tarefa(s) para hoje!
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="opacity-75"><i class="bi bi-check-circle"></i> Nenhuma tarefa vence hoje.</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="text-center d-none d-sm-block">
                    <i class="bi bi-calendar-check" style="font-size: 4rem; opacity: 0.3;"></i>
                    <div class="mt-2">
                        <a href="${pageContext.request.contextPath}/calendario" class="btn btn-sm btn-light text-primary fw-bold">Ver Mês Inteiro</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0 text-primary"><i class="bi bi-list-task me-2"></i>Suas Atividades</h5>
                <a href="${pageContext.request.contextPath}/atividades" class="btn btn-sm btn-outline-secondary">Gerenciar</a>
            </div>
            
            <ul class="list-group list-group-flush" id="lista-atividades">
                <c:forEach var="a" items="${atividades}" end="4">
                    
                    <c:choose>
                        <c:when test="${a.status == 'CONCLUIDO'}">
                            <c:set var="rowClass" value="list-group-item-success" />
                            <c:set var="badgeClass" value="bg-success" />
                            <c:set var="statusText" value="Concluído" />
                        </c:when>
                        <c:when test="${not empty a.dataVencimento and a.dataVencimento < hoje}">
                            <c:set var="rowClass" value="list-group-item-danger" />
                            <c:set var="badgeClass" value="bg-danger" />
                            <c:set var="statusText" value="Atrasado" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="rowClass" value="" />
                            <c:set var="badgeClass" value="bg-primary" />
                            <c:set var="statusText" value="Pendente" />
                        </c:otherwise>
                    </c:choose>

                    <li class="list-group-item px-3 py-3 border-bottom ${rowClass}">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong class="d-block text-dark ${a.status == 'CONCLUIDO' ? 'text-decoration-line-through' : ''}">
                                    ${a.titulo}
                                </strong>
                                <small class="text-muted">${a.descricao}</small>
                            </div>
                            
                            <div class="text-end">
                                <c:if test="${not empty a.dataVencimento}">
                                    <span class="badge bg-light text-dark border border-secondary mb-1">
                                        <i class="bi bi-calendar-event me-1"></i>${a.dataFormatada}
                                    </span>
                                </c:if>
                                <br/>
                                <span class="badge ${badgeClass}" style="font-size: 0.7em;">${statusText}</span>
                            </div>
                        </div>
                    </li>
                </c:forEach>
                
                <c:if test="${empty atividades}">
                    <li class="list-group-item text-center text-muted py-5">
                        <i class="bi bi-inbox fs-1 d-block mb-2 opacity-25"></i>
                        Você está livre! Nenhuma atividade recente.
                    </li>
                </c:if>
            </ul>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
            <h5 class="mb-3 text-secondary">Resumo do Sistema</h5>
            <ul class="list-group list-group-flush">
                
                <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-3">
                    <span><i class="bi bi-check2-circle me-2 text-success"></i>Concluídas / Total</span>
                    <span class="badge bg-success rounded-pill fs-6">
                        ${concluidas} / ${fn:length(atividades)}
                    </span>
                </li>
                
                <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-3" 
                    data-bs-toggle="popover" 
                    data-bs-trigger="hover focus" 
                    data-bs-placement="left"
                    data-bs-html="true" 
                    title="Detalhes das Categorias"
                    data-bs-content="${fn:escapeXml(popoverCategorias)}" 
                    style="cursor: help;">
                    
                    <span><i class="bi bi-tags me-2 text-warning"></i>Categorias (Uso) <i class="bi bi-info-circle ms-1" style="font-size: 0.7em"></i></span>
                    <span class="badge bg-warning text-dark rounded-pill fs-6">
                        ${catsUsadasCount} / ${fn:length(categorias)}
                    </span>
                </li>
                
                <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-3"
                    data-bs-toggle="popover" 
                    data-bs-trigger="hover focus" 
                    data-bs-placement="left"
                    data-bs-html="true" 
                    title="Detalhes das Prioridades"
                    data-bs-content="${fn:escapeXml(popoverPrioridades)}"
                    style="cursor: help;">
                    
                    <span><i class="bi bi-flag me-2 text-danger"></i>Prioridades (Uso) <i class="bi bi-info-circle ms-1" style="font-size: 0.7em"></i></span>
                    <span class="badge bg-danger rounded-pill fs-6">
                        ${priUsadasCount} / ${fn:length(prioridades)}
                    </span>
                </li>
            </ul>
        </div>
        
        <div class="card p-3 mt-3 shadow-sm border-0 text-center">
            <div class="card-body">
                <div class="mb-3">
                    <div class="d-inline-block p-3 rounded-circle bg-light text-primary">
                         <i class="bi bi-person fs-1"></i>
                    </div>
                </div>
                <h6 class="card-title fw-bold">Olá, ${sessionScope.usuario.nome}</h6>
                <p class="card-text small text-muted mb-3">${sessionScope.usuario.email}</p>
                <a href="${pageContext.request.contextPath}/perfil" class="btn btn-sm btn-outline-primary w-100">
                    <i class="bi bi-gear me-1"></i> Configurações
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="../componentes/footer.jsp" %>