/*
Linguagem SQL - é a linguagem do SGBDR
-------------------------------------------------
EXERCÍCIOS Parte 1
Projeto do BDCartaoCreditoIFSP
IFSP - Barretos
Data: 2025
Prof. Xyko Almeida
-------------------------------------------------------
Objetivo: Trabalhar com consultas,Visões,
funções (fx) e Procedures (sp) em Banco de DADOS
------------------------------------------------------
*/

-- abrir o BD de trabalho.
use BDCartaoCreditoIFSP;
-------------------------------------


/*
consulta = retorno de dados
EXERCÍCIOS 1
Faça um consulta que retorne:
Da tabela TBCliente: o nome e sobrenome do cliente, seu bairro
Campo a ser construído: Calcular/totalizar os débitos (tipo 1)
campo criado: contar quantos débitos tem por cliente
-- uso da função de agregação: sum(), avg(), count() ...
*/
----------




select c.IDCliente [Código Cliente],
       c.Nome     Cliente,
	   c.Sobrenome,
	   c.Bairro,
--Construir os campos
     count(l.CodCartao) [Quantidade de Débitos],
	 Sum(l.ValorLancamento)              [Total de Débitos]
from TBCliente c
join TBCartaoCredito cc
--escrever o relacionamento(pk=fk)
on (c.IDCliente = cc.CodCliente)
join  TBLancamentoCartao    l
--escrevo o relacionamento(pk=fk)
on (cc.IDCartao=CodCartao)
--filtro de débito
and l.Tipolancamento = 1
group by c.IDCliente,  c.Nome , c.Sobrenome, c.Bairro
order by 6 desc


--fazer uma view do exercicio 1 
Create view VRetornaDebitosCliente
as

select c.IDCliente [Código Cliente],
       c.Nome     Cliente,
	   c.Sobrenome,
	   c.Bairro,
--Construir os campos
     count(l.CodCartao) [Quantidade de Débitos],
	 Sum(l.ValorLancamento)              [Total de Débitos]
from TBCliente c
join TBCartaoCredito cc
--escrever o relacionamento(pk=fk)
on (c.IDCliente = cc.CodCliente)
join  TBLancamentoCartao    l
--escrevo o relacionamento(pk=fk)
on (cc.IDCartao=CodCartao)
--filtro de débito
and l.Tipolancamento = 1
group by c.IDCliente,  c.Nome , c.Sobrenome, c.Bairro



--mostrar execução da view

select*from VRetornaDebitosCliente
Order by 6 desc

--fzr função logica da view
--receb paremetro e retorna vendas desse cleinte 


--checar
--teste santo thorme
--teste 1 
--trazer os cartoes de crédito da maria
select*
from   TBCartaoCredito a
where  a.CodCliente = 2 
---------------------
--teste 2
select *
from TBLancamentoCartao m
where m.CodCartao in(4050, 5040)
and  m.TipoLancamento=1


-- 1.1 mesmo exercício com inner 
Select		c.Nome			Cliente,
				c.sobrenome,
				c.Bairro,
				-- construir colunas no select
				Sum (l.ValorLancamento)    [Total Débitos],  -- soma
				count (l.CodCartao)		        [Qtde Débitos]    -- contar
-- traz as tabelas
from			TBCliente							c
join			TBCartaoCredito				cc
on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
join		   TBLancamentoCartao		 l
on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
-- como eu trabalhar com função agregação (soma, média máximo, mínimo)
and			(l.TipoLancamento = 1)      -- filtro (1 = débito)
group by   c.Nome, c.sobrenome, c.Bairro
order by     1
-------------------------------------------------------------
-- Saber se acertou o exercício
--- Teste de Santo Thome -------
--  Teste 1
-- Cliente lais id = 6
-- acho os cartões da lais
-- cartão 5020
Select	 *
from	 TBCartaoCredito   c
where   c.CodCliente = 6   -- fitro 
----------------------------------
-- teste 2
-- Total dèbito da Lais = 145,64
Select	   sum (l.ValorLancamento)		[total Debitos],
               count(l.CodCartao)				[Total de lançamentos Débito]
from			TBLancamentoCartao   l
where		l.CodCartao = 5020       -- cartao da Lais
and			l.TipoLancamento = 1   -- tipo débito
-----------------------------------------




-- 1.2) criar uma visão ...
-- guardar no BD o select complexo
Create view VDebitosPorCliente
AS
	Select		c.Nome			Cliente,
					c.sobrenome,
					c.Bairro,
					-- construir colunas no select
					Sum (l.ValorLancamento)    [Total Débitos],  -- soma
					count (l.CodCartao)		        [Qtde Débitos]    -- contar
	-- traz as tabelas
	from			TBCliente							c
	join			TBCartaoCredito				cc
	on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
	join		   TBLancamentoCartao		 l
	on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
	-- como eu trabalhar com função agregação (soma, média máximo, mínimo)
	and			(l.TipoLancamento = 1)      -- filtro (1 = débito)
	group by   c.Nome, c.sobrenome, c.Bairro
	
-----------------------------------------
-- executar a visão
Select * from  VDebitosPorCliente
Order by 1
----------------------------

/* 
-- para individualizar (customizar) as consultas
1.3) Quero estes dados apenas de um único cliente
Criar uma "função" e depois uma "procedure" que recebe um 
parâmentro e filtra pelo parâmento
-- criar uma função
-- filtrar pelo código do cliente
*/
Create function fxRetornaDebitoCliente (@CodCliente int)
Returns table as return
(
	Select		c.IDCliente   [Código Cliente],
	                c.Nome			Cliente,
					c.sobrenome,
					c.Bairro,
					-- construir colunas no select
					Sum (l.ValorLancamento)    [Total Débitos],  -- soma
					count (l.CodCartao)		        [Qtde Débitos]    -- contar
	-- traz as tabelas
	from			TBCliente							c
	join			TBCartaoCredito				cc
	on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
	join		   TBLancamentoCartao		 l
	on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
	-- como eu trabalhar com função agregação (soma, média máximo, mínimo)
	and			(l.TipoLancamento = 1)      -- filtro (1 = débito)
	-- filtro pelo parâmentro recebido
	and       (c.IDCliente = @CodCliente)
	group by   c.IDCliente, c.Nome, c.sobrenome, c.Bairro
)
---------------------------------------------------
-- executar a função
Select * from fxRetornaDebitoCliente (6);
Select * from fxRetornaDebitoCliente (4);
Select * from fxRetornaDebitoCliente (1);
-------------------------------------

/*
1.4) criando uma procedure para a função 1.3)
-- copie e colei a função
*/
-- criar a procedure
Create procedure spRetornaDebitoCliente (@CodCliente int)
AS
BEGIN
	Select		c.IDCliente   [Código Cliente],
	                c.Nome			Cliente,
					c.sobrenome,
					c.Bairro,
					-- construir colunas no select
					Sum (l.ValorLancamento)    [Total Débitos],  -- soma
					count (l.CodCartao)		        [Qtde Débitos]    -- contar
	-- traz as tabelas
	from			TBCliente							c
	join			TBCartaoCredito				cc
	on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
	join		   TBLancamentoCartao		 l
	on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
	-- como eu trabalhar com função agregação (soma, média máximo, mínimo)
	and			(l.TipoLancamento = 1)      -- filtro (1 = débito)
	-- filtro pelo parâmentro recebido
	and       (c.IDCliente = @CodCliente)
	group by   c.IDCliente, c.Nome, c.sobrenome, c.Bairro
END
-----------------------------------------------------------
--executar a procedure
EXEC spRetornaDebitoCliente 1;
EXEC spRetornaDebitoCliente 4;
EXEC spRetornaDebitoCliente 5;

---------------------------------------------------------
/*
Exercício 2
Listar os clientes: ID, Nome, Sobrenome
Contar Qtde cartões tem
*/
-- Lógica dos relacionamentos das duas tabelas
Select		c.IDCliente   [Código Cliente],
				c.Nome,
				c.sobrenome,
				count (a.CodCliente)	[Qtde Cartao]
From		TBCliente					c
join		    TBCartaoCredito		a
on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
Group by	c.IDCliente , c.Nome, c.sobrenome
order by   4 desc
---------------------------
-- Teste de Santo Thomé ----
-- Maria Lima = 2 (4050, 5040)
Select		* 
from			TBCartaoCredito   c
where		c.CodCliente = 2  -- filtro]
-- 4050 e 5040
-----------------------------------

--2.1) cria uma view (visão) da exe 2)
Create view VQtdeCartaoCliente
As
		Select		c.IDCliente   [Código Cliente],
						c.Nome,
						c.sobrenome,
						count (a.CodCliente)	[Qtde Cartao]
		From		TBCliente					c
		join		    TBCartaoCredito		a
		on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
		Group by	c.IDCliente , c.Nome, c.sobrenome
	
-------------------------------------------
-- executar/mostrar a view
Select	 * 
from		  VQtdeCartaoCliente
order	  by 3 
------------------------------
/*
2.2) Criar uma procedure para o execicio 2.1.
       tem que receber o parãmentro Código Cliente
*/
Create Procedure spRetornaQtdeCartaoCliente (@CodCliente int)
As
Begin
	Select		c.IDCliente   [Código Cliente],
					c.Nome,
					c.sobrenome,
					count (a.CodCliente)	[Qtde Cartao]
	From		TBCliente					c
	join		    TBCartaoCredito		a
	on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
	and           (c.IDCliente = @CodCliente)   -- filtrar pelo parâmetro
	Group by	c.IDCliente , c.Nome, c.sobrenome
End
-----------------------------------------------------------
-- executa aprocedure (stredo procedere)
Exec spRetornaQtdeCartaoCliente 2;
Exec spRetornaQtdeCartaoCliente 4;
Exec spRetornaQtdeCartaoCliente 6;
---------------------------------------------

-- Criar uma Função a aprtir da Procedure
/*
2.3) Criar uma função para o execicio 2.1.
       tem que receber o parâmentro Código Cliente
*/
Create function fxRetornaQtdeCartaoCliente (@CodCliente int)
Returns table as return
(
	Select		c.IDCliente   [Código Cliente],
					c.Nome,
					c.sobrenome,
					count (a.CodCliente)	[Qtde Cartao]
	From		TBCliente					c
	join		    TBCartaoCredito		a
	on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
	and           (c.IDCliente = @CodCliente)   -- filtrar pelo parâmetro
	Group by	c.IDCliente , c.Nome, c.sobrenome
)
-----------------------------------------------------------
-- Como usar (executar) a função
Select * from fxRetornaQtdeCartaoCliente (2);
Select * from fxRetornaQtdeCartaoCliente (4);
Select * from fxRetornaQtdeCartaoCliente (5);
-----------------------------------------------------------


/*
EXERCÍCIOS 3
Faça um consulta que retorne:
Da tabela TBCliente: o nome e sobrenome do cliente, seu bairro
Campo a ser construído: Calcular/Totalizar os Créditos (tipo 2)
Campo criado: contar quantos créditos tem por cliente
-- uso da função de agregação: sum(), avg() ...
*/
-- versão com inner join
-------------------------------------
-- 3.1)
Select		c.Nome					Cliente,
				c.sobrenome,
				c.Bairro,
				Sum (l.ValorLancamento)			[Total Credito],		-- soma
				count (l.CodCartao)					[Qtde Credito]			-- contar
from			TBCliente							c
inner join  TBCartaoCredito				cc
on            (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
join			TBLancamentoCartao		l
on 			(cc.IDCartao   = l.CodCartao)     -- relacionamento 2
-- como eu trabalhar com função agregação (soma, média máximo, mínimo)
and			(l.TipoLancamento = 2)      -- filtro (2 = crédito)
group by   c.Nome, c.sobrenome, c.Bairro
order by     2
-----------------------------------
-- teste de Santo Thomé ---
-- Maria Lima = 2
-- cartões = (4050, 5040)
Select * 
from TBCartaoCredito   c
where c.CodCliente = 2
-----------------------------------------
-- teste 2 
Select * 
from TBLancamentoCartao     l
Where  l.CodCartao  in (4050, 5040)   -- no conjunto (4050, 5040)
and		l.TipoLancamento = 2      -- ser crédito (tipo 2)
------------------------------------------------------------------

-- 3.2) Criar uma view
----------------------------------
-- Executar a visão

----------------------------------

-- 3.3) criar uma uma função a partir da view 3.2)
-- Recebe como parãmetro código Cliente

------------------------------------------------------------
-- 3.4) criar uma uma procedure  a partir da função 3.3)
-- Recebe como parãmetro código Cliente

------------------------------------------------------------
 
 /*
EXERCÍCIO-4
Faça um consulta que retorne:
Mostre o nome do cliente, sobrenome e a sua renda convertida em dolar e euro.
Considerar 1 dolar a = 5.60: e 1 euro  = 6,60
*/

SELECT	c.Nome,
				c.Sobrenome,
				-- formata o número padrão real brasileiro
				format (c.RendaAnual, 'C', 'pt-br') 				 [Renda anual em Real],
				-- formatar para aparecer duas casas decimais para renda em dolar
				format (c.RendaAnual/5.60, 'c', 'en-us')       [Renda anual em Dolar],
				format (C.RendaAnual/6.6,  'c', 'de-de')	      [Renda anual em Euro]
FROM		TBCliente   c
---------------------------------------------------------

-- mostra valor com duas casas depois da vírgula
SELECT STR(123.456666, 8, 2) [valor conertido para duas casas];  
------------------------------------------------------

/*
EXERCÍCIO-5
Faça um consulta que retorne:
Mostre o nome do cliente, sobrenome e a sua renda
---------------------------------------------------------------------
Classifique o cliente de acordo com a sua renda anual:
'Renda Baixa' quando tem renda menor (<) que 50.000, 
'Renda Média' quando tem renda menor (<=)ou igual a 70.000 
'Renda alta' quando  tem renda acima (>) de 70.000.
*/

-- usar   Case ... End
-----------------------------------------------------------
SELECT	c.Nome,
				c.Sobrenome,
				c.Bairro,
				format (c.RendaAnual, 'C', 'pt-br') [Renda Anual em Real],
				-- coluna calculada/criada
				CASE    WHEN c.RendaAnual   <= 50000     THEN 'Renda Baixa'
							WHEN  c.RendaAnual  <= 70000      THEN 'Renda Média'
                            ELSE   'Renda Alta'
			   End       [Tipo de Renda Anual do Cliente]
From		TBCliente		c   -- única tabela
Order by 1
--------------------------------------------------------------

/*
Continuamos na próxima aula de 14/11/2022
Ler os exercícios 
Entender a lógica e rodar para ver os resultados
*/


