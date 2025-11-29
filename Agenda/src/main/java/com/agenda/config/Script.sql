/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:
 * Created: 28 de nov. de 2025
 */

DROP DATABASE IF EXISTS agenda;

CREATE DATABASE IF NOT EXISTS agenda
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE agenda;

-- Tabela de Usuários
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Categorias
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO categorias (nome) VALUES 
('Pessoal'),
('Trabalho'),
('Estudos'),
('Saúde'),
('Outros');

-- Tabela de Prioridades
CREATE TABLE prioridades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    cor VARCHAR(20) NOT NULL
);

INSERT INTO prioridades (nome, cor) VALUES
('Baixa', 'success'),
('Média', 'warning'),
('Alta', 'danger');

-- Tabela de Atividades (Refatorada para o Java Atual)
CREATE TABLE atividades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    
    -- Ajustado para bater com o DAO que usa apenas uma data de vencimento
    data DATE, 
    
    -- Adicionado para suportar o status 'PENDENTE', 'CONCLUIDO'
    status VARCHAR(20) DEFAULT 'PENDENTE', 
    
    usuario_id INT NOT NULL,
    
    -- Deixei NULLABLE (sem NOT NULL) por enquanto, pois o DAO ainda não envia esses dados
    categoria_id INT,
    prioridade_id INT,
    
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE SET NULL,
    FOREIGN KEY (prioridade_id) REFERENCES prioridades(id)
        ON DELETE SET NULL
);

-- Inserindo usuário padrão para teste, senha: "123"
INSERT INTO usuarios (nome, email, senha)
VALUES ('Administrador', 'admin@admin.com', '$2a$10$d/EqRcDbzBhR2qpxu9V0Re2TxoIp22gylpJBYTW6pvQHLCYWjKvy2');