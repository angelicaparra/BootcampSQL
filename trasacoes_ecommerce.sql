USE ecommerce;

SET autocommit = 0;


--  Executar múltiplas operações de modificação e confirmar (COMMIT) ou
-- reverter (ROLLBACK) juntas.

START TRANSACTION;

-- Inserir um novo cliente (Temporário)
INSERT INTO clients (Fname, Lname, CPF, Address)
VALUES ('Transacao', 'Simples', '11122233344', 'Rua da Transação, 1');
SET @temp_client_id_1 = LAST_INSERT_ID();

-- Atualizar o endereço de um cliente existente
UPDATE clients
SET Address = 'Endereço Atualizado Pela Transação'
WHERE idClient = 1;

-- Verificação (SELECT)
SELECT Fname, Lname, Address FROM clients WHERE idClient IN (@temp_client_id_1, 1);


ROLLBACK;
-- COMMIT; -- Se fosse executado, as modificações seriam salvas

-- O cliente inserido não deve existir e o endereço do cliente 1 não deve ter mudado.
SELECT Fname, Lname, Address FROM clients WHERE idClient IN (@temp_client_id_1, 1);


-- Criar uma procedure que insere um produto e, se houver um erro


-- Prepara o ambiente para a procedure
DELIMITER //

CREATE PROCEDURE AdicionarProdutoTransacional (
    IN descricao_produto VARCHAR(45),
    IN categoria_produto ENUM('Eletrônico', 'Vestuário', 'Alimentos', 'Brinquedos', 'Móveis'),
    IN valor_estoque INT,
    IN forcar_erro BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERRO: Transação abortada e ROLLBACK executado.' AS StatusTransacao;
    END;


    START TRANSACTION;

    INSERT INTO product (Descricao, Category, Avaliacao)
    VALUES (descricao_produto, categoria_produto, 4.5);
    SET @novo_produto_id = LAST_INSERT_ID();
    
    
    -- Se valor_estoque for muito baixo, podemos usar SAVEPOINT para reverter apenas esta parte
    IF valor_estoque < 10 THEN
        -- Exemplo de SAVEPOINT (rollback parcial)
        SAVEPOINT estoque_insuficiente;
    END IF;
    
    -- Simulação de Erro (Condição para ROLLBACK total)
    IF forcar_erro = TRUE THEN
        INSERT INTO product (ColunaInexistente) VALUES (1);
    END IF;

    --  Confirmação (Se chegou até aqui sem erros)
    COMMIT;
    SELECT CONCAT('Sucesso: Produto ', @novo_produto_id, ' e estoque inseridos.') AS StatusTransacao;

END//


DELIMITER ;




-- Teste 
CALL AdicionarProdutoTransacional('Notebook Gamer X', 'Eletrônico', 50, FALSE);

-- Teste de Falha (ROLLBACK - Simulação de Erro)
-- Esta chamada irá falhar na instrução forçada e a procedure executará o ROLLBACK.
CALL AdicionarProdutoTransacional('Smartphone Pro', 'Eletrônico', 100, TRUE);


SET autocommit = 1;
