<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8"/>
  <title>Login - Agenda</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  
  <style>
      body {
          background-color: #f5f7fb;
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
      }
      .card-login {
          width: 100%;
          max-width: 400px;
          border: none;
          border-radius: 12px;
      }
      .input-group-text {
          background-color: #f8f9fa;
          border-right: none;
      }
      .form-control {
          border-left: none;
      }
      .form-control:focus {
          box-shadow: none;
          border-color: #ced4da;
      }
      /* Foca a borda do grupo quando o input tem foco */
      .input-group:focus-within {
          box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
          border-radius: 0.375rem;
      }
      .input-group:focus-within .form-control, 
      .input-group:focus-within .input-group-text {
          border-color: #86b7fe;
      }
  </style>
</head>
<body>

  <div class="card card-login shadow p-4">
    
    <div class="text-center mb-4">
        <div class="d-inline-block p-3 rounded-circle bg-primary bg-opacity-10 text-primary mb-3">
            <i class="bi bi-journal-check fs-1"></i>
        </div>
        <h4 class="fw-bold">Bem-vindo de volta</h4>
        <p class="text-muted small">Insira suas credenciais para acessar sua agenda</p>
    </div>

    <c:if test="${not empty mensagem}">
        <div class="alert alert-success d-flex align-items-center" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            <div>${mensagem}</div>
        </div>
    </c:if>

    <c:if test="${not empty erro}">
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <div>${erro}</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
      
      <div class="mb-3">
        <label class="form-label fw-semibold">E-mail</label>
        <div class="input-group">
            <span class="input-group-text"><i class="bi bi-envelope text-muted"></i></span>
            <input type="email" name="email" class="form-control" placeholder="seu@email.com" required autofocus/>
        </div>
      </div>

      <div class="mb-4">
        <label class="form-label fw-semibold">Senha</label>
        <div class="input-group">
            <span class="input-group-text"><i class="bi bi-lock text-muted"></i></span>
            <input type="password" name="senha" class="form-control" placeholder="••••••••" required/>
        </div>
      </div>

      <button class="btn btn-primary w-100 py-2 fw-bold shadow-sm">Entrar</button>

      <div class="text-center mt-4 pt-2 border-top">
        <small class="text-muted">Não tem uma conta?</small>
        <a href="${pageContext.request.contextPath}/cadastro" class="text-decoration-none fw-bold ms-1">Cadastre-se gratuitamente</a>
      </div>

    </form>
  </div>

</body>
</html>