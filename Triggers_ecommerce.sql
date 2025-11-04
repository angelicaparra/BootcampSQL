USE ecommerce;

-- Define ponto e vírgula dentro da trigger não finalize o comando
DELIMITER //


-- Necessária para a Trigger de Remoção

-- Tabela para armazenar o histórico de clientes que excluíram suas contas.
-- Isto impede a perda de dados importantes (como CPF, Fname) antes da exclusão definitiva da conta.
CREATE TABLE ClientDeletionLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    idClient_deleted INT NOT NULL,
    Fname_deleted VARCHAR(10),
    Lname_deleted VARCHAR(20),
    CPF_deleted CHAR(11),
    Deletion_Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
//



--  Salvar os dados  antes que a exclusão ocorra.
CREATE TRIGGER trg_clients_before_delete
BEFORE DELETE ON clients
FOR EACH ROW
BEGIN
    -- Insere os dados do cliente que está sendo deletado na tabela de log.
    INSERT INTO ClientDeletionLog (idClient_deleted, Fname_deleted, Lname_deleted, CPF_deleted)
    VALUES (OLD.idClient, OLD.Fname, OLD.Lname, OLD.CPF);
END;
//


-- acionado ANTES que um registro seja ATUALIZADO na tabela seller (Vendedores/Colaboradores).
-- garantindo que o novo valor não seja nulo se for uma atualização do CNPJ,

-- garantir que o Nome Fantasia não seja alterado para um valor nulo.
CREATE TRIGGER trg_seller_before_update
BEFORE UPDATE ON seller
FOR EACH ROW
BEGIN
    -- Verifica se o novo Nome Fantasia está sendo definido como nulo ou vazio.
    IF NEW.NomeFantasia IS NULL OR NEW.NomeFantasia = '' THEN
        -- Define uma mensagem de erro ou força um valor para evitar NULL
        SET NEW.NomeFantasia = OLD.NomeFantasia;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O Nome Fantasia do vendedor/colaborador não pode ser nulo ou vazio.';
    END IF;

    -- Se o CNPJ for alterado, registramos o valor antigo.
    IF OLD.CNPJ <> NEW.CNPJ THEN
        SET NEW.SocialName = CONCAT(NEW.SocialName, ' (CNPJ Reauditado)');
    END IF;
END;
//

-- Restaura o delimitador padrão
DELIMITER ;


-- Teste d DELETE (clientes)

INSERT INTO clients (Fname, Lname, CPF, Address) VALUES ('Teste', 'Deletar', '99988877766', 'Rua Teste');
SET @last_id = LAST_INSERT_ID(); 

--  trg_clients_before_delete, salvando o log antes de tentar a exclusão.
DELETE FROM clients WHERE idClient = @last_id;


-- Teste de atualização (Nome Fantasia não nulo)
UPDATE seller
SET SocialName = 'Vendedor Atualizado'
WHERE idSeller = 1;


-- (Esta linha deve gerar um erro 45000 e impedir a transação, conforme a lógica da trigger)
-- UPDATE seller
-- SET NomeFantasia = ''
-- WHERE idSeller = 1;
