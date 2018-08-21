USE master
GO

DROP DATABASE bd_atividade
GO

CREATE DATABASE bd_atividade
GO

USE bd_atividade

CREATE TABLE tb_metodologia
(
	id_metodologia int primary key identity (1,1),
	titulo varchar (80)
)

CREATE TABLE tb_tarefa 
(
	id_tarefa int primary key identity (1,1),
	titulo varchar (80) NOT NULL,
	prazoEstimado date,
	descricao varchar (250),
	dataInicio date NOT NULL,
	dataTermino date,
	id_metodologia int FOREIGN KEY REFERENCES tb_metodologia (id_metodologia)
)

CREATE TABLE tb_pessoas
(
	id_pessoa int primary key identity (1,1),
	nome varchar (150),
	email varchar (60),
	sexo char (1)
)

CREATE TABLE tb_relTarefaPessoas
(
	id int primary key identity (1,1),
	id_tarefa int FOREIGN KEY REFERENCES tb_tarefa (id_tarefa),
	id_pessoa int FOREIGN KEY REFERENCES tb_pessoas (id_pessoa)
)

GO

INSERT INTO tb_metodologia (titulo)
VALUES ('POMODORO')
INSERT INTO tb_metodologia (titulo)
VALUES ('GETTING THINGS DONE')
INSERT INTO tb_metodologia (titulo)
VALUES ('ZTN')
INSERT INTO tb_metodologia (titulo)
VALUES ('ZTN SIMPLIFICADO')
INSERT INTO tb_metodologia (titulo)
VALUES ('DONT BREAK THE CHAIN')

INSERT INTO tb_tarefa (titulo, prazoEstimado, descricao, dataInicio, dataTermino, id_metodologia)
VALUES ('Finalizar venda', '2018-08-16', 'Não esquecer', '2018-08-15', '2018-08-15', 1)
INSERT INTO tb_tarefa (titulo, prazoEstimado, descricao, dataInicio, dataTermino, id_metodologia)
VALUES ('Organizar mesa', '2018-08-13', 'Não esquecer', '2018-08-14', '2018-08-15', 2)
INSERT INTO tb_tarefa (titulo, prazoEstimado, descricao, dataInicio, dataTermino, id_metodologia)
VALUES ('Comprar material de escritório', '2018-08-14', 'Não esquecer', '2018-08-14', '2018-08-14', 2)
INSERT INTO tb_tarefa (titulo, prazoEstimado, descricao, dataInicio, dataTermino, id_metodologia)
VALUES ('Finalizar venda', '2018-08-12', 'Não esquecer de ligar', '2018-08-15', '2018-08-15', 2)
INSERT INTO tb_tarefa (titulo, prazoEstimado, descricao, dataInicio, dataTermino, id_metodologia)
VALUES ('Finalizar venda', '2018-08-16', 'Venda importante', '2018-08-15', '2018-08-15', 3)

INSERT INTO tb_pessoas (nome, email, sexo)
VALUES ('Maria', 'maria@email.com', 'f')
INSERT INTO tb_pessoas (nome, email, sexo)
VALUES ('Jonas', 'jonas@email.com', 'm')
INSERT INTO tb_pessoas (nome, email, sexo)
VALUES ('José', 'jose@email.com', 'm')
INSERT INTO tb_pessoas (nome, email, sexo)
VALUES ('Carolina', 'carol@email.com', 'f')
INSERT INTO tb_pessoas (nome, email, sexo)
VALUES ('Carlos', 'carlos@email.com', 'm')

INSERT INTO tb_relTarefaPessoas (id_pessoa, id_tarefa)
VALUES (1, 1)
INSERT INTO tb_relTarefaPessoas (id_pessoa, id_tarefa)
VALUES (1, 2)
INSERT INTO tb_relTarefaPessoas (id_pessoa, id_tarefa)
VALUES (2, 4)
INSERT INTO tb_relTarefaPessoas (id_pessoa, id_tarefa)
VALUES (3, 5)
INSERT INTO tb_relTarefaPessoas (id_pessoa, id_tarefa)
VALUES (4, 3)
INSERT INTO tb_relTarefaPessoas (id_pessoa)
VALUES (5)

GO

--1. Listar pessoas que não fazem parte de nenhuma tarefa

SELECT a.nome AS 'Quem não faz parte de nenhuma tarefa' FROM tb_pessoas as a
INNER JOIN tb_relTarefaPessoas as b
ON a.id_pessoa = b.id_pessoa WHERE b.id_tarefa IS NULL

--2. Listar quais os nomes das metodologias mais utilizadas

SELECT a.titulo AS 'Metodologias mais utilizadas' FROM  tb_metodologia as a
INNER JOIN tb_tarefa as b
ON a.id_metodologia = b.id_metodologia GROUP BY a.titulo ORDER BY COUNT (*) DESC

--3. Quantidade de tarefas realiziadas com mulheres e com homens

SELECT COUNT(*) AS 'Quantidade tarefas realizadas por homens' FROM tb_pessoas AS a
INNER JOIN tb_relTarefaPessoas AS b
ON a.id_pessoa = b.id_pessoa WHERE a.sexo = 'm' AND b.id_tarefa IS NOT NULL

SELECT COUNT(*) AS 'Quantidade tarefas realizadas por mulheres' FROM tb_pessoas AS a
INNER JOIN tb_relTarefaPessoas AS b
ON a.id_pessoa = b.id_pessoa WHERE a.sexo = 'f' AND b.id_tarefa IS NOT NULL

--4. Quais os nomes das pessoas com tarefas atrasadas?

SELECT a.nome AS 'Pessoas com tarefas atrasadas' FROM tb_pessoas as a
INNER JOIN tb_relTarefaPessoas as b
ON a.id_pessoa = b.id_pessoa
INNER JOIN tb_tarefa as c
ON c.id_tarefa = b.id_tarefa WHERE c.prazoEstimado > c.dataTermino