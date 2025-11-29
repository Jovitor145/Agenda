<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../componentes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="fw-bold text-primary mb-0">
        <i class="bi bi-person-gear me-2"></i>Editar Perfil
    </h2>
</div>

<div class="row">
    <div class="col-md-8 mx-auto">
        <div class="card shadow-sm border-0">
            <div class="card-body p-4">
                
                <c:if test="${not empty mensagem}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${mensagem}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty erro}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${erro}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/perfil" method="post">
                    
                    <h5 class="mb-3 text-secondary border-bottom pb-2">Informações Pessoais</h5>
                    
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Nome Completo</label>
                            <input type="text" name="nome" class="form-control" 
                                   value="${sessionScope.usuario.nome}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">E-mail</label>
                            <input type="email" name="email" class="form-control" 
                                   value="${sessionScope.usuario.email}" required>
                        </div>
                    </div>

                    <h5 class="mb-3 text-secondary border-bottom pb-2">Segurança</h5>
                    <div class="alert alert-light border mb-3">
                        <small class="text-muted"><i class="bi bi-info-circle me-1"></i> Deixe os campos abaixo vazios se não quiser alterar a senha.</small>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Nova Senha</label>
                            <input type="password" name="senha" class="form-control" placeholder="******">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Confirmar Nova Senha</label>
                            <input type="password" name="confirmaSenha" class="form-control" placeholder="******">
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">Cancelar</a>
                        <button class="btn btn-primary px-4">
                            <i class="bi bi-save me-1"></i> Salvar Alterações
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../componentes/footer.jsp" %>c