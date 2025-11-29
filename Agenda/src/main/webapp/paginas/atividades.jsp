<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="../componentes/header.jsp" %>

<h2 class="fw-bold mb-3">Gerenciar Atividades</h2>

<div class="card p-3 mb-3 shadow-sm ${not empty atividadeEdit ? 'border-warning' : ''}">
  
  <div class="mb-2">
      <c:if test="${not empty atividadeEdit}">
          <h5 class="text-warning"><i class="bi bi-pencil-square"></i> Editando Atividade #${atividadeEdit.id}</h5>
      </c:if>
      <c:if test="${empty atividadeEdit}">
          <h5 class="text-success"><i class="bi bi-plus-circle"></i> Nova Atividade</h5>
      </c:if>
  </div>

  <form action="${pageContext.request.contextPath}/atividades" method="post" class="row g-2">
    
    <input type="hidden" name="id" value="${atividadeEdit.id}">

    <div class="col-md-6">
      <label class="form-label">Título</label>
      <input type="text" name="titulo" class="form-control" required value="${atividadeEdit.titulo}">
    </div>
    
    <div class="col-md-6">
      <label class="form-label">Data de Vencimento</label>
      <input type="date" name="data" class="form-control" value="${atividadeEdit.dataVencimento}">
    </div>
    
    <div class="col-md-6">
      <label class="form-label">Prioridade</label>
      <select name="prioridade" class="form-select">
        <option value="">Selecione...</option>
        <c:forEach var="p" items="${prioridades}">
          <option value="${p.id}" ${atividadeEdit.prioridadeId == p.id ? 'selected' : ''}>${p.nome}</option>
        </c:forEach>
      </select>
    </div>

    <div class="col-md-6">
      <label class="form-label">Categoria</label>
      <select name="categoria" class="form-select">
        <option value="">Selecione...</option>
        <c:forEach var="c" items="${categorias}">
          <option value="${c.id}" ${atividadeEdit.categoriaId == c.id ? 'selected' : ''}>${c.nome}</option>
        </c:forEach>
      </select>
    </div>

    <div class="col-12">
      <label class="form-label">Descrição</label>
      <textarea name="descricao" class="form-control" rows="2">${atividadeEdit.descricao}</textarea>
    </div>
    
    <div class="col-12 d-flex justify-content-between">
      <c:if test="${not empty atividadeEdit}">
          <a href="${pageContext.request.contextPath}/atividades" class="btn btn-outline-secondary">Cancelar Edição</a>
      </c:if>
      
      <button class="btn ${not empty atividadeEdit ? 'btn-warning' : 'btn-success'} ms-auto">
          ${not empty atividadeEdit ? 'Salvar Alterações' : 'Adicionar Atividade'}
      </button>
    </div>
  </form>
</div>

<div class="card p-3 shadow-sm">
  <h5>Minhas atividades</h5>
  <ul class="list-group list-group-flush">
    <c:forEach var="a" items="${atividades}">
      
      <li class="list-group-item d-flex justify-content-between align-items-center ${a.status == 'CONCLUIDO' ? 'bg-light opacity-75' : ''}">
        
        <div class="d-flex align-items-center gap-3">
            <c:choose>
                <c:when test="${a.status == 'CONCLUIDO'}">
                    <a href="?acao=reabrir&id=${a.id}" class="btn btn-sm btn-success rounded-circle" title="Reabrir">
                        <i class="bi bi-check-lg"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="?acao=concluir&id=${a.id}" class="btn btn-sm btn-outline-secondary rounded-circle" title="Concluir">
                        <i class="bi bi-circle"></i>
                    </a>
                </c:otherwise>
            </c:choose>

            <div>
              <strong class="${a.status == 'CONCLUIDO' ? 'text-decoration-line-through' : ''}">${a.titulo}</strong>
              <br/>
              <small class="text-muted">${a.descricao}</small>
            </div>
        </div>
        
        <div class="text-end">
          <c:if test="${not empty a.dataVencimento}">
             <span class="badge bg-light text-dark border">${a.dataFormatada}</span>
          </c:if>
          
          <div class="btn-group ms-2">
              <a href="?acao=editar&id=${a.id}" class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></a>
              <a href="?acao=excluir&id=${a.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Tem certeza que deseja excluir?')"><i class="bi bi-trash"></i></a>
          </div>
        </div>
      </li>
    </c:forEach>
    
    <c:if test="${empty atividades}">
      <li class="list-group-item text-center text-muted py-3">Nenhuma atividade cadastrada.</li>
    </c:if>
  </ul>
</div>

<%@ include file="../componentes/footer.jsp" %>