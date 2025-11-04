USE oficina_mecanica;

-- 1. Tabela Cliente
INSERT INTO Cliente (Nome, Endereco, Telefone) VALUES
('Ana Silva', 'Rua das Flores, 100', '11987654321'),
('Bruno Costa', 'Av. Central, 50', '21912345678'),
('Carla Dias', 'Praça da Matriz, 22', '31998765432'),
('Daniel Melo', 'Rua B, 301', '41911223344'),
('Elisa Rocha', 'Estrada Velha, 78', '51955667788');

-- 2. Tabela Veiculo
INSERT INTO Veiculo (Placa, Modelo, Ano, Cor, Cliente_idCliente) VALUES
('ABC1234', 'Fiesta', 2018, 'Prata', 1),
('XYZ9876', 'Gol', 2010, 'Branco', 2),
('DEF5678', 'Focus', 2022, 'Vermelho', 3),
('GHI0001', 'Hilux', 2020, 'Preto', 4),
('JKL7777', 'Kwid', 2023, 'Azul', 5);

-- 3. Tabela Mecanicos
INSERT INTO Mecanicos (Nome, Endereco, Especialidade) VALUES
('João Souza', 'Rua Alfa, 1', 'Motor e Câmbio'),
('Pedro Lima', 'Av. Beta, 2', 'Elétrica'),
('Marta Santos', 'Travessa Gama, 3', 'Suspensão'),
('Rafaela Nunes', 'Rua Delta, 4', 'Geral'),
('Lucas Pereira', 'Av. Épsilon, 5', 'Motor e Câmbio');

-- 4. Tabela Peças
INSERT INTO Pecas (Descricao, Valor) VALUES
('Filtro de Óleo', 50.00),
('Vela de Ignição', 35.00),
('Pastilha de Freio', 120.00),
('Amortecedor Dianteiro', 350.00),
('Bateria 60Ah', 450.00);

-- 5. Tabela Serviço
INSERT INTO Servico (Descricao, Valor) VALUES
('Troca de Óleo', 80.00),
('Revisão Elétrica', 150.00),
('Alinhamento e Balanceamento', 100.00),
('Revisão Completa', 300.00),
('Troca de Bateria', 50.00);

-- 6. Tabela OrdemServico (OS)
INSERT INTO OrdemServico (DataEmissao, DataConclusao, Valor_Total, Status, Veiculo_idVeiculo, Cliente_idCliente, Servico_idServico, Pecas_idPecas) VALUES
('2025-10-01 10:00:00', '2025-10-01 14:00:00', 130.00, 'Concluído', 1, 1, 1, 1), -- Ana/Fiesta: Troca Óleo + Filtro
('2025-10-05 15:30:00', NULL, 500.00, 'Em Andamento', 2, 2, 4, 5), -- Bruno/Gol: Revisão Completa + Bateria
('2025-10-10 09:00:00', '2025-10-10 11:30:00', 250.00, 'Concluído', 3, 3, 3, 3), -- Carla/Focus: Alinhamento + Pastilha
('2025-10-15 11:00:00', NULL, 350.00, 'Em Andamento', 4, 4, 2, NULL), -- Daniel/Hilux: Revisão Elétrica
('2025-10-20 16:00:00', '2025-10-20 18:00:00', 50.00, 'Concluído', 5, 5, 5, NULL); -- Elisa/Kwid: Troca de Bateria

-- 7. Tabela Pagamento (Baseado na OS)
-- Assumimos que o Valor total do Pagamento é o Valor do Serviço + 50% do valor da Peça (se houver)
INSERT INTO Pagamento (idServico_idServico, Cliente_idCliente, Valor) VALUES
(1, 1, 130.00), -- Cliente 1, Serviço 1
(4, 2, 500.00), -- Cliente 2, Serviço 4
(3, 3, 250.00), -- Cliente 3, Serviço 3
(2, 4, 350.00), -- Cliente 4, Serviço 2
(5, 5, 50.00);  -- Cliente 5, Serviço 5

-- 8. Tabela OrdemServico_Mecanicos (Relacionamento N:M)
INSERT INTO OrdemServico_Mecanicos (OrdemServico_id_OS, Mecanicos_idMecanicos) VALUES
(1, 1), -- OS 1 -> Mecânico João (Motor)
(1, 4), -- OS 1 -> Mecânico Rafaela (Geral)
(2, 5), -- OS 2 -> Mecânico Lucas (Motor)
(3, 3), -- OS 3 -> Mecânico Marta (Suspensão)
(4, 2); -- OS 4 -> Mecânico Pedro (Elétrica)
