package com.agenda.model;

public class Prioridade {
    private int id;
    private String nome;
    private String cor; // ex: "success", "danger"

    public Prioridade() {}

    public Prioridade(int id, String nome, String cor) {
        this.id = id;
        this.nome = nome;
        this.cor = cor;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCor() { return cor; }
    public void setCor(String cor) { this.cor = cor; }
}
