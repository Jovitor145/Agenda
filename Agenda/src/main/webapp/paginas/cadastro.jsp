<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro - Agenda</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f5f7fb; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card-cadastro { width: 100%; max-width: 400px; border-radius: 15px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<div class="card card-cadastro p-4">
    <div class="text-center mb-4">
        <h3 class="fw-bold text-primary">Crie sua conta</h3>
        <p class="text-muted">Comece a organizar sua vida hoje</p>
    </div>

    <c:if test="${not empty erro}">
        <div class="alert alert-danger py-2">${erro}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/cadastro" method="post">
        <div class="mb-3">
            <label class="form-label">Nome Completo</label>
            <input type="text" name="nome" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">E-mail</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Senha</label>
            <input type="password" name="senha" class="form-control" required>
        </div>
        
        <button class="btn btn-primary w-100 py-2 mb-3">Cadastrar</button>
        
        <div class="text-center">
            <small>Já tem uma conta? <a href="${pageContext.request.contextPath}/login">Fazer Login</a></small>
        </div>
    </form>
</div>

</body>
</html>