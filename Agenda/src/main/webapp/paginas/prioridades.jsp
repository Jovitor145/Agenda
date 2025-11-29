<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../componentes/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2 class="fw-bold mb-3">Prioridades</h2>

<div class="card p-4 shadow-sm">

    <h5 class="mb-3"><i class="bi bi-flag-fill me-2"></i>Lista de Prioridades</h5>

    <table class="table table-hover">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Cor</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${prioridades}">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.nome}</td>
                    <td>
                        <span class="badge bg-${p.cor}">
                            ${p.cor}
                        </span>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty prioridades}">
                <tr>
                    <td colspan="3" class="text-center text-muted">Nenhuma prioridade cadastrada</td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>

<%@ include file="../componentes/footer.jsp" %>