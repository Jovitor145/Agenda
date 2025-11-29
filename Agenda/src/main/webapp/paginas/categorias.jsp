<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../componentes/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2 class="fw-bold mb-3">Categorias</h2>

<div class="card p-4 shadow-sm">

    <h5 class="mb-3"><i class="bi bi-folder-fill me-2"></i>Lista de Categorias</h5>

    <table class="table table-hover">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Nome</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${categorias}">
                <tr>
                    <td>${c.id}</td>
                    <td>${c.nome}</td>
                </tr>
            </c:forEach>

            <c:if test="${empty categorias}">
                <tr>
                    <td colspan="2" class="text-center text-muted">Nenhuma categoria cadastrada</td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>

<%@ include file="../componentes/footer.jsp" %>