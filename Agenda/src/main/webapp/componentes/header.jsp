<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">Agenda</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/atividades"><i class="bi bi-list-check me-1"></i>Atividades</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/calendario"><i class="bi bi-calendar3 me-1"></i>Calendário</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/perfil"><i class="bi bi-person me-1"></i>Perfil</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-1"></i>Sair</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">