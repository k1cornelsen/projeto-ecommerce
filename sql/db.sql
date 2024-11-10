create database projetosemestral;
use projetosemestral;

create table usuario(
email varchar(200),
nome varchar(200),
cpf bigint,
senha varchar(200),
primary key (email));

create table produto(
nome varchar(200),
descricao varchar(1000), 
valor int,
primary key (nome));

create table carrinho(
nome varchar(200),
descricao varchar(1000),
valor int,
primary key (nome));

insert into produto 
values ('Bermuda Cyclone', 'BERMUDA AZUL PRA COMBINAR COM O KENNER', 379),
('Boné Kondzilla', 'BONÉ DE SUCESSO', 100),
('Camisa do Messi', '9 EM 10 NO BAILE TÃO USANDO, SÓ FALTA VOCÊ', 240),
('Chinelo Kenner', 'DE KENNER', 150),
('Corrente de Ouro', 'CORRENTE DE OURO 24K 70CM', 2990),
('Óculos Juliet', 'UM ITEM DE CRIA QUE NÃO PODE FALTAR', 125);