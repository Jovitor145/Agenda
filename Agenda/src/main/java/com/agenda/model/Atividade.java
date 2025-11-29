package com.agenda.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Atividade {
    private int id;
    private String titulo;
    private String descricao;
    private LocalDate dataVencimento;
    private String status;
    private int usuarioId;
    private int prioridadeId;
    private int categoriaId;

    public Atividade() {}

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public LocalDate getDataVencimento() { return dataVencimento; }
    public void setDataVencimento(LocalDate dataVencimento) { this.dataVencimento = dataVencimento; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public int getPrioridadeId() { return prioridadeId; }
    public void setPrioridadeId(int prioridadeId) { this.prioridadeId = prioridadeId; }

    public int getCategoriaId() { return categoriaId; }
    public void setCategoriaId(int categoriaId) { this.categoriaId = categoriaId; }

    // O JSP vai chamar isso usando ${a.dataFormatada}
    public String getDataFormatada() {
        if (this.dataVencimento != null) {
            return this.dataVencimento.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }
}