/* Esquema de Relações - Controle de Cinema
Tabelas Base 
Filme (Cod_filme(PK), Titulo_Filme, Ano_lancto,Titulo_original, Idioma_Original, Ano_producao, Classifica_Etaria, Estudio, 
Duracao, Nacionalidade_Filme, Genero, Situacao_Filme)
Artista (Cod_artista(PK),Nome_artista, Nacionalidade_artista, Sexo_artista)
Sala (Nome_sala(PK), Capacidade,Tipo_Sala, Tipo_Projecao, Tipo_Audio, Dim_tela, Situacao_Sala)
Assento (Num_assento(PK), Fileira(PK), Nome_sala(FK)(PK), Tipo_assento [Normal, PNE etc], Situacao_assento)
Forma_Pagto (Cod_Forma_pgto(PK), Tipo_forma_pgto, Situacao_Forma_pgto)
Horario (Cod_hora(PK), Horario)
Funcionario (Cod_func(PK), Nome_func, sexo_func [M,F], Dt_nascto, Dt_admissao, Salario, Num_CTPS, Situacao_func)
 
Tabelas de Relacionamento 
Sessao (Num_Sessao(PK), Dt_sessao, Tipo_projecao, Idioma, Dubl_Leg, Preco_Ingresso, Publico, cod_filme(FK)NN, 
Nome_sala(FK)NN, Cod_hora_exibicao(FK)NN, Situacao_sessao)
Ingresso (Num_ingresso(PK), Tipo_ingresso, Valor_pago, Num_sessao(FK)NN, Num_assento(FK)NN, Fileira(FK)NN, 
Nome_sala(FK)NN, Cod_Forma_pgto(FK)NN, Situacao_ingresso)
Escala_Turno (Cod_turno(PK), Nome_turno,Dia_semana,Cod_hora_ini(FK)NN, Cod_hora_term(FK)NN)
Escala_Trabalho (Cod_turno(PK)(FK),Cod_func(PK)(FK),Dt_ini_escala(PK), Dt_term_escala, Funcao)
Elenco_filme (Cod_artista(PK)(FK),Cod_filme(PK)(FK), Tipo_participacao [Ator,Diretor etc.] */

-- definindo o padrao de data
SET DATESTYLE TO POSTGRES, DMY ;
-- tabela horario
DROP TABLE IF EXISTS horario CASCADE ;
CREATE TABLE horario 
(cod_hora SMALLINT PRIMARY KEY,
 horario TIME NOT NULL ) ;
-- populando 
INSERT INTO horario VALUES (1, '14:00') ;
INSERT INTO horario ( horario, cod_hora) VALUES ('16:00:00', 2 ) ;
SELECT * FROM horario ;
-- tabela filme
DROP TABLE IF EXISTS filme CASCADE ;
CREATE TABLE filme (
cod_filme INTEGER,
titulo_Filme VARCHAR(40) NOT NULL,
titulo_original VARCHAR(40) NOT NULL,
ano_lancto SMALLINT,
ano_producao SMALLINT,	   
idioma_Original CHAR(15) NOT NULL,
classifica_Etaria CHAR(20),
estudio VARCHAR(25) NOT NULL, 
duracao_min SMALLINT,
nacionalidade_Filme VARCHAR(20) NOT NULL,
situacao_Filme CHAR(15),
PRIMARY KEY (cod_filme)) ;
-- adicionando a coluna genero
ALTER TABLE filme ADD COLUMN genero CHAR(15) NOT NULL ;
-- mostrando a estrutura
-- DESCRIBE tabela ; -- não funciona
-- SHOW TABLE tabela ; -- não funciona
SELECT table_name AS "Nome Tabela", column_name AS "Coluna",
data_type AS "Tipo de Dado" , is_nullable AS "Permite nulo"
FROM information_schema.columns
WHERE table_name = 'filme' ;
-- tabela sala
DROP TABLE IF EXISTS sala CASCADE ;
CREATE TABLE sala (
Nome_sala CHAR(20) PRIMARY KEY,
Capacidade SMALLINT NOT NULL,
Tipo_Sala CHAR(20),
tipo_Projecao CHAR(15),
Tipo_Audio CHAR(15),
Dim_tela VARCHAR(20),
Situacao_Sala CHAR(10) NOT NULL 
      CHECK (situacao_sala IN ('ATIVA', 'INATIVA', 'MANUTENCAO'))) ;
-- tabela sessao
DROP TABLE IF EXISTS sessao CASCADE ;
CREATE TABLE sessao
(Num_Sessao SERIAL PRIMARY KEY,
 Dt_sessao DATE NOT NULL,
 Tipo_projecao CHAR(20),
 Idioma CHAR(15) NOT NULL,
 Dubl_Leg CHAR(9) NOT NULL,
 Preco_Ingresso NUMERIC(8,2) NOT NULL ,
 Publico SMALLINT ,
 cod_filme INTEGER NOT NULL, 
Nome_sala CHAR(20) NOT NULL,
 Cod_hora_exibicao SMALLINT NOT NULL,
 Situacao_sessao CHAR(15) ,
 FOREIGN KEY (cod_filme) REFERENCES filme (cod_filme) 
        ON DELETE CASCADE ON UPDATE CASCADE , -- acao referencial 
 FOREIGN KEY (nome_sala) REFERENCES sala (nome_sala) 
        ON DELETE CASCADE ON UPDATE CASCADE ,
 FOREIGN KEY (cod_hora_exibicao) REFERENCES horario (cod_hora)
        ON DELETE CASCADE ON UPDATE CASCADE ) ;
-- adicionando um check em dubl_leg
ALTER TABLE sessao ADD CHECK (dubl_leg IN ('DUBLADO', 'LEGENDADO')) ;
-- tabela artista
DROP TABLE IF EXISTS artista CASCADE ;
CREATE TABLE artista (
Cod_artista INTEGER PRIMARY KEY,
Nome_artista VARCHAR(25) NOT NULL,
Nacionalidade_artista CHAR(15),
Sexo_artista CHAR(1) NOT NULL CHECK (sexo_artista IN ('M', 'F') ) ) ;
-- tabela elenco filme
DROP TABLE IF EXISTS elenco_filme CASCADE ;
CREATE TABLE elenco_filme (
Cod_artista INTEGER NOT NULL REFERENCES artista ON DELETE CASCADE ON UPDATE CASCADE ,
Cod_filme INTEGER NOT NULL REFERENCES filme ON DELETE CASCADE ON UPDATE CASCADE ,
Tipo_participacao CHAR(15) NOT NULL,
	PRIMARY KEY ( cod_artista, cod_filme) ) ;
-- adicionando o personagem
ALTER TABLE elenco_filme ADD COLUMN personagem VARCHAR(20 ) ,
                         ADD COLUMN cache_pago NUMERIC(10,2) ;
						 
/* Atividade 6 
1- Montar o script em SQL para a criação das tabelas EM VERDE no SGBD Postgresql tomando como base o esquema de relações mapeado em aula , com as seguintes características : 
a) Considere as seguintes auto-numerações :
	a1) Número de Ingresso.
a2) Numero da sessão.
b) Ações referenciais ON DELETE ON UPDATE
c) Colunas que indicam instante de tempo com o tipo de dado correspondente (DATE ou TIMESTAMP).*/
-- Assento Ingresso, Forma de Pagamento, Funcionário, Escala de Trabalho e Escala Funcionário
-- tabela ASSENTO
DROP TABLE IF EXISTS assento CASCADE ;
CREATE TABLE assento
( num_assento SMALLINT NOT NULL,
fileira_assento CHAR(1) NOT NULL,
nome_sala CHAR(25) NOT NULL REFERENCES sala ON DELETE CASCADE ON UPDATE CASCADE,
tipo_assento CHAR(15) NOT NULL,
situacao_assento CHAR(15),
PRIMARY KEY(num_assento, fileira_assento, nome_sala)) ;

-- tabela Funcionário
DROP TABLE IF EXISTS funcionario CASCADE ;
CREATE TABLE funcionario
( cod_funcional INTEGER PRIMARY KEY ,
nome_func VARCHAR(50) NOT NULL,
sexo_func CHAR(1) NOT NULL CHECK ( sexo_func IN ('M', 'F')),
dt_nascto_func DATE NOT NULL,
end_func VARCHAR(100) NOT NULL, 
dt_admissao DATE NOT NULL,
num_ctps INTEGER NOT NULL,
UNIQUE(num_ctps)); -- chave alternativa (AK) 

-- escala trabalho
DROP TABLE IF EXISTS escala_trabalho CASCADE;
CREATE TABLE escala_trabalho
( num_escala INTEGER PRIMARY KEY,
dia_semana CHAR(15) NOT NULL,
horario_inicio SMALLINT NOT NULL REFERENCES horario,
horario_termino SMALLINT NOT NULL REFERENCES horario);

-- escala do funcionario
DROP TABLE IF EXISTS escala_funcionario CASCADE;
CREATE TABLE escala_funcionario
( num_escala INTEGER NOT NULL REFERENCES escala_trabalho ON DELETE CASCADE ON UPDATE CASCADE,
cod_funcional INTEGER NOT NULL REFERENCES funcionario ON DELETE CASCADE ON UPDATE CASCADE,
dt_inicio DATE NOT NULL,
funcao CHAR(15) NOT NULL,
PRIMARY KEY ( num_escala, cod_funcional, dt_inicio)) ;

-- ingresso
DROP TABLE IF EXISTS ingresso CASCADE ;
CREATE TABLE ingresso
( num_ingresso SERIAL PRIMARY KEY ,
tipo_ingresso CHAR(15) NOT NULL,
vl_pago NUMERIC(10,2) NOT NULL,
forma_pgto CHAR(20) NOT NULL,
num_assento SMALLINT NOT NULL,
fileira_assento CHAR(1) NOT NULL,
nome_sala CHAR(25) NOT NULL,
num_sessao INTEGER NOT NULL REFERENCES sessao ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY ( num_assento, fileira_assento, nome_sala) REFERENCES assento) ;

-- tabela Forma de Pagamento
DROP TABLE IF EXISTS forma_pgto CASCADE ;
CREATE TABLE forma_pgto
(cod_forma_pgto CHAR(5) PRIMARY KEY, 
 tipo_forma_pgto VARCHAR(20),
 situacao_Forma_pgto CHAR(10)) ;

-- acertando em ingresso
ALTER TABLE ingresso ALTER COLUMN forma_pgto TYPE CHAR(5) ;
ALTER TABLE ingresso ADD FOREIGN KEY (forma_pgto) REFERENCES forma_pgto ;

/* 2- Com o comando ALTER TABLE : 
a) Inclua  uma nova coluna em Funcionário : Data de desligamento
b) Crie as seguintes constraints de verificação : 
		Função em Escala-Funcionário : Caixa, Atendente, Gerente
		Tipo em Assento : Normal, PNE (Portador Necessidades Especiais), Largo */

--a)
ALTER TABLE funcionario ADD COLUMN dt_desligamento DATE NULL;
--b1)
ALTER TABLE escala_funcionario ADD CHECK ( funcao IN ('CAIXA', 'ATENDENTE', 'GERENTE'));
ALTER TABLE assento ADD CHECK ( tipo_assento IN ('PNE', 'NORMAL', 'LARGO')) ;
	
/**** Aula 09/maio SQL DDL ALTER TABLE + SQL DML Insert,update,delete ***/
-- DDL ALTER table
-- adicionando nova coluna em sessao
ALTER TABLE sessao ADD COLUMN renda_sessao NUMERIC(12,2) ;
-- renomeando uma coluna
ALTER TABLE sessao RENAME COLUMN renda_sessao TO renda_total ;
-- estrutura
SELECT table_name AS "Nome Tabela", column_name AS "Coluna",
data_type AS "Tipo de Dado" , is_nullable AS "Permite nulo"
FROM information_schema.columns
WHERE table_name = 'filme' ;
-- renomeando uma tabela
ALTER TABLE sessao RENAME TO sessao_filme ;
-- definindo um valor padrão para uma coluna
ALTER TABLE sessao_filme ALTER COLUMN preco_ingresso SET DEFAULT 45.00 ;
ALTER TABLE sessao_filme ALTER COLUMN dt_sessao SET DEFAULT current_date ;
-- funcoes de data e data hora
SELECT current_date AS Data, current_timestamp AS "Data Hora", now() AS "Data Hora Postgresql" ;
-- alterando um tipo de dado
ALTER TABLE filme ALTER COLUMN ano_lancto TYPE INTEGER ;
-- adicionando novos CHECKS
ALTER TABLE sessao_filme ADD CHECK ( preco_ingresso >= 0 ) ;
ALTER TABLE sessao_filme ADD CONSTRAINT chk_dt_sessao CHECK (dt_sessao >= current_date ) ;
-- desabilitando uma constraint
ALTER TABLE sessao_filme DROP CONSTRAINT chk_dt_sessao ;
-- situacao sessao
ALTER TABLE sessao_filme ADD CHECK (situacao_sessao IN ('AGENDADA', 'CANCELADA', 'CONCLUIDA')) ;

-- populando, atualizando e excluindo -> DML
-- artista
SELECT * FROM artista ;
INSERT INTO artista VALUES ( 1, 'Fernanda Montenegro', 'Brasil', 'F') ;
INSERT INTO artista VALUES ( 2, 'Al Pacino', 'EUA', 'M') ;
-- filme
SELECT * FROM filme ;
INSERT INTO filme VALUES ( 1000, 'Central do Brasil', 'Central do Brasil', 1998, 1997, 'Portugues', 'Livre',
						   'Embrafilme', 113, 'Brasil', 'CATALOGO', 'Drama') ;
INSERT INTO filme VALUES ( 1001, 'Poderoso Chefao', 'The Godfather', 1972, 1972, 'Ingles', '16 anos',
						   'Paramount', 175 , 'Brasil', 'CATALOGO', 'Drama, Crime') ;
-- elenco filme
SELECT * FROM elenco_filme ;
INSERT INTO elenco_filme VALUES (1, 1000, 'Atriz', 'Dora', 100000 ) ;
INSERT INTO elenco_filme VALUES (2, 1001, 'Ator', 'Michael Corleone', 1000000 ) ;

-- DELETE FROM elenco_filme ;
ALTER TABLE elenco_filme ALTER COLUMN cache_pago TYPE NUMERIC(12,2) ;
ALTER TABLE elenco_filme ALTER COLUMN personagem TYPE VARCHAR(25) ;
-- outra forma de verificar a estrutura das tabela usando o comando de linha
-- psql -h localhost -p 5432 -dcinemaL01 -U postgres 
-- \d nome_tabela
-- sala
SELECT * FROM sala ;
INSERT INTO sala VALUES ( 'Ouro', 250, 'Anfiteatro', '3D', 'Dolby Surround', '12x5', 'ATIVA') ;
-- sessao
SELECT * FROM sessao_filme  ;
-- alterando os parametros da sequence
ALTER SEQUENCE sessao_num_sessao_seq RESTART WITH 23000 ;
ALTER SEQUENCE sessao_num_sessao_seq
INCREMENT BY 1 MAXVALUE 50000 NO CYCLE ;
-- populando
INSERT INTO sessao_filme VALUES ( default, default, '4K', 'Portugues', 'DUBLADO', 45, 0,  1000, 'Ouro',
						  1, 'AGENDADA', 0.0 ) ;
SELECT * FROM sessao_filme ;

/* Atividade 07 : Utilizando a linguagem SQL 
1 – Popular as tabelas em verde (criadas na atividade 6) : insira duas linhas em cada tabela */
-- horario
SELECT * FROM horario ;
INSERT INTO horario VALUES ( 3, '17:00') ;
INSERT INTO horario VALUES ( 4, '18:00') ;
INSERT INTO horario VALUES ( 5, '20:00') ;
INSERT INTO horario VALUES ( 6, '22:00') ;
--  assento ;
SELECT * FROM assento ;
SELECT * FROM sala ;
-- + 1 sala
INSERT INTO sala VALUES ( 'Prata', 180, 'Anfiteatro', '3D', 'Dolby Surround', '12x5', 'ATIVA') ;
INSERT INTO assento VALUES ( 1, 'A', 'Ouro', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 2, 'A', 'Ouro', 'PNE', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 3, 'A', 'Ouro', 'LARGO', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 11, 'C', 'Ouro', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 21, 'C', 'Ouro', 'PNE', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 31, 'C', 'Ouro', 'LARGO', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 5, 'B', 'Ouro', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 6, 'B', 'Ouro', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 7, 'B', 'Ouro', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 1, 'A', 'Prata', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 2, 'A', 'Prata', 'PNE', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 3, 'A', 'Prata', 'LARGO', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 11, 'G', 'Prata', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 12, 'G', 'Prata', 'PNE', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 13, 'G', 'Prata', 'LARGO', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 10, 'B', 'Prata', 'NORMAL', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 20, 'B', 'Prata', 'PNE', 'DISPONIVEL') ;
INSERT INTO assento VALUES ( 30, 'B', 'Prata', 'LARGO', 'DISPONIVEL') ;
-- forma de pagamento
SELECT * FROM forma_pgto ;
INSERT INTO forma_pgto VALUES ( 'DIN', 'DINHEIRO', 'ATIVO' ) ;
INSERT INTO forma_pgto VALUES ( 'CCRED', 'CARTAO CREDITO', 'ATIVO' ) ;
INSERT INTO forma_pgto VALUES ( 'PIX', 'PIX' , 'ATIVO' ) ;
-- ingresso
SELECT * FROM ingresso ;
SELECT * FROM sessao_filme ;
SELECT * FROM filme ;
-- + 1 sessao
INSERT INTO sessao_filme VALUES ( default, default, '4K', 'Ingles', 'LEGENDADO', 45, 0,  1001, 'Prata',
						  5, 'AGENDADA', 0.0 ) ;
INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00,  'DIN', 1, 'A', 'Ouro', 23000 ) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00, 'PIX', 2, 'A', 'Ouro', 23000) ;
INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00,  'DIN', 1, 'A', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00,  'PIX', 3, 'A', 'Ouro', 23000) ;
INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00, 'DIN', 2, 'A', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00, 'PIX', 3, 'A', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default, 'MEIA', 25.00, 'DIN', 5, 'B', 'Ouro', 23000) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00,  'CCRED', 11, 'G', 'Prata', 23001) ;

INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00,  'CCRED',  21, 'C', 'Ouro', 23000) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00, 'PIX', 12, 'G', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00, 'PIX', 6, 'B', 'Ouro', 23000) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00,  'DIN',13, 'G', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00,  'CCRED',10, 'B', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00, 'PIX', 7, 'B', 'Ouro', 23000) ;
INSERT INTO ingresso VALUES ( default , 'MEIA', 25.00, 'CCRED', 20, 'B', 'Prata', 23001) ;
INSERT INTO ingresso VALUES ( default , 'INTEIRA', 50.00,  'CCRED',  30, 'B', 'Prata', 23001) ;

-- funcionário
SELECT * FROM Funcionario ;
INSERT INTO funcionario VALUES ( 1000, 'Jose de Arimateia','M', '10/10/1980', 'Rua Amarela, 10', 
current_date - 500, 123456, null) ;
INSERT INTO funcionario VALUES ( 1001, 'Maria Conceicao dos Santos','F', '15/12/1988', 'Rua Azul, 20', 
current_date - 300, 987654, null) ;
INSERT INTO funcionario VALUES ( 1002, 'Tereza Baptista Silva','F', '05/02/1978', 'Rua Verde, 30', 
'10/01/2016', 658734, null) ;
INSERT INTO funcionario VALUES ( 1003, 'Joao de Castro e Souza','M', '10/01/1970', 'Rua Branca, 10', 
current_date - 100, 765432, null) ;
INSERT INTO funcionario VALUES ( 1004, 'Carla Marinho','F', '05/05/1978', 'Rua Vermelha, 20', 
current_date - 120, 342176, null) ;
INSERT INTO funcionario VALUES ( 1005, 'Francine Oliver','F', '25/02/1996', 'Rua Verde, 50', 
'10/11/2016', 543734, null) ;

-- escala trabalho
SELECT * FROM escala_trabalho ;
INSERT INTO escala_trabalho VALUES ( 1,  'Segunda-Feira', 1, 5 ) ;
INSERT INTO escala_trabalho VALUES ( 2,  'Segunda-Feira', 4, 6 ) ;
INSERT INTO escala_trabalho VALUES ( 3,  'Terca-Feira', 1, 5 ) ;
INSERT INTO escala_trabalho VALUES ( 4,  'Terca-Feira', 4, 6 ) ;
INSERT INTO escala_trabalho VALUES ( 5,  'Quarta-Feira', 1, 5 ) ;
INSERT INTO escala_trabalho VALUES ( 6,  'Quarta-Feira', 4, 6 ) ;

-- escala de atendimento
SELECT *  FROM escala_funcionario ;
INSERT INTO escala_funcionario VALUES ( 1, 1001, current_date - 21, 'CAIXA') ;
INSERT INTO escala_funcionario VALUES ( 1, 1002, current_date - 21,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 3, 1001, current_date - 21,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 3, 1002, current_date - 21,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 3, 1003, current_date - 21,'CAIXA') ;
INSERT INTO escala_funcionario VALUES ( 2, 1001, current_date - 14,'CAIXA') ;
INSERT INTO escala_funcionario VALUES ( 2, 1002, current_date - 14,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 4, 1001, current_date - 7,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 4, 1002, current_date - 7,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 4, 1003, current_date - 7,'CAIXA') ;
INSERT INTO escala_funcionario VALUES ( 5, 1001, current_date ,'CAIXA') ;
INSERT INTO escala_funcionario VALUES ( 5, 1002, current_date ,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 6, 1001, current_date + 7, 'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 6, 1002, current_date + 7,'ATENDENTE') ;
INSERT INTO escala_funcionario VALUES ( 6, 1003, current_date + 7,'ATENDENTE') ;

/* 2 – Após popular as tabelas em verde,  transforme as colunas Nacionalidade em Artista e Filme
em uma tabela auxiliar com Código e Nome do País, por exemplo :
código 01, nome Brasil. Estabeleça o relacionamento e atualize os dados nas tabelas de origem */

DROP TABLE nacionalidade CASCADE ;
CREATE TABLE nacionalidade 
( cod_pais SMALLINT PRIMARY KEY,
nome_pais CHAR(25) NOT NULL ) ;

INSERT INTO nacionalidade VALUES ( 1 , 'BRASIL') ;
INSERT INTO nacionalidade VALUES ( 2 , 'ESTADOS UNIDOS DA AMERICA') ;
INSERT INTO nacionalidade VALUES ( 3, 'INGLATERRA') ;
INSERT INTO nacionalidade VALUES ( 4, 'AUSTRALIA') ;
INSERT INTO nacionalidade VALUES ( 5, 'ARGENTINA') ;
-- filme
ALTER TABLE filme ADD cod_nacionalidade SMALLINT  ;
SELECT * FROM filme ;
UPDATE filme SET nacionalidade_filme = 'EUA' WHERE cod_filme = 1001 ;
UPDATE filme
 SET cod_nacionalidade = 1
   WHERE UPPER(nacionalidade_filme) LIKE '%BRASIL%' ;
UPDATE filme
 SET cod_nacionalidade = 2
   WHERE UPPER(nacionalidade_filme) LIKE '%EUA%' ;
-- declarando como FK
ALTER TABLE filme ADD CONSTRAINT fk_nacionalidadefilme FOREIGN KEY ( cod_nacionalidade)
REFERENCES nacionalidade (cod_pais) ;

 -- artista
ALTER TABLE artista ADD cod_nacionalidade SMALLINT  ;
SELECT * FROM artista ;
UPDATE artista
 SET cod_nacionalidade = 1
   WHERE UPPER(nacionalidade_artista) LIKE '%BRASIL%' ;
UPDATE artista
 SET cod_nacionalidade = 2
   WHERE UPPER(nacionalidade_artista) LIKE '%EUA%' ;
   
-- declarando como FK
ALTER TABLE artista ADD CONSTRAINT fk_nacionalidadeartista FOREIGN KEY ( cod_nacionalidade)
REFERENCES nacionalidade (cod_pais) ;  
-- Excluindo coluna nacionalidade
ALTER TABLE filme DROP COLUMN nacionalidade_filme;
-- Definir a fk como not null
ALTER TABLE filme ALTER COLUMN cod_nacionalidade SET NOT NULL;
-- Excluindo coluna nacionalidade
ALTER TABLE artista DROP COLUMN nacionalidade_artista;
-- Definir a fk como not null
ALTER TABLE artista ALTER COLUMN cod_nacionalidade SET NOT NULL;

/***************************************
Aula 16/05 - DQL Selects com função caracter e data, junção interna.
*********************************************/
-- Sintaxe geral de um select
-- SELECT coluna1,coluna2,..... FROM tabela1,tabela2,.... WHERE condicao1 AND condicao2 OR condicao3;
-- 1 -- Funções de formatação - UPPER (CAPSLOCK), LOWER(MINUSCULO), INITCAP(PRIMERIA LETRA MAIUSCULO)
SELECT * FROM filme;
SELECT UPPER(titulo_filme) AS Maisculo, ano_lancto, LOWER(estudio) AS Minusculo, 
	INITCAP(situacao_filme) AS "Primeira Maiusc, demains minusc" 
		FROM filme 
			WHERE ano_lancto > 1970;
-- 2 -- Operador de concatenação - concatena as strings eliminando os espaços entre elas
-- SELECT 'Aula de Banco de Dados '||' em 16/05 '||' no IMT.';
-- Dados da sala no formato Sala ABC tem a capacidade N lugares, é do tipo 'tipo_sala', com audio 'tipo_audio' e
-- projeção 'tipo_projecao'.
SELECT 'Sala '||nome_sala||', tem a capacidade de '||capacidade||' lugares, é do tipo '||tipo_sala||' com audio '
	||tipo_audio|| ' e projeção '||tipo_projecao AS "Dados Sala"
		FROM sala; 
-- 3 -- Operador LIKE - Busca não exata
-- filmes com Brasil no titulo -- O '%' é um coringa, é uma máscara que independe o que vem antes e depois.
SELECT titulo_filme, genero FROM filme WHERE UPPER(titulo_filme) LIKE '%BRASIL%';
-- Buscando Brasil ou Brazil -- O '_' é uma máscara para apenas 1 char.
SELECT titulo_filme, genero FROM filme WHERE UPPER(titulo_filme) LIKE '%BRA_IL%';
-- Buscando atores de nome João, Joao
SELECT nome_artista FROM artista WHERE LOWER (nome_artista) LIKE '%jo_o%';
-- Nome começa com João
SELECT nome_artista FROM artista WHERE LOWER (nome_artista) LIKE 'jo_o%';
-- Termina com Negro
SELECT nome_artista FROM artista WHERE LOWER (nome_artista) LIKE '%negro';
-- Funções de data
-- 4 -- Principais funções de data no postgres
SELECT current_date AS "Data D-M-Y", current_timestamp AS "Data-Hora com timezone",
	localtimestamp AS "Data-Hora sem timezone", localtime AS "Hora sem timezone",
		now() AS "Idem current_timestamp";
-- 5 -- Extraindo pedaços da data: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, WEEK
SELECT EXTRACT(YEAR FROM current_date) AS Ano,
		EXTRACT(MONTH FROM current_date) AS Mes,
		EXTRACT(Day FROM current_date) AS Dia,
		EXTRACT(HOUR FROM current_timestamp) AS Hora,
		EXTRACT(Minute FROM current_timestamp) AS Minuto,
		EXTRACT(SECOND FROM current_timestamp) AS Segundo,
		EXTRACT(WEEK FROM current_date) AS Semana_do_ano;
-- 6 -- Monstrar os funcionários admitidos no ano passado.
SELECT nome_func, dt_admissao FROM funcionario WHERE EXTRACT(YEAR FROM dt_admissao) = EXTRACT(YEAR FROM current_date) - 1;
-- 7 -- Calcular a idade dos funcionarios
SELECT nome_func, dt_nascto_func, TRUNC((current_date - dt_nascto_func)/365.25) AS Idade
	FROM funcionario ORDER BY Idade DESC;
-- 8 -- Operador INTERVAL - Adiciona ou subtrai intervalos de data
-- data daqui a 3 meses.
SELECT current_date + INTERVAL '3' MONTH, current_date - INTERVAL '5' YEAR,
	current_timestamp + INTERVAL '24' HOUR;
SELECT current_date + 7;
/*********************************************************
		Junção - Selects com mais de uma tabela
*********************************************************/
-- 9 -- Filme e a nacionalidade do filme
SELECT filme.titulo_filme, filme.genero, nacionalidade.nome_pais FROM filme, nacionalidade
	WHERE filme.cod_nacionalidade = nacionalidade.cod_pais;
-- 10 -- Idem ao 9, usando apelidos paras as tabelas a linha do where é o join, 
-------- se não colocar ela, o banco faz produto cartesiano de tudo e pode quebrar o banco.
SELECT f.titulo_filme, f.genero, n.nome_pais FROM filme f, nacionalidade n
	WHERE f.cod_nacionalidade = n.cod_pais;
-- 11 -- Usando a sixtaxe do INNER JOIN
SELECT f.titulo_filme, f.genero, n.nome_pais FROM filme f INNER JOIN nacionalidade n
	ON (f.cod_nacionalidade = n.cod_pais);
-- N° Joins = N° Tabelas - 1
-- 12 -- Utilizando 3 tabelas
SELECT f.titulo_filme, a.nome_artista, ef.tipo_participacao, ef.personagem
	FROM filme f, artista a, elenco_filme ef
		WHERE f.cod_filme = ef.cod_filme 			-- JOIN filme x elenco
			AND ef.cod_artista = a.cod_artista; 	-- JOIN artista x elenco
-- 13 -- Sintaxe INNER JOIN
SELECT f.titulo_filme, a.nome_artista, ef.tipo_participacao, ef.personagem
FROM filme f JOIN elenco_filme ef ON (f.cod_filme = ef.cod_filme) JOIN artista a
ON (ef.cod_artista = a.cod_artista) WHERE f.ano_lancto BETWEEN 1970 AND 2000;









