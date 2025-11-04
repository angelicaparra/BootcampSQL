-- listar todos
SELECT * FROM clients;

-- consulta simples com filtro WHERE
SELECT 
    idOrder, 
    idOrderCliente, 
    orderStatus, 
    orderDescription 
FROM orders
WHERE orderStatus = 'Confirmado';

-- criando um atributo para simular a soma de um valor de produto + frete
SELECT
    Fname,
    Lname,
    CONCAT(Fname, ' ', Minit, '. ', Lname) AS NomeCompleto,
    (200.00 + sendValue) AS ValorTotal
FROM clients AS c, orders AS o
WHERE c.idClient = o.idOrderCliente
LIMIT 5;

-- order by de forma crescente se fosse decrescente seria desc
SELECT
    Descricao,
    Category
FROM product
ORDER BY Category ASC;

/*
 melhorando um pouquinho
aqui faco a soma da quantidade total de produtos que cada vendedor possui e orderno pelo desc e tambem
filtra apenas os vendedores que possuem uma quantidade total maior que 100  
*/

SELECT 
    s.NomeFantasia AS Vendedor,
    SUM(pv.Prodquantidade) AS TotalEmEstoque
FROM seller AS s
JOIN produtVendedor AS pv ON s.idSeller = pv.idTerceiro
GROUP BY Vendedor
HAVING TotalEmEstoque > 100
ORDER BY TotalEmEstoque DESC;

/* 
Na juncao, irei fazer de duas formas, uma com duas tabelas e uma outra com 3 tabelas
*/

SELECT
    c.Fname,
    c.Lname,
    c.CPF,
    o.orderDescription,
    o.orderStatus
FROM clients AS c
JOIN orders AS o ON c.idClient = o.idOrderCliente;

-- 3 tabelas
SELECT
    p.Descricao AS Produto,
    s.NomeFantasia AS Vendedor,
    pv.Prodquantidade AS Qtd_Disponivel_Vendedor
FROM product AS p
JOIN produtVendedor AS pv ON p.idProduct = pv.idProduct
JOIN seller AS s ON pv.idTerceiro = s.idSeller;