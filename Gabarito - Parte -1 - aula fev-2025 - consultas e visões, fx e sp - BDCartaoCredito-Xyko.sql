/*
Linguagem SQL - � a linguagem do SGBDR
-------------------------------------------------
EXERC�CIOS Parte 1
Projeto do BDCartaoCreditoIFSP
IFSP - Barretos
Data: 2025
Prof. Xyko Almeida
-------------------------------------------------------
Objetivo: Trabalhar com consultas,Vis�es,
fun��es (fx) e Procedures (sp) em Banco de DADOS
------------------------------------------------------
*/

-- abrir o BD de trabalho.
use BDCartaoCreditoIFSP;
-------------------------------------


/*
consulta = retorno de dados
EXERC�CIOS 1
Fa�a um consulta que retorne:
Da tabela TBCliente: o nome e sobrenome do cliente, seu bairro
Campo a ser constru�do: Calcular/totalizar os d�bitos (tipo 1)
campo criado: contar quantos d�bitos tem por cliente
-- uso da fun��o de agrega��o: sum(), avg(), count() ...
*/
----------




select c.IDCliente [C�digo Cliente],
       c.Nome     Cliente,
	   c.Sobrenome,
	   c.Bairro,
--Construir os campos
     count(l.CodCartao) [Quantidade de D�bitos],
	 Sum(l.ValorLancamento)              [Total de D�bitos]
from TBCliente c
join TBCartaoCredito cc
--escrever o relacionamento(pk=fk)
on (c.IDCliente = cc.CodCliente)
join  TBLancamentoCartao    l
--escrevo o relacionamento(pk=fk)
on (cc.IDCartao=CodCartao)
--filtro de d�bito
and l.Tipolancamento = 1
group by c.IDCliente,  c.Nome , c.Sobrenome, c.Bairro
order by 6 desc


--fazer uma view do exercicio 1 
Create view VRetornaDebitosCliente
as

select c.IDCliente [C�digo Cliente],
       c.Nome     Cliente,
	   c.Sobrenome,
	   c.Bairro,
--Construir os campos
     count(l.CodCartao) [Quantidade de D�bitos],
	 Sum(l.ValorLancamento)              [Total de D�bitos]
from TBCliente c
join TBCartaoCredito cc
--escrever o relacionamento(pk=fk)
on (c.IDCliente = cc.CodCliente)
join  TBLancamentoCartao    l
--escrevo o relacionamento(pk=fk)
on (cc.IDCartao=CodCartao)
--filtro de d�bito
and l.Tipolancamento = 1
group by c.IDCliente,  c.Nome , c.Sobrenome, c.Bairro



--mostrar execu��o da view

select*from VRetornaDebitosCliente
Order by 6 desc

--fzr fun��o logica da view
--receb paremetro e retorna vendas desse cleinte 


--checar
--teste santo thorme
--teste 1 
--trazer os cartoes de cr�dito da maria
select*
from   TBCartaoCredito a
where  a.CodCliente = 2 
---------------------
--teste 2
select *
from TBLancamentoCartao m
where m.CodCartao in(4050, 5040)
and  m.TipoLancamento=1


-- 1.1 mesmo exerc�cio com inner 
Select		c.Nome			Cliente,
				c.sobrenome,
				c.Bairro,
				-- construir colunas no select
				Sum (l.ValorLancamento)    [Total D�bitos],  -- soma
				count (l.CodCartao)		        [Qtde D�bitos]    -- contar
-- traz as tabelas
from			TBCliente							c
join			TBCartaoCredito				cc
on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
join		   TBLancamentoCartao		 l
on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
-- como eu trabalhar com fun��o agrega��o (soma, m�dia m�ximo, m�nimo)
and			(l.TipoLancamento = 1)      -- filtro (1 = d�bito)
group by   c.Nome, c.sobrenome, c.Bairro
order by     1
-------------------------------------------------------------
-- Saber se acertou o exerc�cio
--- Teste de Santo Thome -------
--  Teste 1
-- Cliente lais id = 6
-- acho os cart�es da lais
-- cart�o 5020
Select	 *
from	 TBCartaoCredito   c
where   c.CodCliente = 6   -- fitro 
----------------------------------
-- teste 2
-- Total d�bito da Lais = 145,64
Select	   sum (l.ValorLancamento)		[total Debitos],
               count(l.CodCartao)				[Total de lan�amentos D�bito]
from			TBLancamentoCartao   l
where		l.CodCartao = 5020       -- cartao da Lais
and			l.TipoLancamento = 1   -- tipo d�bito
-----------------------------------------




-- 1.2) criar uma vis�o ...
-- guardar no BD o select complexo
Create view VDebitosPorCliente
AS
	Select		c.Nome			Cliente,
					c.sobrenome,
					c.Bairro,
					-- construir colunas no select
					Sum (l.ValorLancamento)    [Total D�bitos],  -- soma
					count (l.CodCartao)		        [Qtde D�bitos]    -- contar
	-- traz as tabelas
	from			TBCliente							c
	join			TBCartaoCredito				cc
	on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
	join		   TBLancamentoCartao		 l
	on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
	-- como eu trabalhar com fun��o agrega��o (soma, m�dia m�ximo, m�nimo)
	and			(l.TipoLancamento = 1)      -- filtro (1 = d�bito)
	group by   c.Nome, c.sobrenome, c.Bairro
	
-----------------------------------------
-- executar a vis�o
Select * from  VDebitosPorCliente
Order by 1
----------------------------

/* 
-- para individualizar (customizar) as consultas
1.3) Quero estes dados apenas de um �nico cliente
Criar uma "fun��o" e depois uma "procedure" que recebe um 
par�mentro e filtra pelo par�mento
-- criar uma fun��o
-- filtrar pelo c�digo do cliente
*/
Create function fxRetornaDebitoCliente (@CodCliente int)
Returns table as return
(
	Select		c.IDCliente   [C�digo Cliente],
	                c.Nome			Cliente,
					c.sobrenome,
					c.Bairro,
					-- construir colunas no select
					Sum (l.ValorLancamento)    [Total D�bitos],  -- soma
					count (l.CodCartao)		        [Qtde D�bitos]    -- contar
	-- traz as tabelas
	from			TBCliente							c
	join			TBCartaoCredito				cc
	on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
	join		   TBLancamentoCartao		 l
	on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
	-- como eu trabalhar com fun��o agrega��o (soma, m�dia m�ximo, m�nimo)
	and			(l.TipoLancamento = 1)      -- filtro (1 = d�bito)
	-- filtro pelo par�mentro recebido
	and       (c.IDCliente = @CodCliente)
	group by   c.IDCliente, c.Nome, c.sobrenome, c.Bairro
)
---------------------------------------------------
-- executar a fun��o
Select * from fxRetornaDebitoCliente (6);
Select * from fxRetornaDebitoCliente (4);
Select * from fxRetornaDebitoCliente (1);
-------------------------------------

/*
1.4) criando uma procedure para a fun��o 1.3)
-- copie e colei a fun��o
*/
-- criar a procedure
Create procedure spRetornaDebitoCliente (@CodCliente int)
AS
BEGIN
	Select		c.IDCliente   [C�digo Cliente],
	                c.Nome			Cliente,
					c.sobrenome,
					c.Bairro,
					-- construir colunas no select
					Sum (l.ValorLancamento)    [Total D�bitos],  -- soma
					count (l.CodCartao)		        [Qtde D�bitos]    -- contar
	-- traz as tabelas
	from			TBCliente							c
	join			TBCartaoCredito				cc
	on          (c.IDCliente   = cc.CodCliente)    -- relacionamento 1 (pk = fk)
	join		   TBLancamentoCartao		 l
	on 			(cc.IDCartao   = l.CodCartao)    -- relacionamento 2 (pk = fk)
	-- como eu trabalhar com fun��o agrega��o (soma, m�dia m�ximo, m�nimo)
	and			(l.TipoLancamento = 1)      -- filtro (1 = d�bito)
	-- filtro pelo par�mentro recebido
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
Exerc�cio 2
Listar os clientes: ID, Nome, Sobrenome
Contar Qtde cart�es tem
*/
-- L�gica dos relacionamentos das duas tabelas
Select		c.IDCliente   [C�digo Cliente],
				c.Nome,
				c.sobrenome,
				count (a.CodCliente)	[Qtde Cartao]
From		TBCliente					c
join		    TBCartaoCredito		a
on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
Group by	c.IDCliente , c.Nome, c.sobrenome
order by   4 desc
---------------------------
-- Teste de Santo Thom� ----
-- Maria Lima = 2 (4050, 5040)
Select		* 
from			TBCartaoCredito   c
where		c.CodCliente = 2  -- filtro]
-- 4050 e 5040
-----------------------------------

--2.1) cria uma view (vis�o) da exe 2)
Create view VQtdeCartaoCliente
As
		Select		c.IDCliente   [C�digo Cliente],
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
       tem que receber o par�mentro C�digo Cliente
*/
Create Procedure spRetornaQtdeCartaoCliente (@CodCliente int)
As
Begin
	Select		c.IDCliente   [C�digo Cliente],
					c.Nome,
					c.sobrenome,
					count (a.CodCliente)	[Qtde Cartao]
	From		TBCliente					c
	join		    TBCartaoCredito		a
	on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
	and           (c.IDCliente = @CodCliente)   -- filtrar pelo par�metro
	Group by	c.IDCliente , c.Nome, c.sobrenome
End
-----------------------------------------------------------
-- executa aprocedure (stredo procedere)
Exec spRetornaQtdeCartaoCliente 2;
Exec spRetornaQtdeCartaoCliente 4;
Exec spRetornaQtdeCartaoCliente 6;
---------------------------------------------

-- Criar uma Fun��o a aprtir da Procedure
/*
2.3) Criar uma fun��o para o execicio 2.1.
       tem que receber o par�mentro C�digo Cliente
*/
Create function fxRetornaQtdeCartaoCliente (@CodCliente int)
Returns table as return
(
	Select		c.IDCliente   [C�digo Cliente],
					c.Nome,
					c.sobrenome,
					count (a.CodCliente)	[Qtde Cartao]
	From		TBCliente					c
	join		    TBCartaoCredito		a
	on				(c.IDCliente  = a.CodCliente)   -- relacionamento (pk = fk)
	and           (c.IDCliente = @CodCliente)   -- filtrar pelo par�metro
	Group by	c.IDCliente , c.Nome, c.sobrenome
)
-----------------------------------------------------------
-- Como usar (executar) a fun��o
Select * from fxRetornaQtdeCartaoCliente (2);
Select * from fxRetornaQtdeCartaoCliente (4);
Select * from fxRetornaQtdeCartaoCliente (5);
-----------------------------------------------------------


/*
EXERC�CIOS 3
Fa�a um consulta que retorne:
Da tabela TBCliente: o nome e sobrenome do cliente, seu bairro
Campo a ser constru�do: Calcular/Totalizar os Cr�ditos (tipo 2)
Campo criado: contar quantos cr�ditos tem por cliente
-- uso da fun��o de agrega��o: sum(), avg() ...
*/
-- vers�o com inner join
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
-- como eu trabalhar com fun��o agrega��o (soma, m�dia m�ximo, m�nimo)
and			(l.TipoLancamento = 2)      -- filtro (2 = cr�dito)
group by   c.Nome, c.sobrenome, c.Bairro
order by     2
-----------------------------------
-- teste de Santo Thom� ---
-- Maria Lima = 2
-- cart�es = (4050, 5040)
Select * 
from TBCartaoCredito   c
where c.CodCliente = 2
-----------------------------------------
-- teste 2 
Select * 
from TBLancamentoCartao     l
Where  l.CodCartao  in (4050, 5040)   -- no conjunto (4050, 5040)
and		l.TipoLancamento = 2      -- ser cr�dito (tipo 2)
------------------------------------------------------------------

-- 3.2) Criar uma view
----------------------------------
-- Executar a vis�o

----------------------------------

-- 3.3) criar uma uma fun��o a partir da view 3.2)
-- Recebe como par�metro c�digo Cliente

------------------------------------------------------------
-- 3.4) criar uma uma procedure  a partir da fun��o 3.3)
-- Recebe como par�metro c�digo Cliente

------------------------------------------------------------
 
 /*
EXERC�CIO-4
Fa�a um consulta que retorne:
Mostre o nome do cliente, sobrenome e a sua renda convertida em dolar e euro.
Considerar 1 dolar a = 5.60: e 1 euro  = 6,60
*/

SELECT	c.Nome,
				c.Sobrenome,
				-- formata o n�mero padr�o real brasileiro
				format (c.RendaAnual, 'C', 'pt-br') 				 [Renda anual em Real],
				-- formatar para aparecer duas casas decimais para renda em dolar
				format (c.RendaAnual/5.60, 'c', 'en-us')       [Renda anual em Dolar],
				format (C.RendaAnual/6.6,  'c', 'de-de')	      [Renda anual em Euro]
FROM		TBCliente   c
---------------------------------------------------------

-- mostra valor com duas casas depois da v�rgula
SELECT STR(123.456666, 8, 2) [valor conertido para duas casas];  
------------------------------------------------------

/*
EXERC�CIO-5
Fa�a um consulta que retorne:
Mostre o nome do cliente, sobrenome e a sua renda
---------------------------------------------------------------------
Classifique o cliente de acordo com a sua renda anual:
'Renda Baixa' quando tem renda menor (<) que 50.000, 
'Renda M�dia' quando tem renda menor (<=)ou igual a 70.000 
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
							WHEN  c.RendaAnual  <= 70000      THEN 'Renda M�dia'
                            ELSE   'Renda Alta'
			   End       [Tipo de Renda Anual do Cliente]
From		TBCliente		c   -- �nica tabela
Order by 1
--------------------------------------------------------------

/*
Continuamos na pr�xima aula de 14/11/2022
Ler os exerc�cios 
Entender a l�gica e rodar para ver os resultados
*/


