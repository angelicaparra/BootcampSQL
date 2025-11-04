USE ecommerce;

-- Definindo que o ponto e vírgula dentro da procedure não finalize o comando
DELIMITER //

CREATE PROCEDURE GerenciarCliente (
    IN acao INT,               -- Variável (1=INSERIR, 2=ATUALIZAR, 3=DELETAR)
    IN id_cliente INT,         --  UPDATE/DELETE
    IN novo_nome VARCHAR(10),  -- INSERT/UPDATE
    IN sobrenome VARCHAR(20),  
    IN cpf_doc CHAR(11)        
)
BEGIN
    CASE acao
        -- INSERINDO UM NOVO CLIENTE
        WHEN 1 THEN
            INSERT INTO clients (Fname, Lname, CPF, Address)
            VALUES (novo_nome, sobrenome, cpf_doc, 'Endereço Padrão');
            
            SELECT 'Cliente inserido com sucesso.' AS Resultado;

        -- update  (Fname e CPF)
        WHEN 2 THEN
            UPDATE clients
            SET 
                Fname = novo_nome,
                Lname = sobrenome,
                CPF = cpf_doc
            WHERE idClient = id_cliente;
            
            -- Verifica se alguma linha foi afetada
            IF ROW_COUNT() > 0 THEN
                SELECT CONCAT('Cliente ID ', id_cliente, ' atualizado com sucesso.') AS Resultado;
            ELSE
                SELECT CONCAT('Erro: Cliente ID ', id_cliente, ' não encontrado para atualização.') AS Resultado;
            END IF;

        -- DELET CLIENTE
        WHEN 3 THEN
            DELETE FROM clients
            WHERE idClient = id_cliente;
            
            IF ROW_COUNT() > 0 THEN
                SELECT CONCAT('Cliente ID ', id_cliente, ' excluído com sucesso.') AS Resultado;
            ELSE
                SELECT CONCAT('Erro: Cliente ID ', id_cliente, ' não encontrado para exclusão.') AS Resultado;
            END IF;

        -- Ação Inválida
        ELSE
            SELECT 'Ação inválida. Use 1 para INSERIR, 2 para ATUALIZAR, ou 3 para DELETAR.' AS Resultado;
    END CASE;
END//

-- Restaura o delimitador padrão
DELIMITER ;


-- TESTE DA PROCEDURE


-- Insere um novo cliente:
CALL GerenciarCliente(1, NULL, 'Novo', 'Teste Silva', '12345678900');


-- Atualiza o cliente de id=5 (Elisa Rocha):
CALL GerenciarCliente(2, 5, 'Elisa', 'Nova Sobrenome', '54321098765');


-- Tenta deletar o cliente que acabou de ser inserido (ID 6, assumindo que foi o próximo auto_increment):
CALL GerenciarCliente(3, 6, NULL, NULL, NULL);

-- 4. Chamada de Ação Inválida
CALL GerenciarCliente(99, NULL, NULL, NULL, NULL);
