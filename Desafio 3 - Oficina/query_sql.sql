USE oficina_mecanica;


-- consulta simples
SELECT Nome, Especialidade FROM Mecanicos;



--  Filtro com WHERE 

SELECT Placa, Modelo, Ano, Cor
FROM Veiculo
WHERE Modelo = 'Fiesta';


-- atributo derivado Valor + 15%

SELECT
    Descricao AS NomeServico,
    Valor AS ValorOriginal,
    (Valor * 1.15) AS ValorComImposto
FROM Servico;


-- ordenacao dos dados com ORDER BY
SELECT
    Descricao AS NomePeca,
    Valor
FROM Pecas
ORDER BY Valor DESC;


-- filtros  grupos – HAVING 
-- Apenas  cm mais de 1 OS
SELECT
    m.Nome AS Mecanico,
    COUNT(osm.OrdemServico_id_OS) AS TotalOS
FROM Mecanicos AS m
JOIN OrdemServico_Mecanicos AS osm ON m.idMecanicos = osm.Mecanicos_idMecanicos
GROUP BY m.Nome
HAVING TotalOS > 1
ORDER BY TotalOS DESC;


-- uniao de 2 tabelas
SELECT
    c.Nome AS Cliente,
    v.Placa,
    v.Modelo,
    os.Status AS StatusOS,
    os.DataEmissao
FROM Cliente AS c
JOIN Veiculo AS v ON c.idCliente = v.Cliente_idCliente
JOIN OrdemServico AS os ON v.idVeiculo = os.Veiculo_idVeiculo
ORDER BY os.DataEmissao DESC;
