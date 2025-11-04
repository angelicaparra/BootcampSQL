-- ==========================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS E USO
-- ==========================================================
create database ecommerce;
use ecommerce;

-- ==========================================================
-- 2. CRIAÇÃO DAS TABELAS (Estrutura Fornecida/Corrigida)
-- ==========================================================

-- criar tabela cliente
create table clients(
    idClient int auto_increment primary key,
    Fname varchar(10) not null,
    Minit char(3),
    Lname varchar(20) not null,
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique(CPF)
);

-- criar tabela produto
create table product(
    idProduct int auto_increment primary key,
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos') not null,
    Descricao varchar(30)
);

-- criar tabela pagamento
create table payments(
    idClient int,
    id_payment int,
    typePayment enum('Boleto','Cartao','2 Cartao'),
    limitAvaible float,
    primary key(idClient, id_payment)
);


-- criar tabela pedido
create table orders(
    idOrder int auto_increment primary key,
    idOrderCliente int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderCliente) references clients(idClient)
);

-- criar tabela estoque
create table productStorage(
    idProdStorage int auto_increment primary key,
    storagelocation varchar(255),
    quantity int default 0,
    situacao ENUM('Disponivel', 'Sem Estoque')
);

-- criar tabela fornecedor
create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique(CNPJ)
);

-- criar tabela vendedor
create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    CPF char(9) not null,
    Address varchar(30),
    NomeFantasia varchar(45),
    contact char(11) not null,
    constraint unique_cpnj_seller unique(CNPJ),
    constraint unique_cpf_seller unique(CPF)
);

-- criar tabela produtos vendedor (CORRIGIDA para incluir idProduct e PK composta)
create table produtVendedor(
    idTerceiro int,
    idProduct int,
    SocialName varchar(255) not null,
    Address varchar(30),
    Prodquantidade int default 1,
    primary key(idTerceiro, idProduct),
    constraint fk_produt_vendedor foreign key (idTerceiro) references seller(idSeller),
    constraint fk_produt_product foreign key (idProduct) references product(idProduct)
);


-- ==========================================================
-- 3. INSERÇÃO DOS DADOS FICTÍCIOS
-- ==========================================================

-- Tabela clients
INSERT INTO clients (Fname, Minit, Lname, CPF, Address) VALUES
('Carlos', 'A', 'Silva', '12345678901', 'Rua A, 10 - Centro'),
('Maria', 'B', 'Santos', '98765432109', 'Av. B, 200 - Bairro Novo'),
('João', 'C', 'Pereira', '11223344556', 'Travessa C, 50 - Vila Velha'),
('Ana', 'D', 'Souza', '66554433221', 'Rua D, 300 - Jardim Primavera'),
('Pedro', 'E', 'Costa', '44556677889', 'Alameda E, 15 - Setor Oeste');

-- Tabela product
INSERT INTO product (Category, Descricao) VALUES
('Eletrônico', 'Smartphone XZ'),
('Vestimenta', 'Camiseta Algodão P'),
('Brinquedos', 'Carrinho de Controle'),
('Alimentos', 'Café Gourmet 500g'),
('Eletrônico', 'Notebook Gamer');

-- Tabela payments
INSERT INTO payments (idClient, id_payment, typePayment, limitAvaible) VALUES
(1, 101, 'Cartao', 5000.00),
(2, 102, 'Boleto', 0.00),
(3, 103, 'Cartao', 3500.00),
(4, 104, '2 Cartao', 8000.00),
(5, 105, 'Cartao', 2000.00);

-- Tabela orders
INSERT INTO orders (idOrderCliente, orderStatus, orderDescription, sendValue, paymentCash) VALUES
(1, 'Confirmado', 'Pedido de eletrônico', 25.50, false),
(2, 'Em processamento', 'Pedido de vestimenta', 10.00, true),
(3, 'Confirmado', 'Pedido de brinquedo', 15.00, false),
(4, 'Em processamento', 'Pedido de alimento', 10.00, true),
(1, 'Cancelado', 'Pedido cancelado pelo cliente', 10.00, false);

-- Tabela productStorage
INSERT INTO productStorage (storagelocation, quantity, situacao) VALUES
('São Paulo (SP)', 150, 'Disponivel'),
('Rio de Janeiro (RJ)', 25, 'Disponivel'),
('Minas Gerais (MG)', 500, 'Disponivel'),
('São Paulo (SP)', 0, 'Sem Estoque'),
('Bahia (BA)', 10, 'Disponivel');

-- Tabela supplier
INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
('Tech Distribuidora LTDA', '00112233445566', '11988776655'),
('Vestuário Atacado S.A.', '11223344556677', '21977665544'),
('Brinquedos Alegres EPP', '22334455667788', '31966554433'),
('Alimentos Puros ME', '33445566778899', '41955443322'),
('Super Tech Solutions', '44556677889900', '51944332211');

-- Tabela seller
INSERT INTO seller (SocialName, CNPJ, CPF, Address, NomeFantasia, contact) VALUES
('Vende Tudo Online LTDA', '55667788990011', '123456789', 'Rua Alfa, 100', 'VT Online', '11911112222'),
('Eletro & Cia ME', '66778899001122', '987654321', 'Av. Beta, 200', 'Eletro+', '21933334444'),
('Moda Jovem EIRELI', '77889900112233', '112233445', 'Rua Gama, 300', 'Moda X', '31955556666'),
('Geek Store', '88990011223344', '667788990', 'Travessa Delta, 40', 'GS Brinquedos', '41977778888'),
('Pé de Pano Vendas', '99001122334455', '135792468', 'Rua Epsilon, 50', 'Pano Varejo', '51999990000');

-- Tabela produtVendedor
INSERT INTO produtVendedor (idTerceiro, idProduct, Prodquantidade) VALUES
(1, 1, 100), 
(1, 2, 50),  
(2, 5, 20),  
(3, 2, 300), 
(4, 3, 80);  
