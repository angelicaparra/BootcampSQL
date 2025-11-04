-- ==========================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ==========================================================
CREATE DATABASE oficina_mecanica;
USE oficina_mecanica;

-- ==========================================================
-- 2. CRIAÇÃO DAS TABELAS
-- ==========================================================

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Endereco VARCHAR(45),
    Telefone VARCHAR(15) -- Alterado para VARCHAR(15) para incluir DDD e formatos
);

-- Tabela Veiculo (Relacionamento 1:N com Cliente)
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Placa VARCHAR(7) NOT NULL UNIQUE,
    Modelo VARCHAR(45),
    Ano INT,
    Cor VARCHAR(45),
    -- FK
    Cliente_idCliente INT NOT NULL,
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Mecanicos
CREATE TABLE Mecanicos (
    idMecanicos INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Endereco VARCHAR(45),
    Especialidade VARCHAR(45)
);

-- Tabela Peças
CREATE TABLE Pecas (
    idPecas INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45) NOT NULL,
    Valor FLOAT
);

-- Tabela Serviço
CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45) NOT NULL,
    Valor FLOAT
);

-- Tabela Ordem de Serviço (OS) - Entidade principal que conecta Cliente/Veículo, Mecânicos e Serviços
CREATE TABLE OrdemServico (
    id_OS INT AUTO_INCREMENT PRIMARY KEY,
    DataEmissao DATETIME NOT NULL,
    DataConclusao DATETIME,
    Valor_Total FLOAT,
    Status VARCHAR(45) DEFAULT 'Em Andamento', -- Pode ser 'Em Andamento', 'Concluído', 'Cancelado'
    
    -- FKs (Conexão 1:N)
    Veiculo_idVeiculo INT NOT NULL,
    Cliente_idCliente INT NOT NULL, -- Incluído para rastreabilidade, embora já esteja em Veiculo
    Servico_idServico INT NOT NULL,
    Pecas_idPecas INT, -- Chave Estrangeira de Peças
    
    CONSTRAINT fk_os_veiculo
        FOREIGN KEY (Veiculo_idVeiculo) REFERENCES Veiculo(idVeiculo),
    CONSTRAINT fk_os_cliente
        FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_os_servico
        FOREIGN KEY (Servico_idServico) REFERENCES Servico(idServico),
    CONSTRAINT fk_os_pecas
        FOREIGN KEY (Pecas_idPecas) REFERENCES Pecas(idPecas)
);

-- Tabela Pagamento (Relacionamento 1:N com Serviço e N:1 com Cliente - Usaremos OS como referência principal)
CREATE TABLE Pagamento (
    idServico_idServico INT, -- FK para Servico
    Cliente_idCliente INT,   -- FK para Cliente
    Valor FLOAT,
    
    PRIMARY KEY (idServico_idServico, Cliente_idCliente), -- Chave composta
    
    CONSTRAINT fk_pagamento_servico
        FOREIGN KEY (idServico_idServico) REFERENCES Servico(idServico),
    CONSTRAINT fk_pagamento_cliente
        FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Ordem Servico/Mecanicos (Tabela de Relacionamento N:M entre OS e Mecanicos)
CREATE TABLE OrdemServico_Mecanicos (
    OrdemServico_id_OS INT NOT NULL,
    Mecanicos_idMecanicos INT NOT NULL,
    
    PRIMARY KEY (OrdemServico_id_OS, Mecanicos_idMecanicos), -- Chave Primária Composta
    
    CONSTRAINT fk_osm_os
        FOREIGN KEY (OrdemServico_id_OS) REFERENCES OrdemServico(id_OS),
    CONSTRAINT fk_osm_mecanicos
        FOREIGN KEY (Mecanicos_idMecanicos) REFERENCES Mecanicos(idMecanicos)
);
